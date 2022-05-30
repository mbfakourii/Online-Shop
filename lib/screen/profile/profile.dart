import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/model/user.dart';
import 'package:online_shop/screen/basket/basket.dart';
import 'package:online_shop/screen/orders/orders.dart';
import 'package:online_shop/screen/product/add_product.dart';
import 'package:online_shop/screen/welcome/welcome.dart';
import 'package:online_shop/utils/common_utils.dart';
import 'package:online_shop/utils/image_show.dart';

class Profile extends StatefulWidget {
  const Profile(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "پروفایل",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(0xff2B2B2B)),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Text(
                        widget.user.firstName! + " " + widget.user.lastName!,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xff2B2B2B)),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: () {
                        try {
                          return Image.memory(
                              const Base64Codec().decode(widget.user.image!));
                        } catch (e) {
                          return Container(
                              color: Colors.lightGreen,
                              height: 145,
                              child: const Center(child: Text("بدون عکس")));
                        }
                      }(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "نام : " + widget.user.firstName!,
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xff2B2B2B)),
                        ),
                        Text(
                          "نام خانوادگی : " + widget.user.lastName!,
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xff2B2B2B)),
                        ),
                        Text(
                          "نام کاربری : " + widget.user.userName!,
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xff2B2B2B)),
                        ),
                        Text(
                          "ایمیل : " + widget.user.email!,
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xff2B2B2B)),
                        ),
                        Text(
                          "شماره تماس : " + widget.user.phone!,
                          textAlign: TextAlign.end,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xff2B2B2B)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: Card(
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 2.0, bottom: 0, left: 8.0, right: 8.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          InkWell(
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.restore,
                                      size: 20,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 13, right: 18),
                                      child: Text(
                                        "سفارش های من",
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffE3E5E8),
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: const Icon(
                                        Icons.navigate_before,
                                        size: 18,
                                        color: Color(0xff76787d),
                                      ),
                                    ),
                                  ],
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Orders(widget.user)),
                              );
                            },
                          ),
                          const Divider(thickness: 0.1, color: Colors.black),
                          InkWell(
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.shopping_basket_outlined,
                                      size: 20,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 13, right: 18),
                                      child: Text(
                                        "سبد خرید",
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffE3E5E8),
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: const Icon(
                                        Icons.navigate_before,
                                        size: 18,
                                        color: Color(0xff76787d),
                                      ),
                                    ),
                                  ],
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Basket(widget.user)),
                              );
                            },
                          ),
                          Visibility(
                              visible: widget.user.isAdmin!,
                              child: const Divider(
                                  thickness: 0.1, color: Colors.black)),
                          Visibility(
                            visible: widget.user.isAdmin!,
                            child: InkWell(
                              child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    textDirection: TextDirection.rtl,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.add_circle_outline,
                                        size: 20,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(
                                            left: 13, right: 18),
                                        child: Text(
                                          "اضافه کردن کالا (ادمین)",
                                          textAlign: TextAlign.end,
                                        ),
                                      ),
                                      const Expanded(
                                        child: SizedBox(),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xffE3E5E8),
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: const Icon(
                                          Icons.navigate_before,
                                          size: 18,
                                          color: Color(0xff76787d),
                                        ),
                                      ),
                                    ],
                                  )),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddProduct(widget.user)),
                                );
                              },
                            ),
                          ),
                          const Divider(thickness: 0.1, color: Colors.black),
                          InkWell(
                            child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  textDirection: TextDirection.rtl,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.exit_to_app,
                                      size: 20,
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 13, right: 18),
                                      child: Text(
                                        "خروج از پروفایل",
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xffE3E5E8),
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                      child: const Icon(
                                        Icons.navigate_before,
                                        size: 18,
                                        color: Color(0xff76787d),
                                      ),
                                    ),
                                  ],
                                )),
                            onTap: () async {
                              await removeUser();
                              toastShow("با موفقیت از پروفایل خارج شدید");
                              Navigator.of(context).pop();
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Welcome()));
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
