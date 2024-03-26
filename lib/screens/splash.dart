// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/auth_gate.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Get.offAll(() => const AuthGate());
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Blood Point ',style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
                fontSize: 30,
              ),),
              SizedBox(height: Get.height*.1,),
          Expanded(
            flex: 0,
            child: Container(
              width: Get.width,
              alignment: Alignment.center,
              child: Lottie.asset('assets/splash_icon.json'),
            ),
          )
        ],
      ),
      ),
    );
  }
}
