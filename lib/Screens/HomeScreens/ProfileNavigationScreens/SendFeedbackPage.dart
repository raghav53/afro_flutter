import 'dart:convert';

import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/ProfileSettingScreenPage.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendFeedbackPage extends StatefulWidget {
  const SendFeedbackPage({Key? key}) : super(key: key);

  @override
  State<SendFeedbackPage> createState() => _SendFeedbackPageState();
}

TextEditingController subject = TextEditingController();
TextEditingController description = TextEditingController();

class _SendFeedbackPageState extends State<SendFeedbackPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: BackButton(),
            title: customText("Profile", 20, Colors.white)),
        body: Container(
          padding: EdgeInsets.only(top: 50, left: 15, right: 15),
          decoration: commonBoxDecoration(),
          child: Column(
            crossAxisAlignment: cStart,
            children: [
              customDivider(10, Colors.white),
              customHeightBox(50),
              customText("Subject", 12, Colors.white),
              customHeightBox(10),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black),
                child: TextField(
                  controller: subject,
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Subject",
                      contentPadding: EdgeInsets.only(left: 15),
                      hintStyle: TextStyle(color: Colors.white24)),
                ),
              ),
              customHeightBox(25),
              customText("Comment", 14, Colors.white),
              customHeightBox(10),
              Container(
                height: 120,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: description,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Subject",
                      contentPadding: EdgeInsets.only(left: 15, top: 10),
                      hintStyle: TextStyle(color: Colors.white24)),
                ),
              ),
              customHeightBox(100),
              Center(
                child: GestureDetector(
                  onTap: () {
                    String title = subject.text.toString();
                    String comment = description.text.toString();

                    if (title.isEmpty) {
                      customToastMsg("Please enter the subject name.....");
                    } else if (comment.isEmpty) {
                      customToastMsg("Please enter the description...");
                    } else {
                      sendFeedback(title, comment);
                    }
                  },
                  child: Container(
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        gradient: commonButtonLinearGridient,
                        borderRadius: BorderRadius.circular(40)),
                    child: Center(
                      child: customText("Submit", 14, Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> sendFeedback(String title, String description) async {
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    showProgressDialogBox(context);
    Map data = {
      'title': title,
      'description': description,
    };
    var jsonResponse = null;
    var response = await http.post(Uri.parse(BASE_URL + "feedback"),
        headers: {'api-key': API_KEY, 'x-access-token': token!}, body: data);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      customToastMsg("Feedback submitted successfully...");
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileSettingScreenPage()));
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
