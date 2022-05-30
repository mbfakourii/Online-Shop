import 'package:flutter/material.dart';
import 'package:online_shop/screen/login/login.dart';
import 'package:online_shop/screen/register/register.dart';
import 'package:online_shop/utils/common_utils.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(
      children: [
        const Expanded(child: SizedBox()),
        Image(
          image: const AssetImage("assets/images/logo.png"),
          width: percentW(context, 0.30),
          height: percentH(context, 0.30),
        ),
        const Text(
          "به بزرگترین فروشگاه آنلاین ایران خوش آمدید",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 10),
        const Text(
          "اگر عضو هستید وارد شوید \nدر غیر اینصورت میتوانید به ما بپیوندید",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: 140,
          child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff0ed4d4)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 5, left: 5),
                child: Text(
                  "ورود",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )),
        ),
        SizedBox(
          width: 160,
          child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xff07c15f)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Register()),
                );
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 5, left: 5),
                child: Text(
                  "ثبت نام",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )),
        ),
        const Expanded(child: SizedBox()),
      ],
    ))));
  }
}
