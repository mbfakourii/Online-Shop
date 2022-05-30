import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:online_shop/model/user.dart';
import 'package:online_shop/screen/home/home.dart';
import 'package:online_shop/screen/welcome/welcome.dart';
import 'package:online_shop/utils/common_utils.dart';
import 'package:redis/redis.dart';

import '../../main.dart';
import '../../repositories/main_req.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  MainReq mainReq = MainReq();
  String errorShow = "";

  bool error = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      connect();
    });
  }

  void connect() async {
    error = false;
    errorShow = "فروشگاه اینترنتی";
    setState(() {});
    if (await connectToRedis()) {
      User? user = await getUser();
      Future.delayed(const Duration(seconds: 2), () {
        if (user != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Home(user)));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Welcome()));
        }
      });
    } else {
      setState(() {
        error = true;
        errorShow = "خطا در اتصال به سرور";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          // Start Main col
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage("assets/images/logo.png"),
                width: percentW(context, 0.30),
                height: percentH(context, 0.30),
              ),
              Text(
                errorShow,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                    color: Color(0xff2B2B2B)),
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: error,
                child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xff07c15f)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    onPressed: () async {
                      connect();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 5, left: 5),
                      child: Text(
                        "برسی مجدد",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    )),
              ),
            ],
          ))),
    );
  }

  Future<bool> connectToRedis() async {
    try {
      await redisConnection.connect(ip, port);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return false;
    }
  }
}
