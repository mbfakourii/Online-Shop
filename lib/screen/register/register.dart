import 'dart:io';

import 'package:flutter/material.dart';
import 'package:online_shop/model/user.dart';
import 'package:online_shop/repositories/main_req.dart';
import 'package:online_shop/screen/home/home.dart';
import 'package:online_shop/screen/register/widgets/select_picture.dart';
import 'package:online_shop/utils/common_utils.dart';
import 'package:online_shop/utils/dialog/text_show_dialog.dart';
import 'package:online_shop/utils/error_loading.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();

  ValueNotifier<File> image = ValueNotifier<File>(File(""));

  ValueNotifier<ELM> callback = ValueNotifier<ELM>(ELM());

  MainReq mainReq = MainReq();

  @override
  Widget build(BuildContext context) {
    return ErrorLoading(
      context,
      callback: callback,
      onTry: (value) {
        if (value == "1") {}
      },
      child: Scaffold(
          body: SafeArea(
              child: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
              "ثبت نام",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Divider(color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: TextField(
                          keyboardType: TextInputType.name,
                          controller: firstName,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintText: 'نام را وارد کنید',
                              suffixIcon: IconButton(
                                onPressed: firstName.clear,
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xff7F7F7F),
                                ),
                              ))),
                    ),
                  ),
                  const Expanded(
                      flex: 2,
                      child: Text(
                        "نام",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xff2B2B2B)),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: TextField(
                          keyboardType: TextInputType.name,
                          controller: lastName,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintText: 'نام خانوادگی را وارد کنید',
                              suffixIcon: IconButton(
                                onPressed: lastName.clear,
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xff7F7F7F),
                                ),
                              ))),
                    ),
                  ),
                  const Expanded(
                      flex: 3,
                      child: Text(
                        "نام خانوادگی",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xff2B2B2B)),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: TextField(
                          keyboardType: TextInputType.name,
                          controller: userName,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintText: 'نام کاربری را وارد کنید',
                              suffixIcon: IconButton(
                                onPressed: userName.clear,
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xff7F7F7F),
                                ),
                              ))),
                    ),
                  ),
                  const Expanded(
                      flex: 3,
                      child: Text(
                        "نام کاربری",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xff2B2B2B)),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: TextField(
                          keyboardType: TextInputType.number,
                          controller: password,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintText: 'رمز عبور را وارد کنید',
                              suffixIcon: IconButton(
                                onPressed: password.clear,
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xff7F7F7F),
                                ),
                              ))),
                    ),
                  ),
                  const Expanded(
                      flex: 2,
                      child: Text(
                        "رمز عبور",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xff2B2B2B)),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: email,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintText: 'ایمیل را وارد کنید',
                              suffixIcon: IconButton(
                                onPressed: email.clear,
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xff7F7F7F),
                                ),
                              ))),
                    ),
                  ),
                  const Expanded(
                      flex: 2,
                      child: Text(
                        "ایمیل",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xff2B2B2B)),
                      )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 10,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: TextField(
                          keyboardType: TextInputType.phone,
                          controller: phone,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintText: 'شماره تماس را وارد کنید',
                              suffixIcon: IconButton(
                                onPressed: phone.clear,
                                icon: const Icon(
                                  Icons.clear,
                                  color: Color(0xff7F7F7F),
                                ),
                              ))),
                    ),
                  ),
                  const Expanded(
                      flex: 3,
                      child: Text(
                        "شماره تماس",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xff2B2B2B)),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              "تصویر پروفایل",
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xff2B2B2B)),
            ),
            const SizedBox(height: 10),
            SelectPicture(image: image),
            const SizedBox(height: 18),
            SizedBox(
              width: 140,
              child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xff07c15f)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                  onPressed: () async {
                    if (image.value.path == "") {
                      showDialog(
                          context: context,
                          builder: (context) => const TextShowDialog(
                              "خطا", "تصویر باید انتخاب شود"));
                      return;
                    }

                    // Validation
                    if (validation(firstName.text, context)) {
                      return;
                    }

                    if (validation(lastName.text, context)) {
                      return;
                    }

                    if (validation(userName.text, context)) {
                      return;
                    }

                    if (validation(password.text, context)) {
                      return;
                    }

                    if (validation(email.text, context)) {
                      return;
                    }

                    if (validation(phone.text, context)) {
                      return;
                    }

                    // send data
                    callback.value = ELM().showLoading();
                    try {
                      User? user = await mainReq.register(
                          firstName.text,
                          lastName.text,
                          userName.text,
                          password.text,
                          email.text,
                          phone.text,
                          image.value);

                      toastShow("با موفقیت وارد شدید");
                      Navigator.of(context).pop();
                      user!.userName=userName.text;
                      await saveUser(user);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home(user)));
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              TextShowDialog("خطا", e.toString()));
                    }
                    callback.value = ELM().hiddenLoading();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(right: 5, left: 5),
                    child: Text(
                      "ثبت نام",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  )),
            ),
            const SizedBox(height: 18),
          ],
        ),
      ))),
    );
  }
}
