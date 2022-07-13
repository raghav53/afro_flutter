import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllMembers extends StatefulWidget {
  _AllMembersPageScreen createState() => _AllMembersPageScreen();
}

class _AllMembersPageScreen extends State<AllMembers> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              customHeadingPart("All Members"),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: cStart,
                  children: [
                    customHeightBox(50),
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: Colors.black, offset: Offset(0, 2))
                          ]),
                      height: 50,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFFDFB48C),
                            ),
                            border: InputBorder.none,
                            hintText: "Search",
                            contentPadding:
                                const EdgeInsets.only(left: 15, top: 15),
                            hintStyle: const TextStyle(color: Colors.white24)),
                      ),
                    ),
                    customHeightBox(20),
                    Container(
                      height: 670,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Color(0XFF121220)),
                      child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Allmembers();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}

class Allmembers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color(0xFF191831),
        ),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("tom_cruise.jpeg"),
              ),
              customWidthBox(10),
              Column(
                crossAxisAlignment: cStart,
                children: [
                  customText("Tom Cruise", 13, Colors.white),
                  customHeightBox(2),
                  Row(
                    children: [
                      Image.asset(
                        "assets/language/france.png",
                        height: 15,
                        width: 15,
                      ),
                      customWidthBox(20),
                      Image.asset(
                        "assets/language/germany.png",
                        height: 15,
                        width: 15,
                      )
                    ],
                  ),
                  customText("Share 2 Mutual friend", 12, Color(0x3dFFFFFF)),
                ],
              ),
              Spacer(),
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: fixedButtonDesign(),
                  child: Container(
                      padding: EdgeInsets.only(
                          top: 10, left: 20, right: 20, bottom: 10),
                      child: customText("UnFriend", 12, Colors.white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
