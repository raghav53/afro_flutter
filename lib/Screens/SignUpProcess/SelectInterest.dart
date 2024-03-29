import 'dart:convert';

import 'package:afro/Model/AllInterestsModel.dart';
import 'package:afro/Model/UserInterestModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/SelectLanguage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:afro/Util/SharedPreferencfes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SelectIntrest extends StatefulWidget {
  String? type;
  SelectIntrest({Key? key, required this.type}) : super(key: key);

  @override
  _Intrests createState() => _Intrests();
}

class _Intrests extends State<SelectIntrest> {
  TextEditingController interestTitle = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UserInterestModel? userAllInterests;

  AllInterestModel searchModel = AllInterestModel();
  List<String> selectedInterestedList = <String>[];

  Future<AllInterestModel>? _getInterestsList;
  @override
  void initState() {
    super.initState();
    getAllLanguages();
    print(widget.type);
    Future.delayed(Duration.zero, () {
      _getInterestsList = getInterestssList(context);
      setState(() {});
      _getInterestsList!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: widget.type == "1"
          ? commonAppbar("Update your interests")
          : onlyTitleCommonAppbar("Interests"),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: commonBoxDecoration(),
        child: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          margin: EdgeInsets.only(top: 50),
          child: SingleChildScrollView(
            child: Column(
              children: [
                customHeightBox(30),
                Text(
                  "Select your Interests",
                  style: TextStyle(
                      fontSize: 20, color: white, fontWeight: FontWeight.bold),
                ),
                customHeightBox(20),
                Container(
                  height: phoneHeight(context) / 1.6,
                  child: FutureBuilder<AllInterestModel>(
                      future: _getInterestsList,
                      builder: (context, snapshot) {
                        return snapshot.hasData &&
                                snapshot.data!.data!.isNotEmpty
                            ? ListView.builder(
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.data!.length,
                                itemBuilder: (context, int index) {
                                  String title = snapshot
                                      .data!.data![index].title
                                      .toString();
                                  for (var i = 0;
                                      i < snapshot.data!.data!.length;
                                      i++) {
                                    for (var j = 0;
                                        j < selectedInterestedList.length;
                                        j++) {
                                      if (selectedInterestedList[j] ==
                                          snapshot.data!.data![i].sId) {
                                        snapshot.data!.data![i].isSelected =
                                            true;
                                      }
                                    }
                                  }
                                  return InkWell(
                                      onTap: () {
                                        setState(() {
                                          snapshot.data!.data![index]
                                                  .isSelected =
                                              !snapshot.data!.data![index]
                                                  .isSelected;
                                          print(snapshot
                                              .data!.data![index].isSelected);
                                          addInterestInArray(
                                              snapshot.data!.data![index]
                                                  .isSelected,
                                              snapshot.data!.data![index].sId
                                                  .toString());
                                        });
                                      },
                                      child: ListTile(
                                        leading:
                                            customText(title, 15, Colors.white),
                                        trailing: InkWell(
                                          onTap: () {},
                                          child: Checkbox(
                                            checkColor: Colors.white,
                                            activeColor: Color(0xFF7822A0),
                                            value: snapshot
                                                .data!.data![index].isSelected,
                                            onChanged: (value) {
                                              setState(() {
                                                snapshot.data!.data![index]
                                                        .isSelected =
                                                    !snapshot.data!.data![index]
                                                        .isSelected;
                                                print(snapshot.data!
                                                    .data![index].isSelected);
                                                addInterestInArray(
                                                    snapshot.data!.data![index]
                                                        .isSelected,
                                                    snapshot
                                                        .data!.data![index].sId
                                                        .toString());
                                              });
                                            },
                                          ),
                                        ),
                                      ));
                                },
                              )
                            : Container(
                                height: phoneHeight(context) * 0.69,
                                child: Center(
                                  child:
                                      customText("Not data found!", 15, white),
                                ),
                              );
                      }),
                ),
                customHeightBox(30),
                InkWell(
                  onTap: () {
                    addInterestOfUser();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 60, right: 60),
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    decoration: fixedButtonDesign(),
                    child: Row(
                      mainAxisAlignment: mCenter,
                      children: [
                        customText(widget.type == "1" ? "Save" : "Next", 17,
                            Colors.white)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  addInterestInArray(bool? isSelected, String id) {
    if (isSelected == true) {
      selectedInterestedList.add(id);
      print(selectedInterestedList);
    } else {
      selectedInterestedList.remove(id);
      print(selectedInterestedList);
    }
  }

  Future<void> addInterestOfUser() async {
    showProgressDialogBox(context);
    if (selectedInterestedList.isEmpty) {
      Navigator.pop(context);
      customToastMsg("Please select the interest!");
      return;
    }
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    print(token);
    var body = json.encode({"interests": selectedInterestedList});

    var response = await http.post(Uri.parse(BASE_URL + "user_interests"),
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
      SaveStringToSF("newuser", "interestupdated");
      widget.type == "1"
          ? Navigator.pop(context)
          : Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SelectLanguageScreenPage(type: "")));
    } else {
      Navigator.pop(context);
      setState(() {
        selectedInterestedList.clear();
      });
      customToastMsg(message);
    }
  }

  Future<void> getAllLanguages() async {
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var jsonResponse = null;
    var response = await http.get(
      Uri.parse(BASE_URL + "user_interests"),
      headers: {'api-key': API_KEY, 'x-access-token': token!},
    );
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    userAllInterests = UserInterestModel.fromJson(jsonResponse);
    if (response.statusCode == 200) {
      for (var i = 0; i < userAllInterests!.data!.length; i++) {
        setState(() {
          selectedInterestedList
              .add(userAllInterests!.data![i].interestId.toString());
        });
      }
    } else {
      customToastMsg(message);
    }
  }
}
