import 'dart:io';
import 'dart:convert';
import 'package:online_shop/model/order.dart';
import 'package:online_shop/model/product.dart';
import 'package:online_shop/model/user.dart';
import 'package:online_shop/utils/common_utils.dart';

class MainReq {
  // Register User
  Future<User?> register(String firstName, String lastName, String userName,
      String password, String email, String phone, File image) async {
    // Check User Exist
    User? userLogin = await login(userName, password);
    if (userLogin != null) {
      return userLogin;
    }

    // Fill User Model
    List<int> imageBytes = image.readAsBytesSync();
    String base64Image = const Base64Codec().encode(imageBytes);
    User user = User(
      firstName: firstName,
      lastName: lastName,
      userName: userName,
      password: password,
      email: email,
      phone: phone,
      isAdmin: false,
      image: base64Image,
    );

    // Add User In Hash user
    await (await getCommandRedis())
        .send_object(["HSET", "user", userName, json.encode(user.toJson())]);

    return user;
  }

  // Login User
  Future<User?> login(String userName, String password) async {
    dynamic response =
        await (await getCommandRedis()).send_object(["HGET", "user", userName]);

    if (response == null) {
      return null;
    } else {
      User user = User.fromJson(json.decode(response));
      user.userName = userName;

      // check user Password
      if (user.password == password) {
        return user;
      } else {
        return null;
      }
    }
  }

  // Add Product For Admin
  Future<bool?> addProduct(String name, String type, int numberItem, int price,
      List<List<String>> characteristic) async {
    // Check Product Exist
    Product? productGet = await getProduct(name);
    if (productGet != null) {
      return false;
    }

    // Fill Product Model
    Product product = Product(
      name: name,
      type: type,
      numberItem: numberItem,
      price: price,
      characteristics: characteristic,
    );

    // Add Product In Hash product and product_index
    await (await getCommandRedis())
        .send_object(["HSET", "product", name, json.encode(product.toJson())]);

    // Add Product In Product Index for Searching
    product = removeUnnecessaryFieldsFromProduct(product);
    String firstWord = getFirstWord(name);

    // get products with first word
    List<Product>? getListProductsIndex = await getProductsIndex(firstWord);

    if (getListProductsIndex != null) {
      // if exist word in product_index hash update and add new product in product_index hash
      getListProductsIndex.add(product);

      await (await getCommandRedis()).send_object([
        "HSET",
        "product_index",
        firstWord,
        json.encode(getListProductsIndex)
      ]);
    } else {
      // Add Product in bank if not found in product_index hash
      await (await getCommandRedis()).send_object([
        "HSET",
        "product_index",
        firstWord,
        json.encode(<Product>[product])
      ]);
    }

    return true;
  }

  // Get One Product
  Future<Product?> getProduct(String name) async {
    var a =
        await (await getCommandRedis()).send_object(["HGET", "product", name]);

    if (a == null) {
      return null;
    } else {
      return Product.fromJson(json.decode(a));
    }
  }

  // Get One Product Index
  Future<List<Product>?> getProductsIndex(String word) async {
    var response = await (await getCommandRedis())
        .send_object(["HGET", "product_index", word]);

    if (response == null) {
      return null;
    } else {
      return getListProductsIndex(response);
    }
  }

  // Get Products For Main Page
  Future<List<Product>?> getProducts(String searchWord) async {
    dynamic response;

    if (searchWord == "") {
      // get all Products in hash product
      response =
          await (await getCommandRedis()).send_object(["HGETALL", "product"]);
    } else {
      // search word in product_index with search word
      response = await (await getCommandRedis())
          .send_object(["HGET", "product_index", searchWord]);
    }

    if (response == null) {
      return null;
    } else {
      if (searchWord == "") {
        return getListProducts(response);
      } else {
        return getListProductsIndex(response);
      }
    }
  }

  // Get User Basket With UserName
  Future<List<Product>?> getUserBasket(String userName) async {
    dynamic response = await (await getCommandRedis())
        .send_object(["HGET", "basket", userName]);

    if (response == null) {
      return null;
    } else {
      return getListProductsIndex(response);
    }
  }

  // Buy All Product Basket
  Future<bool> buy(String userName, List<Product> product) async {
    // clear all product from basket
    clearBasket(userName);

    // get user orders and add new order and update order hash
    List<Order> orders = <Order>[];
    try {
      orders = (await getOrders(userName))!;
    } catch (e) {
      orders = <Order>[];
      errorShow(e);
    }

    orders.add(Order(
        product: product,
        status: "ثبت شده",
        dateTime: DateTime.now().toIso8601String()));

    // Add Order In Hash order
    await (await getCommandRedis())
        .send_object(["HSET", "order", userName, json.encode(orders)]);

    return true;
  }

  // Clear User Basket
  Future<bool> clearBasket(String userName) async {
    dynamic response = await (await getCommandRedis())
        .send_object(["HDEL", "basket", userName]);

    if (response == null || response == 0) {
      return false;
    } else {
      return true;
    }
  }

  // Delete One Product From Basket with userName
  Future<bool> deleteFromBasket(String userName, Product product) async {
    //Get all Products in Basket and remove target product in list
    List<Product>? productList = await getUserBasket(userName);
    if (productList != null) {
      // Exist Product in list
      for (int i = 0; i < productList.length; i++) {
        if (productList[i].name == product.name) {
          productList.removeAt(i);
          break;
        }
      }
    } else {
      return false;
    }

    // if basket and product list empty
    dynamic response;
    if (productList.isEmpty) {
      // clear all product in Basket
      clearBasket(userName);
    } else {
      // save product list
      response = await (await getCommandRedis())
          .send_object(["HSET", "basket", userName, json.encode(productList)]);
    }

    if (response == null || response == 0) {
      return false;
    } else {
      return true;
    }
  }

  // Add Product In Basket
  Future<bool?> addInBasket(String userName, Product product) async {
    // remove Unnecessary Fields From Product object
    product = removeUnnecessaryFieldsFromProduct(product);

    // get User basket and add new product in basket hash
    List<Product>? productList = await getUserBasket(userName);

    // check user product is empty or no empty
    dynamic response;
    if (productList != null) {
      // if Exist Product in list return null and no add !
      for (Product thisProduct in productList) {
        if (thisProduct.name == product.name) {
          return null;
        }
      }

      // add new product in list and update user basket hash
      productList.add(product);

      response = await (await getCommandRedis())
          .send_object(["HSET", "basket", userName, json.encode(productList)]);
    } else {
      // add new product if basket empty user
      response = await (await getCommandRedis()).send_object([
        "HSET",
        "basket",
        userName,
        json.encode(<Product>[product])
      ]);
    }

    if (response == null) {
      return false;
    } else {
      return true;
    }
  }

  // Delete Product For Admin
  Future<bool?> deleteProduct(String userName, Product product) async {
    // Delete Product in Hash product
    dynamic response = await (await getCommandRedis())
        .send_object(["HDEL", "product", product.name]);

    // Delete this Product in Basket Users
    deleteFromBasket(userName, product);

    // Delete Product in Hash product_index
    String firstWord = getFirstWord(product.name!);
    List<Product>? getListProductsIndex = await getProductsIndex(firstWord);

    if (getListProductsIndex != null) {
      // remove Product in list
      for (int i = 0; i < getListProductsIndex.length; i++) {
        getListProductsIndex.removeAt(i);
        break;
      }

      // Update product_index
      await (await getCommandRedis()).send_object([
        "HSET",
        "product_index",
        firstWord,
        json.encode(getListProductsIndex)
      ]);
    } else {
      // Delete Product in Hash product_index
      await (await getCommandRedis())
          .send_object(["HDEL", "product_index", firstWord]);
    }

    if (response == null || response == 0) {
      return false;
    } else {
      return true;
    }
  }

  // Get Orders
  Future<List<Order>?> getOrders(String userName) async {
    dynamic response = await (await getCommandRedis())
        .send_object(["HGET", "order", userName]);

    if (response == null) {
      return null;
    } else {
      return getListOrders(response);
    }
  }
}
