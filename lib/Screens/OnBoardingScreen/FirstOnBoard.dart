import 'package:afro/Screens/OnBoardingScreen/SecondOnBoard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FirstOnBoardScreen extends StatefulWidget {
  _FirstScreen createState() => _FirstScreen();
}

class _FirstScreen extends State<FirstOnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
          body: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("on_board_1.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SecondOnBoardScreen()))
                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Image.asset("assets/icons/ic_next.png"),
                  ),
                ),
              ))),
    );
  }
}
