import 'dart:convert';

import 'package:afro/Model/Education.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/OnBoardingScreen/FirstOnBoard.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddEducationPage extends StatefulWidget {
  Map dataMap = {};
  AddEducationPage({Key? key, required this.dataMap}) : super(key: key);
  @override
  _AddEducation createState() => _AddEducation();
}

TextEditingController schoolCollegeName = TextEditingController();
TextEditingController degreeNam = TextEditingController();
TextEditingController areaStudy = TextEditingController();
TextEditingController description = TextEditingController();
var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
String fromText = "000000000";
String toText = "000000000";

String fromTextStartDate = "";
String toTextEndDate = "";

class _AddEducation extends State<AddEducationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.dataMap.isNotEmpty) {
      schoolCollegeName.text = widget.dataMap["school"].toString();
      degreeNam.text = widget.dataMap["degree"].toString();
      areaStudy.text = widget.dataMap["area"].toString();
      description.text = widget.dataMap["description"].toString();

      fromText = widget.dataMap["fromText"].toString();
      toText = widget.dataMap["toText"].toString();
      fromTextStartDate = widget.dataMap["fromTextStartDate"].toString();
      toTextEndDate = widget.dataMap["toTextEndDate"].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: commonAppbar(
          widget.dataMap.isEmpty ? "Add Education" : "Update Education"),
      body: Container(
        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: mStart,
            crossAxisAlignment: cStart,
            children: [
              customHeightBox(50),
              customText("School/University", 15, Colors.white),
              edittext("School/University", schoolCollegeName),
              customHeightBox(20),
              customText("Dates Attended", 15, Colors.white),
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
                                    fromTextStartDate.isEmpty
                                        ? "from"
                                        : fromTextStartDate,
                                    15,
                                    fromTextStartDate.isEmpty
                                        ? white24
                                        : white),
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
                                    toTextEndDate.isEmpty
                                        ? "to"
                                        : toTextEndDate,
                                    15,
                                    toTextEndDate.isEmpty ? white24 : white),
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
              customHeightBox(25),
              customText("Degree", 15, Colors.white),
              edittext("Degree", degreeNam),
              customHeightBox(20),
              customText("Area Of Study", 15, Colors.white),
              edittext("Ex : Computer Science", areaStudy),
              customHeightBox(20),
              customText("Description", 15, Colors.white),
              customHeightBox(10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(0, 2))
                        ]),
                    height: 100,
                    child: TextField(
                      controller: description,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Description",
                          contentPadding: EdgeInsets.only(left: 15),
                          hintStyle: TextStyle(color: Colors.white24)),
                    ),
                  ),
                ],
              ),
              customHeightBox(50),
              InkWell(
                onTap: () {
                  checkValues();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 60, right: 60),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: fixedButtonDesign(),
                  child: Row(
                    mainAxisAlignment: mCenter,
                    children: [
                      customText(widget.dataMap.isEmpty ? "Save" : "Update", 17,
                          Colors.white)
                    ],
                  ),
                ),
              )
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
                                  fromTextStartDate = formattedDate;
                                });
                              } else if (type == "to") {
                                setState(() {
                                  toText = timestamp1.toString();
                                  toTextEndDate = formattedDate;
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

  checkValues() {
    String schoolCollege = schoolCollegeName.text.trim().toString();
    String degree = degreeNam.text.toString();
    String area = areaStudy.text.toString();
    String desc = description.text.toString();

    if (schoolCollege.isEmpty) {
      customToastMsg("Please enter the name of college and school!");
      return;
    } else if (degree.isEmpty) {
      customToastMsg("Please enter the degree name!");
      return;
    } else if (area.isEmpty) {
      customToastMsg("Please enter the name of study!");
      return;
    } else if (desc.isEmpty) {
      customToastMsg("Please describe the your eduction history!");
      return;
    }
    int fromTime = int.parse(fromText);
    int toTime = int.parse(toText);
    if (toTime <= fromTime) {
      customToastMsg("Please select another end date!");
      return;
    }
    Map data = {
      'institution': schoolCollege,
      'subject': degree,
      'degree': area,
      'description': desc,
      'from': fromText,
      'to': toText,
      'current': "0"
    };
    if (widget.dataMap.isNotEmpty) {
      data.addAll({"education_id": widget.dataMap["id"].toString()});
    }
    addUserEducation(data, context);
  }

  Future<void> addUserEducation(Map data, BuildContext context) async {
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
        Uri.parse(widget.dataMap.isNotEmpty
            ? BASE_URL + "update_education"
            : BASE_URL + "education"),
        headers: {'api-key': API_KEY, 'x-access-token': token},
        body: data);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      customToastMsg("Work experience added successfully!");
      Navigator.pop(context);
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }
}

Widget edittext(String hint, TextEditingController controller) {
  return Column(
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
          controller: controller,
          keyboardType: TextInputType.text,
          style: const TextStyle(fontSize: 14, color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              contentPadding: const EdgeInsets.only(left: 15),
              hintStyle: const TextStyle(color: Colors.white24)),
        ),
      ),
    ],
  );
}
