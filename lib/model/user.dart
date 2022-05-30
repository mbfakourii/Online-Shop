class User {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? image;
  String? userName;
  String? password;
  bool? isAdmin;

  User(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.userName,
      required this.password,
      required this.isAdmin,
      required this.image});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    userName = json['userName'];
    password = json['password'];
    isAdmin = json['isAdmin'] ?? false;
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['isAdmin'] = isAdmin;
    data['userName'] = userName;
    data['password'] = password;
    data['image'] = image;
    return data;
  }
}
