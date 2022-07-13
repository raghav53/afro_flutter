import 'package:afro/Screens/OnBoardingScreen/ThirdOnBoard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecondOnBoardScreen extends StatefulWidget {
  _SecondScreen createState() => _SecondScreen();
}

class _SecondScreen extends State<SecondOnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
          body: Container(
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  image: new AssetImage("on_board_2.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () => {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ThirdOnBoardScreen()))
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
