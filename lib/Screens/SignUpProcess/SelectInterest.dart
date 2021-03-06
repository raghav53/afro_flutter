import 'dart:convert';

import 'package:afro/Model/AllInterestsModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/SelectLanguage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SelectIntrest extends StatefulWidget {
  const SelectIntrest({Key? key}) : super(key: key);

  @override
  _Intrests createState() => _Intrests();
}

TextEditingController interestTitle = TextEditingController();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
AllInterestModel? interestModel;
AllInterestModel searchModel = AllInterestModel();
List<String> selectedInterestedList = <String>[];
List<Map> interestOptionJson = [];

Future<AllInterestModel>? _getInterestsList;

class _Intrests extends State<SelectIntrest> {
  @override
  void initState() {
    super.initState();
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
      appBar: commonAppbar("Interest"),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: commonBoxDecoration(),
        child: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          margin: EdgeInsets.only(top: 50),
          child: Column(
            children: [
              customHeightBox(30),
              Text(
                "Select your Interests",
                style: TextStyle(
                    fontSize: 20, color: white, fontWeight: FontWeight.bold),
              ),
              customHeightBox(20),
              FutureBuilder<AllInterestModel>(
                  future: _getInterestsList,
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                        ? Container(
                            height: phoneHeight(context) * 0.69,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.data!.length,
                              itemBuilder: (context, int index) {
                                String title = snapshot.data!.data![index].title
                                    .toString();
                                return ListTile(
                                    title: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: customText(
                                                title, 15, Colors.white)),
                                        Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: Color(0xFF7822A0),
                                          value: snapshot
                                              .data!.data![index].isSelected,
                                          onChanged: (value) {
                                            setState(() {
                                              snapshot.data!.data![index]
                                                      .isSelected =
                                                  !snapshot.data!.data![index]
                                                      .isSelected!;
                                              addInterestInArray(
                                                  snapshot.data!.data![index]
                                                      .isSelected,
                                                  index);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      height: 10,
                                      color: Colors.white,
                                    )
                                  ],
                                ));
                              },
                            ),
                          )
                        : Container(
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
                  margin: const EdgeInsets.only(left: 60, right: 60),
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: fixedButtonDesign(),
                  child: Row(
                    mainAxisAlignment: mCenter,
                    children: [customText("Next", 17, Colors.white)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  addInterestInArray(bool? isSelected, int index) {
    if (isSelected == true) {
      selectedInterestedList
          .add(interestModel!.data![index].sId.toString().toString());
      print(selectedInterestedList);
    } else {
      selectedInterestedList.remove(interestModel!.data![index].sId.toString());
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

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SelectLanguageScreenPage()));
    } else {
      Navigator.pop(context);
      setState(() {
        selectedInterestedList.clear();
      });
      customToastMsg(message);
    }
  }
}
