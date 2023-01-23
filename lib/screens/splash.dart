import 'dart:async';

import 'package:accounting_portal/screens/dashboard_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import '../widgets/color.dart';
import 'login_screen.dart';

Color okay = Colors.blue.shade700;

Size mq;

class SplashScreen extends StatefulWidget {
  const SplashScreen({key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  dynamic checkUser() async {
    final box = await Hive.openBox('user');
    if (box.get('isLogged') ?? false) {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => DashboardScreen()),
          (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const LoginScreen()),
          (route) => false);
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), checkUser);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: AppColors.accentColor));

    mq = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: okay,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: mq.height * .15,
                  child: Image.asset('assets/images/image.png')),
              const Text(
                'SNO',
                style: TextStyle(
                    fontSize: 45,
                    color: Colors.white,
                    fontFamily: 'Lemon'),
              )
            ],
          ),
        ));
  }
}
