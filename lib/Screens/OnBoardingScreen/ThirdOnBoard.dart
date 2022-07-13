import 'package:afro/Screens/Authentication/SignInPage.dart';
import 'package:afro/Screens/Authentication/SignInPage2.dart';
import 'package:afro/Util/SharedPreferencfes.dart';
import 'package:flutter/cupertino.dart';
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
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: new AssetImage("on_board_3.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
            margin: EdgeInsets.only(bottom: 50),
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {
                navigateToSignIn(context);
              },
              child: Padding(
                  padding: EdgeInsets.only(right: 30, left: 30),
                  child: Text('Sign In')),
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                shape: StadiumBorder(),
              ),
            )),
      )),
    );
  }
}
