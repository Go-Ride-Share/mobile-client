import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';

class SplashScreen extends StatefulWidget {
  final Future<bool> Function() checkToken;

  const SplashScreen(this.checkToken, {Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnToken();
  }

  Future<void> _navigateBasedOnToken() async {
    bool hasToken = await widget.checkToken();
    Timer(const Duration(seconds: 4), () {
      if (hasToken) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/sign_in_page');
      }
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