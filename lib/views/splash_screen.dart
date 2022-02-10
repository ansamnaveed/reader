// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reader/views/home_screen/main_screen.dart';
import 'package:reader/widgets/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      pushReplacement(
        context,
        MainScreen(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Image(
              width: MediaQuery.of(context).size.width / 2,
              image: AssetImage(
                'assets/images/splash_logo.png',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
