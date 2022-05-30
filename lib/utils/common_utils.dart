import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_shop/model/order.dart';
import 'package:online_shop/model/product.dart';
import 'package:online_shop/model/user.dart';
import 'dart:async';
import 'package:path/path.dart' as path;
import 'package:redis/redis.dart';
import 'package:shamsi_date/src/jalali/jalali_date.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'dialog/text_show_dialog.dart';

double percentW(BuildContext context, double value) {
  return MediaQuery.of(context).size.width * value;
}

double percentH(BuildContext context, double value) {
  return MediaQuery.of(context).size.height * value;
}

String replaceFarsiNumber(String input) {
  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const farsi = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];

  for (int i = 0; i < english.length; i++) {
    input = input.replaceAll(english[i], farsi[i]);
  }

  return input;
}

Future<Command> getCommandRedis() async {
  try {
    return await redisConnection.connect(ip, port);
  } catch (e) {
    throw "no internet";
  }
}

errorShow(e) {
  if (kDebugMode) {
    print(e.toString());
  }
}

bool isNull(dynamic value) {
  if (value != null) {
    return false;
  } else {
    return true;
  }
}

bool validation(text, context) {
  if (text == "") {
    showDialog(
        context: context,
        builder: (context) =>
            const TextShowDialog("خطا", "تمام پارامتر های را پر کنید"));
    return true;
  } else {
    return false;
  }
}

String getFirstWord(String name) {
  try {
    return name.split(" ")[0];
  } catch (e) {
    return "";
  }
}

Product removeUnnecessaryFieldsFromProduct(Product product) {
  product.numberItem = null;
  product.characteristics = null;

  return product;
}

List<Order>? getListOrders(dynamic response) {
  try {
    List<dynamic> orders = json.decode(response);

    List<Order>? listOrders = <Order>[];
    for (int i = 0; i < orders.length; i++) {
      listOrders.add(Order.fromJson(orders[i]));
    }

    return listOrders;
  } catch (e) {
    return null;
  }
}

String convertDateToJalali(Jalali jalali) {
  return jalali.year.toString() +
      "/" +
      jalali.month.toString() +
      "/" +
      jalali.day.toString();
}

List<Product> getListProducts(dynamic response) {
  List<Product>? listProduct = <Product>[];
  for (int i = 0; i < response.length; i++) {
    if (response[i].toString().contains("{")) {
      listProduct.add(Product.fromJson(json.decode(response[i])));
    }
  }

  return listProduct;
}

List<Product> getListProductsIndex(dynamic response) {
  List<dynamic> products = json.decode(response);
  List<Product>? listProduct = <Product>[];
  for (int i = 0; i < products.length; i++) {
    listProduct.add(Product.fromJson(products[i]));
  }

  return listProduct;
}

void toastShow(value) {
  Fluttertoast.showToast(msg: value, toastLength: Toast.LENGTH_SHORT);
}

bool isNumeric(String string) {
  if (string.isEmpty) {
    return false;
  }

  final number = num.tryParse(string);

  if (number == null) {
    return false;
  }

  return true;
}

Future<File> changeFileNameOnly(File file, String newFileName) {
  var path = file.path;
  var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
  var newPath = path.substring(0, lastSeparator + 1) + newFileName;
  return file.rename(newPath);
}

String getFileNameInModelNameFile(String pathh) {
  String basename = path.basename(pathh);
  List<String> splits = basename.split("_");
  return splits[1];
}

bool isVideo(String path) {
  RegExp exp = RegExp(
      r"((?:www\.)?(?:\S+)(?:%2F|\/)(?:(?!\.(?:mp4|mkv|wmv|m4v|mov|avi|flv|webm|flac|mka|m4a|aac|ogg))[^\/])*\.(mp4|mkv|wmv|m4v|mov|avi|flv|webm|flac|mka|m4a|aac|ogg))(?!\/|\.[a-z]{1,3})");

  if (exp.hasMatch(path)) {
    return true;
  } else {
    return false;
  }
}

bool isLink(link) {
  try {
    return link.contains("http");
  } catch (e) {
    return false;
  }
}

exitApplication() {
  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
}

String toPersian(String time) {
  time = replaceFarsiNumber(time);
  time = time.replaceAll("a few seconds", "چند ثانیه");
  time = time.replaceAll("a minute", "یک دقیقه");
  time = time.replaceAll("minutes", "دقیقه");
  time = time.replaceAll("an hour", "یک ساعت");
  time = time.replaceAll("hours", "ساعت");
  time = time.replaceAll("a day", "یک روز");
  time = time.replaceAll("days", "روز");
  time = time.replaceAll("a month", "یک ماه");
  time = time.replaceAll("months", "ماه");
  time = time.replaceAll("a year", "یک سال");
  time = time.replaceAll("years", "سال");
  time = time.replaceAll("in", "در");
  time = time.replaceAll("ago", "پیش");
  return time;
}

Future<void> saveUser(User user) async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;

  prefs.setString("user", json.encode(user.toJson()));
}

Future<void> removeUser() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final SharedPreferences prefs = await _prefs;

  prefs.remove("user");
}

Future<User?> getUser() async {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  try {
    final SharedPreferences prefs = await _prefs;
    return User.fromJson(json.decode(prefs.getString("user")!));
  } catch (e) {
    return null;
  }
}

/// A method returns a human readable string representing a file _size
String fileSize(dynamic size, [int round = 2]) {
  /**
   * [size] can be passed as number or as string
   *
   * the optional parameter [round] specifies the number
   * of digits after comma/point (default is 2)
   */
  int divider = 1024;
  int _size;
  try {
    _size = int.parse(size.toString());
  } catch (e) {
    throw ArgumentError("Can not parse the size parameter: $e");
  }

  if (_size < divider) {
    return "$_size B";
  }

  if (_size < divider * divider && _size % divider == 0) {
    return "${(_size / divider).toStringAsFixed(0)} KB";
  }

  if (_size < divider * divider) {
    return "${(_size / divider).toStringAsFixed(round)} KB";
  }

  if (_size < divider * divider * divider && _size % divider == 0) {
    return "${(_size / (divider * divider)).toStringAsFixed(0)} MB";
  }

  if (_size < divider * divider * divider) {
    return "${(_size / divider / divider).toStringAsFixed(round)} MB";
  }

  if (_size < divider * divider * divider * divider && _size % divider == 0) {
    return "${(_size / (divider * divider * divider)).toStringAsFixed(0)} GB";
  }

  if (_size < divider * divider * divider * divider) {
    return "${(_size / divider / divider / divider).toStringAsFixed(round)} GB";
  }

  if (_size < divider * divider * divider * divider * divider &&
      _size % divider == 0) {
    num r = _size / divider / divider / divider / divider;
    return "${r.toStringAsFixed(0)} TB";
  }

  if (_size < divider * divider * divider * divider * divider) {
    num r = _size / divider / divider / divider / divider;
    return "${r.toStringAsFixed(round)} TB";
  }

  if (_size < divider * divider * divider * divider * divider * divider &&
      _size % divider == 0) {
    num r = _size / divider / divider / divider / divider / divider;
    return "${r.toStringAsFixed(0)} PB";
  } else {
    num r = _size / divider / divider / divider / divider / divider;
    return "${r.toStringAsFixed(round)} PB";
  }
}

String ellipsisTextString(String text, int length) {
  if (text.length > length) {
    text = text.substring(0, length) + "...";
  }
  return text;
}
