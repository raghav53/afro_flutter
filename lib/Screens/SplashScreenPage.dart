import 'dart:async';


import 'package:afro/Screens/Authentication/SignInPage2.dart';
import 'package:afro/Screens/HomePageScreen.dart';
import 'package:afro/Screens/OnBoardingScreen/FirstOnBoard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DashboardScreenPage.dart';

class SplashScreenPage extends StatefulWidget {
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreenPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    checkUserExist(context);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      child: Image.asset(
        "splash_screen.png",
        fit: BoxFit.fitWidth,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    ));
  }

  Future<void> checkUserExist(BuildContext context) async {
    SharedPreferences sharedPreferences = await _prefs;
    String? checkLogin = sharedPreferences.getString("login");
    String? onBorading = sharedPreferences.getString("onBoarding");
    String? token = sharedPreferences.getString("token");
    if (checkLogin == "yes") {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePagescreen())));
    } else {
      if (onBorading == "yes") {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen())));
      } else {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => FirstOnBoardScreen())));
      }
    }
  }
}
