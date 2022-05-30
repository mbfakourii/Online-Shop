import 'package:online_shop/model/product.dart';

class Order {
  List<Product>? product;
  String? status;
  String? dateTime;

  Order({
    this.product,
    this.status,
    this.dateTime,
  });

  Order.fromJson(Map<String, dynamic> json) {
    List<Product> productParser = <Product>[];
    for (int i = 0; i < json['product'].length; i++) {
      productParser.add(Product.fromJson(json['product'][i]));
    }

    product = productParser;

    status = json['status'];
    dateTime = json['dateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product'] = product;
    data['status'] = status;
    data['dateTime'] = dateTime;
    return data;
  }
}
