import 'package:afro/Screens/OnBoardingScreen/SecondOnBoard.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';

import 'package:flutter/material.dart';

class FirstOnBoardScreen extends StatefulWidget {
  _FirstScreen createState() => _FirstScreen();
}

class _FirstScreen extends State<FirstOnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
              height: phoneHeight(context),
              width: phoneWidth(context),
              decoration: commonBoxDecoration(),
              child: Stack(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 25),
                    child: Image.asset("assets/start_members.png"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 100),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        children: [
                          customWidthBox(10),
                          RichText(
                              text: TextSpan(
                                  text: "Group's",
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color:
                                          Color.fromARGB(255, 105, 240, 217)),
                                  children: [
                                TextSpan(
                                    style:
                                        TextStyle(color: white, fontSize: 30),
                                    text:
                                        "\nLet's Create\na space\nfor your\nworkflow")
                              ])),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SecondOnBoardScreen()))
                            },
                            child: Image.asset("assets/icons/ic_next.png"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }
}
