import 'dart:convert';

import 'package:afro/Screens/HomePageScreen.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/ProfileSettingScreenPage.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Network/Apis.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  _ChangePasswordPage createState() => _ChangePasswordPage();
}

TextEditingController oldPass = TextEditingController();
TextEditingController newPass = TextEditingController();

class _ChangePasswordPage extends State<ChangePasswordPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("background.png"), fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customHeadingPart("Change Password"),
                customHeightBox(50),
                Center(
                  child: Image.asset(
                    'screen_logo.png',
                    height: 50,
                    width: 250,
                  ),
                ),
                customHeightBox(80),
                Container(
                  margin: EdgeInsets.only(right: 20, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Current Password
                      customText("CURRENT PASSWORD", 15, Colors.white),
                      customHeightBox(10),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black, offset: Offset(0, 2))
                            ]),
                        height: 50,
                        child: TextField(
                          controller: oldPass,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 15),
                              hintText: "Current Password",
                              hintStyle: TextStyle(color: Colors.white24)),
                        ),
                      ),
                      customHeightBox(30),
                      //Confirm New Password
                      customText("NEW PASSWORD", 15, Colors.white),
                      customHeightBox(10),
                      Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black, offset: Offset(0, 2))
                            ]),
                        height: 50,
                        child: TextField(
                          controller: newPass,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 15),
                              hintText: "Current Password",
                              hintStyle: TextStyle(color: Colors.white24)),
                        ),
                      ),
                      customHeightBox(100)
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    String? oPass = oldPass.text.trim().toString();
                    String? nPass = newPass.text.trim().toString();
                    if (oPass.isEmpty) {
                      customToastMsg("Please enter the old password!");
                    } else if (nPass.isEmpty) {
                      customToastMsg("Please enter the new password!");
                    } else if (oPass.length < 3 || nPass.length < 3) {
                      customToastMsg("Password must be 3 digits or more!");
                    } else {
                      ChangePasswordApi(oPass, nPass);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 60, right: 60),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: fixedButtonDesign(),
                    child: Row(
                      mainAxisAlignment: mCenter,
                      children: [
                        customText("Change Password", 17, Colors.white)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> ChangePasswordApi(String oPass, String nPass) async {
    showProgressDialogBox(context);
    Map data = {'old_password': oPass, 'new_password': nPass};
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var jsonResponse = null;
    var response = await http.post(Uri.parse(BASE_URL + "change_password"),
        headers: {'api-key': API_KEY, 'x-access-token': token!}, body: data);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      customToastMsg(message);
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => HomePagescreen(),
      ));
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
