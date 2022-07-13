import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:percent_indicator/linear_percent_indicator.dart';

class MembershipScreenPage extends StatefulWidget {
  const MembershipScreenPage({Key? key}) : super(key: key);

  @override
  State<MembershipScreenPage> createState() => _MembershipScreenPageState();
}

class _MembershipScreenPageState extends State<MembershipScreenPage> {
  var basic = 89;
  var Premium = 323;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: commonAppbar("Membership"),
        body: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          padding: EdgeInsets.only(top: 100, left: 20, right: 20),
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: cStart,
              children: [
                //Profile Image
                Center(
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: yellowColor, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        backgroundImage: AssetImage("tom_cruise.jpeg"),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  width: phoneWidth(context) * 1.5,
                  decoration: BoxDecoration(
                      color: black, borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                    child: Column(
                      children: [
                        customText("Hi, Tom Cruise", 15, white),
                        customHeightBox(5),
                        customText("Unlimited Membership", 16, white),
                        customHeightBox(5),
                        customText("Valid Up to 23 Mar 2022", 13, white),
                        customHeightBox(30),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(left: 20, right: 20),
                          height: 70,
                          decoration: BoxDecoration(
                              color: Color(0xFF18182C),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Row(crossAxisAlignment: cStart, children: [
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: black,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    "assets/icons/star_group.png",
                                    color: yellowColor,
                                    height: 30,
                                    width: 30,
                                  ),
                                ),
                              ),
                              customWidthBox(5),
                              Column(
                                crossAxisAlignment: cStart,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 9.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: "40 days left",
                                        style: TextStyle(
                                            color: yellowColor, fontSize: 13),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: ' Register now!',
                                              style: TextStyle(color: white)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  customHeightBox(10),
                                  LinearPercentIndicator(
                                    width: 250,
                                    animation: true,
                                    lineHeight: 12.0,
                                    animationDuration: 2500,
                                    percent: 0.8,
                                    barRadius: Radius.circular(10),
                                    progressColor: gray1,
                                  ),
                                ],
                              )
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                customHeightBox(15),
                customText("Your Invoice Address", 15, yellowColor),
                customHeightBox(10),
                Container(
                  padding: EdgeInsets.all(10),
                  width: phoneWidth(context) * 1.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: black),
                  child: Column(
                    crossAxisAlignment: cStart,
                    children: [
                      customText("Tom cruise", 14, white),
                      customHeightBox(5),
                      customText(
                          "79 Rue de verdun ,Montceau-les-mines ,Bourgogne\nFrance",
                          14,
                          white),
                      customHeightBox(25),
                      Center(
                        child: Container(
                          height: 30,
                          alignment: Alignment.center,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: commonButtonLinearGridient,
                          ),
                          child: customText("Change Address", 13, white),
                        ),
                      )
                    ],
                  ),
                ),
                customHeightBox(15),
                customText("Your Payment Information", 15, yellowColor),
                customHeightBox(15),
                Container(
                  padding: EdgeInsets.all(10),
                  width: phoneWidth(context) * 1.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: black),
                  child: Column(
                    crossAxisAlignment: cStart,
                    children: [
                      customText("Sophia", 13, white),
                      customHeightBox(5),
                      customText("Debit Card", 13, white),
                      customHeightBox(5),
                      customText("**** **** **4111", 13, white),
                      customHeightBox(5),
                      customText("Valid Until : 08/2028", 15, white),
                      customHeightBox(25),
                      Center(
                        child: Container(
                          height: 30,
                          alignment: Alignment.center,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: commonButtonLinearGridient,
                          ),
                          child: customText("Change Payment Method", 13, white),
                        ),
                      )
                    ],
                  ),
                ),
                customHeightBox(20),
                Container(
                  padding: EdgeInsets.all(10),
                  width: phoneWidth(context) * 1.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: black),
                  child: Column(
                    crossAxisAlignment: cStart,
                    children: [
                      Row(
                        mainAxisAlignment: mBetween,
                        children: [
                          customText("Invoice Date", 13, white),
                          customText("Invoice Number", 13, white),
                          customText("Amount", 13, white),
                          customText("Download PDF", 13, white),
                        ],
                      ),
                      customHeightBox(15),
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: 5,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return pdfItemInfo();
                          })
                    ],
                  ),
                ),
                customHeightBox(20),
                customText("Membership Expiring", 15, yellowColor),
                customHeightBox(8),
                customText("Select a Membership options", 13, gray1),
                customHeightBox(15),
                Container(
                  padding: EdgeInsets.all(10),
                  width: phoneWidth(context) * 1.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: black),
                  child: Column(
                    crossAxisAlignment: cStart,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 6),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: gray1,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 8.0),
                              child: Image.asset(
                                "assets/icons/crown.png",
                                color: yellowColor,
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ),
                          customWidthBox(10),
                          Column(
                            crossAxisAlignment: cStart,
                            children: [
                              customText("Basic", 13, white),
                              customText("Membership", 13, yellowColor)
                            ],
                          ),
                          Spacer(),
                          customText("\$89", 13, yellowColor)
                        ],
                      ),
                      customHeightBox(20),
                      customText("Description & Price", 15, white),
                      customHeightBox(5),
                      InkWell(
                        onTap: () {
                          moreInfoDialog("Basic");
                        },
                        child: Text(
                          "More Detail",
                          style: TextStyle(color: yellowColor, fontSize: 13),
                        ),
                      ),
                      customHeightBox(10),
                      DottedBorder(
                        padding: EdgeInsets.zero,
                        color: gray1,
                        strokeWidth: 1,
                        child: Container(),
                      ),
                      customHeightBox(10)
                    ],
                  ),
                ),
                customHeightBox(15),
                Container(
                  padding: EdgeInsets.all(10),
                  width: phoneWidth(context) * 1.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: black),
                  child: Column(
                    crossAxisAlignment: cStart,
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 6),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: gray1,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  left: 8.0,
                                  right: 8.0,
                                  bottom: 8.0),
                              child: Image.asset(
                                "assets/icons/crown.png",
                                color: yellowColor,
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ),
                          customWidthBox(10),
                          Column(
                            crossAxisAlignment: cStart,
                            children: [
                              customText("Premium", 13, white),
                              customText("Membership", 13, yellowColor)
                            ],
                          ),
                          Spacer(),
                          customText("\$323", 13, yellowColor)
                        ],
                      ),
                      customHeightBox(20),
                      customText("Description & Price", 15, white),
                      customHeightBox(5),
                      InkWell(
                        onTap: () {
                          moreInfoDialog("Premium");
                        },
                        child: Text(
                          "More Detail",
                          style: TextStyle(color: yellowColor, fontSize: 13),
                        ),
                      ),
                      customHeightBox(10),
                      DottedBorder(
                        padding: EdgeInsets.zero,
                        color: gray1,
                        strokeWidth: 1,
                        child: Container(),
                      ),
                      customHeightBox(10)
                    ],
                  ),
                ),
                customHeightBox(30)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pdfItemInfo() {
    return Column(
      children: [
        customHeightBox(10),
        Row(
          mainAxisAlignment: mBetween,
          children: [
            customText("30 JAN 2022", 13, white),
            customText("INR033364", 13, white),
            customText("99.44EUR", 13, white),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  gradient: commonButtonLinearGridient,
                  borderRadius: BorderRadius.circular(10)),
              child: customText("Download", 12, white),
            ),
          ],
        ),
        customHeightBox(10),
        DottedBorder(
          padding: EdgeInsets.zero,
          color: gray1,
          strokeWidth: 1,
          child: Container(),
        )
      ],
    );
  }

  //Show More Info dialog
  void moreInfoDialog(String title) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Container(
              height: 350,
              decoration: BoxDecoration(
                  color: gray1, borderRadius: BorderRadius.circular(10)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    customHeightBox(10),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 6),
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 4.0, right: 4.0, top: 7.0, bottom: 4.0),
                              child: Image.asset(
                                "assets/icons/crown.png",
                                color: yellowColor,
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                          customWidthBox(15),
                          customText(title, 18, yellowColor),
                          Spacer(),
                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                color: white,
                              )),
                        ],
                      ),
                    ),
                    dottedDivider(),
                    customInfoPoint(),
                    dottedDivider(),
                    customInfoPoint(),
                    dottedDivider(),
                    customInfoPoint(),
                    dottedDivider(),
                    customInfoPoint(),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

Widget customInfoPoint() {
  return Container(
    margin: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
    child: Row(children: [
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: commonButtonLinearGridient),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset(
            "assets/icons/check_right_icon.png",
            height: 20,
            width: 20,
          ),
        ),
      ),
      customWidthBox(10),
      RichText(
        text: TextSpan(
          text: "Official Events",
          style: TextStyle(color: yellowColor, fontSize: 12),
          children: <TextSpan>[
            TextSpan(
                text:
                    ' Enjoy free or reduced entry to all\nAfro United Official Events',
                style: TextStyle(color: white)),
          ],
        ),
      ),
    ]),
  );
}
