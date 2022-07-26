import 'dart:convert';
import 'dart:ffi';

import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/WorkPage.dart';
import 'package:afro/Screens/OnBoardingScreen/FirstOnBoard.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddWorkPage extends StatefulWidget {
  Map dataMap = {};
  AddWorkPage({required this.dataMap});
  _AddWork createState() => _AddWork();
}

TextEditingController positionEditext = TextEditingController();
TextEditingController companyEditext = TextEditingController();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
String fromText = "";
String toText = "";

String fromDateText = "";
String toDateText = "";

var user = UserDataConstants();

class _AddWork extends State<AddWorkPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.dataMap.isEmpty) {
      positionEditext.text = widget.dataMap["position"].toString();
      companyEditext.text = widget.dataMap["company"].toString();
      fromText = widget.dataMap["fromText"].toString();
      toText = widget.dataMap["toText"].toString();
      fromDateText = widget.dataMap["fromDateText"].toString();
      toDateText = widget.dataMap["toDateText"].toString();
    }
  }

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: commonAppbar(widget.dataMap.isEmpty ? "Add Work" : "Update Work"),
      body: Container(
        padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisAlignment: mStart,
            crossAxisAlignment: cStart,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: customText("Position", 15, Colors.white),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customHeightBox(10),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(0, 2))
                        ]),
                    height: 50,
                    child: TextField(
                      controller: positionEditext,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Position",
                          contentPadding: EdgeInsets.only(left: 15),
                          hintStyle: TextStyle(color: Colors.white24)),
                    ),
                  ),
                ],
              ),
              customHeightBox(20),

              //Company Name Editext
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: customText("Company", 15, Colors.white),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customHeightBox(10),
                  Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(0, 2))
                        ]),
                    height: 50,
                    child: TextField(
                      controller: companyEditext,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Company",
                          contentPadding: EdgeInsets.only(left: 15),
                          hintStyle: TextStyle(color: Colors.white24)),
                    ),
                  ),
                ],
              ),
              customHeightBox(20),

              //Duration Selection
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: customText("Duration", 15, Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Start Date
                  Flexible(
                      child: InkWell(
                    onTap: () {
                      openBottomSheet(context, "from");
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customHeightBox(10),
                        Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black, offset: Offset(0, 2))
                                ]),
                            height: 50,
                            child: Row(
                              children: [
                                customText(
                                    fromDateText.isEmpty ? "To" : fromDateText,
                                    15,
                                    fromDateText.isEmpty ? white24 : white),
                                Spacer(),
                                Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: white24,
                                )
                              ],
                            )),
                      ],
                    ),
                  )),
                  customWidthBox(20),

                  //End Date
                  Flexible(
                      child: InkWell(
                    onTap: () {
                      openBottomSheet(context, "to");
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        customHeightBox(10),
                        Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black, offset: Offset(0, 2))
                                ]),
                            height: 50,
                            child: Row(
                              children: [
                                customText(
                                    isChecked == true
                                        ? "Present"
                                        : toDateText.isEmpty
                                            ? "To"
                                            : toDateText,
                                    15,
                                    toDateText.isEmpty ? white24 : white),
                                Spacer(),
                                Icon(
                                  Icons.arrow_drop_down_rounded,
                                  color: white24,
                                )
                              ],
                            )),
                      ],
                    ),
                  ))
                ],
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Checkbox(
                      checkColor: white,
                      activeColor: circleColor,
                      value: isChecked,
                      onChanged: (value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    customText("I currently work here", 15, white),
                    customWidthBox(80)
                  ],
                ),
              ),
              customHeightBox(100),
              GestureDetector(
                onTap: () {
                  checkValues();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 50, right: 50),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: fixedButtonDesign(),
                  child: Row(
                    mainAxisAlignment: mCenter,
                    children: [customText("Save", 17, Colors.white)],
                  ),
                ),
              ),
              customHeightBox(50)
            ],
          ),
        ),
      ),
    ));
  }

  void openBottomSheet(BuildContext context, String type) {
    showModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
                height: 300,
                margin: EdgeInsets.only(top: 30),
                decoration: commonBoxDecoration(),
                child: Column(
                  crossAxisAlignment: cCenter,
                  children: [
                    Row(
                      mainAxisAlignment: mCenter,
                      crossAxisAlignment: cCenter,
                      children: [
                        Spacer(),
                        Spacer(),
                        customText("Pick Date", 15, white),
                        Spacer(),
                        customWidthBox(25),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: customText("Done", 14, circleColor))
                      ],
                    ),
                    customDivider(10, white),
                    customHeightBox(10),
                    Container(
                      height: 200,
                      child: CupertinoTheme(
                        data: const CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          dateOrder: DatePickerDateOrder.dmy,
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime(1980, 1, 1),
                          onDateTimeChanged: (DateTime newDateTime) {
                            setState(() {
                              //hh:mm:ss
                              final timestamp1 =
                                  newDateTime.millisecondsSinceEpoch;
                              print(timestamp1);
                              String formattedDate =
                                  DateFormat('MM-yyyy').format(newDateTime);
                              if (type == "from") {
                                setState(() {
                                  fromText = timestamp1.toString();
                                  fromDateText = formattedDate;
                                });
                              } else if (type == "to") {
                                setState(() {
                                  toText = timestamp1.toString();
                                  toDateText = formattedDate;
                                });
                              }
                              // dateOfBirth = formattedDate;
                              print(formattedDate);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ));
          });
        });
  }

  Future<void> addEducation(Map data) async {
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    print(token);
    showProgressDialogBox(context);
    if (token == null) {
      Navigator.pop(context);
      customToastMsg("Invalid token!");
      return;
    }

    var response = await http.post(
        Uri.parse(dataMap.isEmpty
            ? BASE_URL + "experience?"
            : BASE_URL + "update_experience"),
        headers: {'api-key': API_KEY, 'x-access-token': token},
        body: data);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      customToastMsg("Work experience added successfully!");
      ClearAll();
      Navigator.of(context).pop();
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }

  checkValues() {
    String companyName = companyEditext.text.trim().toString();
    String positionName = positionEditext.text.trim().toString();

    if (positionEditext.text.toString().isEmpty) {
      customToastMsg("Please enter the your position!");
      return;
    } else if (companyEditext.text.toString().isEmpty) {
      customToastMsg("Please enter the company name!");
      return;
    } else if (fromText.isEmpty) {
      customToastMsg("Please select the select start date!");
      return;
    } else if (!isChecked) {
      if (toText.isEmpty) {
        customToastMsg("Please select the select date!");
        return;
      }
    } else if (!isChecked) {
      int fromTime = int.parse(fromText);
      int toTime = int.parse(toText);
      if (toTime <= fromTime) {
        customToastMsg("Please select another end date!");
        return;
      }
    }
    Map data = {
      'company': companyName,
      'position': positionName,
      'from': fromText,
      'to':
          isChecked ? DateTime.now().millisecondsSinceEpoch.toString() : toText,
      'current': isChecked ? "1" : "0"
    };
    if (dataMap.isNotEmpty) {
      data.addAll({"experience_id": dataMap["id"]});
    }
    print(data);
    addEducation(data);
  }

  ClearAll() {
    positionEditext.clear();
    companyEditext.clear();
    fromText = "";
    toText = "";
    toDateText = "";
    fromDateText = "";
  }
}
