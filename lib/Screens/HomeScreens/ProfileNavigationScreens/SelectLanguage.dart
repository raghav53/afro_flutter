import 'dart:convert';

import 'package:afro/Model/Language.dart';
import 'package:afro/Model/UserProfileModel.dart';
import 'package:afro/Screens/HomePageScreen.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/SharedPreferencfes.dart';
import 'package:http/http.dart' as http;
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguageScreenPage extends StatefulWidget {
  _SelectLanguage createState() => _SelectLanguage();
}

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
List<String> selectedLanguagesName = [];
List<String> selectedLanguagesSId = [];

Future<Language>? _getLanguageList;
var user = UserDataConstants();
Future<UserProfile>? _getUserProfile;

class _SelectLanguage extends State<SelectLanguageScreenPage> {
  Language? allLanguageList;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getLanguageList = getLanguagesList(context);
      setState(() {});
      _getLanguageList!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: onlyTitleCommonAppbar("Select Language"),
      body: Container(
        padding: EdgeInsets.only(top: 70),
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: cStart,
            children: [
              Center(
                child: Text("What Language Do You Speak?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: white)),
              ),
              customHeightBox(30),
              FutureBuilder<Language>(
                  future: _getLanguageList,
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                        ? Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            height: phoneHeight(context) / 1.7,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.data!.length,
                              itemBuilder: (context, int index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      snapshot.data!.data![index].isSelected =
                                          !snapshot
                                              .data!.data![index].isSelected;
                                      addInSelectedArray(
                                          snapshot.data!.data![index].sId
                                              .toString(),
                                          snapshot
                                              .data!.data![index].isSelected);
                                    });
                                  },
                                  child: ListTile(
                                    leading: customText(
                                        snapshot.data!.data![index].title
                                            .toString(),
                                        15,
                                        Colors.white),
                                    trailing: Checkbox(
                                      checkColor: Colors.white,
                                      activeColor: const Color(0xFF7822A0),
                                      value: snapshot
                                          .data!.data![index].isSelected,
                                      onChanged: (value) {
                                        setState(() {
                                          snapshot.data!.data![index]
                                                  .isSelected =
                                              !snapshot.data!.data![index]
                                                  .isSelected;
                                          addInSelectedArray(
                                              snapshot.data!.data![index].sId
                                                  .toString(),
                                              snapshot.data!.data![index]
                                                  .isSelected);
                                        });
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            height: phoneHeight(context) * 0.69,
                            child: Center(
                              child: customText("Not data found!", 15, white),
                            ),
                          );
                  }),
              customHeightBox(30),
              InkWell(
                onTap: () {
                  addInterestOfUser();
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 100, right: 100),
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 50, right: 50),
                  decoration: BoxDecoration(
                      gradient: commonButtonLinearGridient,
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(child: customText("Save", 15, white)),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  addInSelectedArray(String id, bool val) async {
    setState(() {
      if (val) {
        selectedLanguagesSId.add(id);
        print(selectedLanguagesSId);
      } else {
        selectedLanguagesSId.remove(id);
        print(selectedLanguagesSId);
      }
    });
  }

  Future<void> getAllLanguages() async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var jsonResponse = null;
    var response = await http.get(
      Uri.parse(BASE_URL + "languages"),
      headers: {'api-key': API_KEY, 'x-access-token': token!},
    );
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    allLanguageList = Language.fromJson(jsonResponse);
    if (response.statusCode == 200) {
      setState(() {
        Navigator.pop(context);
      });
      print("Succes");
    } else {
      setState(() {
        Navigator.pop(context);
      });
      customToastMsg(message);
    }
  }

  Future<void> addInterestOfUser() async {
    if (selectedLanguagesSId.isEmpty) {
      customToastMsg("Please select the language!");
      return;
    }
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    print(token);
    var body = json.encode({"languages": selectedLanguagesSId});

    var response = await http.post(Uri.parse(BASE_URL + "user_languages"),
        headers: {
          'api-key': API_KEY,
          'x-access-token': token!,
          'Content-type': 'application/json'
        },
        body: body);
    print("Response : ${response.statusCode}");
    print(response.body);
    var jsonResponse = jsonDecode(response.body);
    var message = jsonResponse["message"];
    print("Response : ${response.statusCode}");
    if (response.statusCode == 200) {
      Navigator.pop(context);
      SaveStringToSF("login", "yes");
      SaveStringToSF("newuser", "");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePagescreen()));
    } else {
      Navigator.pop(context);
      setState(() {
        selectedLanguagesName.clear();
        selectedLanguagesSId.clear();
        //selectionClear();
      });
      customToastMsg(message);
    }
  }
}
