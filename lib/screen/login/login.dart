import 'package:flutter/material.dart';
import 'package:online_shop/model/user.dart';
import 'package:online_shop/repositories/main_req.dart';
import 'package:online_shop/screen/home/home.dart';
import 'package:online_shop/utils/common_utils.dart';
import 'package:online_shop/utils/dialog/text_show_dialog.dart';
import 'package:online_shop/utils/error_loading.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final userName = TextEditingController();
  final password = TextEditingController();

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
              child: Column(
        children: [
          const Expanded(child: SizedBox()),
          const Text(
            "ورود",
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Divider(color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(120.0),
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
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(120.0),
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
                  if (validation(userName.text, context)) {
                    return;
                  }

                  if (validation(password.text, context)) {
                    return;
                  }

                  // send data
                  callback.value = ELM().showLoading();
                  try {
                    User? user =
                        await mainReq.login(userName.text, password.text);

                    if (user != null) {
                      toastShow("با موفقیت وارد شدید");
                      Navigator.of(context).pop();
                      user.userName=userName.text;
                      await saveUser(user);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Home(user)));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => const TextShowDialog(
                              "خطا", "نام کاربری یا رمز عبور اشتباه است"));
                    }
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
                    "ورود",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15),
                  ),
                )),
          ),
          const Expanded(child: SizedBox()),
        ],
      ))),
    );
  }
}
