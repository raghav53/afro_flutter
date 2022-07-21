import 'package:afro/Screens/Authentication/SignInPage2.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';

import 'package:afro/Util/SharedPreferencfes.dart';

import 'package:flutter/material.dart';

class ThirdOnBoardScreen extends StatefulWidget {
  _ThirdScreen createState() => _ThirdScreen();
}

class _ThirdScreen extends State<ThirdOnBoardScreen> {
  void navigateToSignIn(BuildContext context) async {
    await SaveStringToSF("onBoarding", "yes");
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
            child: Image.asset("assets/start_group_img.png"),
          ),
          customHeightBox(25),
          customText("CONNECTED", 20, white),
          customHeightBox(20),
          customText("Search and connect with other communites", 15, white),
          customHeightBox(40),
          InkWell(
            onTap: () {
              navigateToSignIn(context);
            },
            child: Container(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 50, right: 50),
              decoration: BoxDecoration(
                  gradient: commonButtonLinearGridient,
                  borderRadius: BorderRadius.circular(50)),
              child: customText("Sign In", 15, white),
            ),
          )
        ]),
      )),
    );
  }
}
