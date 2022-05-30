class Product {
  String? name;
  String? type;
  int? numberItem;
  int? price;
  List<dynamic>? characteristics;

  Product(
      {this.name,
      this.type,
      this.numberItem,
      this.price,
      this.characteristics});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    numberItem = json['numberItem'];
    price = json['price'];
    characteristics = json['characteristics'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    if (numberItem != null) {
      data['numberItem'] = numberItem;
    }
    data['price'] = price;
    if (characteristics != null) {
      data['characteristics'] = characteristics;
    }
    return data;
  }
}
