import 'dart:convert';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<String> reportTypeList = [
  "Spam",
  "Inappropriate",
  "Sexual",
  "Commercial Content",
  "Fake",
  "Compromised ",
  "Others"
];
List<int> indexList = [0, 1, 2, 3, 4, 5, 6];

Future<SharedPreferences> _pref = SharedPreferences.getInstance();
UserDataConstants _userDataConstants = UserDataConstants();

void showReportDialogBox(String reportType, String id, BuildContext context) {
  int defaultValue = -1;
  bool _isFocused = false;
  bool _visible = false;
  TextEditingController messageController = TextEditingController();
  String selectedType = "";
  double pHeight = phoneHeight(context) / 2;
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, state) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: pHeight,
                  decoration: BoxDecoration(
                      color: gray1, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Center(
                        child: customText("Report $reportType", 15, white),
                      ),
                      customHeightBox(30),
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: reportTypeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                state(() {
                                  defaultValue = index;
                                  if (defaultValue == 6) {
                                    _visible = true;
                                    pHeight = phoneHeight(context) / 1.6;
                                  } else {
                                    _visible = false;
                                    pHeight = phoneHeight(context) / 2;
                                  }
                                  selectedType = reportTypeList[index];
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.zero,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      focusColor: white,
                                      activeColor: white,
                                      value: index,
                                      groupValue: defaultValue,
                                      onChanged: (value) {},
                                    ),
                                    Text(
                                      reportTypeList[index],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                      customHeightBox(20),
                      Visibility(
                        visible: _visible,
                        child: Container(
                          height: 120,
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: messageController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 10,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Message",
                                contentPadding:
                                    EdgeInsets.only(left: 10, top: 12),
                                hintStyle: TextStyle(color: Colors.white24)),
                          ),
                        ),
                      ),
                      customHeightBox(20),
                      Row(
                        mainAxisAlignment: mCenter,
                        children: [
                          InkWell(
                            onTap: () {
                              String msg = messageController.text.toString();

                              if (defaultValue == -1) {
                                customToastMsg("Please select the report type");
                                return;
                              }
                              if (defaultValue == 6) {
                                if (messageController.text.isEmpty) {
                                  customToastMsg("Please type your message!");
                                  return;
                                }
                              }
                              String whichTypeReport = "user_id";
                              if (reportType == "User") {
                                whichTypeReport = "userId";
                              }
                              Map data = {
                                whichTypeReport: id,
                                "type": selectedType.toLowerCase(),
                              };
                              if (defaultValue == reportTypeList.length - 1) {
                                data.addAll({"message": msg});
                              }

                              print("Report data:-" + data.toString());
                              //Navigator.pop(context);
                              report(data, context);
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 25, right: 25),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: commonButtonLinearGridient),
                              child:
                                  Center(child: customText("Send", 13, white)),
                            ),
                          ),
                          customWidthBox(20),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 25, right: 25),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: commonButtonLinearGridient),
                              child: Center(
                                  child: customText("Cancel", 13, white)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ));
        });
      });
}

//Repost api
Future<void> report(Map data, BuildContext context) async {
  print(data);
  showProgressDialogBox(context);
  SharedPreferences userData = await _pref;
  String? token = userData.getString(_userDataConstants.token).toString();

  var response = await http.post(Uri.parse(BASE_URL + "report"),
      headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);
  var jsonResponse = json.decode(response.body);
  print(jsonResponse);
  var message = jsonResponse["message"];
  Navigator.pop(context);
  Navigator.pop(context);
  if (response.statusCode == 200) {
    customToastMsg("Report Submit Successfully!");
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    customToastMsg(message);
  }
}
