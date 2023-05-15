import 'dart:async';
import 'package:flutter/material.dart';
import '../allscreen/mainlogin.dart';


class SplashServices {
  void islogin(BuildContext context) {
    Timer(
      const Duration(seconds: 6),
      () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginMainScreen()),
      ),
    );
  }
}
