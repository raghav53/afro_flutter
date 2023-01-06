
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'FirstOnBoard.dart';

class SecondOnBoardScreen extends StatefulWidget {
  _SecondScreen createState() => _SecondScreen();
}

class _SecondScreen extends State<SecondOnBoardScreen> {
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
                padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                child: Image.asset("assets/start_members.png"),
              ),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    height: 400,
                    child: Column(
                      crossAxisAlignment: cStart,
                      mainAxisAlignment: mEnd,
                      children: [
                        RichText(
                            text: TextSpan(
                                text: "Welcome to Afro-United",
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 105, 240, 217), fontStyle: FontStyle.normal,fontFamily: "Poppins",fontWeight: FontWeight.bold),
                                children: [
                              TextSpan(
                                  style: TextStyle(color: white, fontSize: 13, fontStyle: FontStyle.normal,fontFamily: "Poppins",fontWeight: FontWeight.bold),
                                  text:
                                      "\nAfro-unitd is a platform created to empower the Black/Afro community worldwide. Join us today and start networking with new people. We offer events, forums, and community groups that you can join and participate from the comfort of your own home and become the change within your community."
                                      )
                            ])),
                        customHeightBox(25),
                        GestureDetector(
                          onTap: () => {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FirstOnBoardScreen()))
                          },
                          child: Container(
                            height: 40,
                            width: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: commonButtonLinearGridient),
                            child: customText("Get Started", 17, white,
                                bold: "yes"),
                          ),
                        ),
                        customHeightBox(25),
                      ],
                    ),
                  ))
            ],
          )),
    ));
  }
}
