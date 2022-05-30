import 'package:flutter/material.dart';
import 'package:redis/redis.dart';
import 'screen/splash/splash.dart';

// Enable AOF
// config set appendonly yes

late BuildContext mainContext;
RedisConnection redisConnection = RedisConnection();
List<String> listMainType = <String>[];

String ip = '86.106.142.121';
int port = 6379;

void main() {
  listMainType.add("تلویزیون");
  listMainType.add("موبایل");
  listMainType.add("لبتاب");
  listMainType.add("هدفون");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Online Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Splash(),
    );
  }
}
