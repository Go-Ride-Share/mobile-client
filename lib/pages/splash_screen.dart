import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed('/sign_in_page'); // Replace '/home' with your target route
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: notYellow, // Replace with your desired color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Image.asset('assets/images/LogoNotBlack.png'),
          ),
        ),
      );
  }
}