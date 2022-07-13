import 'dart:convert';

import 'package:afro/Model/AllInterestsModel.dart';
import 'package:afro/Model/Group/AllGroupModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupDetailsPage.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:http/http.dart' as http;
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Util/CustomWidgetAttributes.dart';

class RecommendedGroups extends StatefulWidget {
  const RecommendedGroups({Key? key}) : super(key: key);

  @override
  State<RecommendedGroups> createState() => _RecommendedGroupsState();
}

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<AllGroupsModel>? _getAllGroups;
String? countryId = "";
Future<AllInterestModel>? _getAllInterests;
var userData = UserDataConstants();
List<String> selectedIntrestSId = [];

class _RecommendedGroupsState extends State<RecommendedGroups> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getAllGroups = getAllGroups(context, country: countryId.toString());
      setState(() {});
      _getAllGroups!.whenComplete(() => () {});
    });
    getData();
  }

  refreshData(String value) {
    Future.delayed(Duration.zero, () {
      _getAllGroups = getAllGroups(context,
          country: countryId.toString(), search: value, showProgress: false);
      setState(() {});
      _getAllGroups!.whenComplete(() => () {});
    });
  }

  getData() async {
    SharedPreferences data = await _prefs;
    countryId = data.getString(userData.countryId).toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: commonAppbar("Recommended Groups"),
      body: Container(
        decoration: commonBoxDecoration(),
        height: phoneHeight(context),
        padding: EdgeInsets.only(top: 70),
        width: phoneWidth(context),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: mCenter,
              children: [
                Flexible(
                    flex: 5,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: Colors.black, offset: Offset(0, 2))
                          ]),
                      child: TextField(
                        onChanged: (value) {
                          refreshData(value.toString());
                        },
                        keyboardType: TextInputType.text,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: yellowColor,
                            ),
                            hintText: "Search",
                            contentPadding: EdgeInsets.only(left: 15, top: 15),
                            hintStyle: TextStyle(color: white24)),
                      ),
                    )),
                customWidthBox(20),
                Flexible(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openBottomSheet(context);
                      },
                      child: Image.asset(
                        "assets/icons/fillter.png",
                        height: 20,
                        width: 20,
                      ),
                    )),
              ],
            ),
            customHeightBox(20),
            FutureBuilder<AllGroupsModel>(
                future: _getAllGroups,
                builder: (context, snapshot) {
                  return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.data!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => GroupDetailsPage(
                                          groupId: snapshot
                                              .data!.data![index].sId
                                              .toString(),
                                          groupAdmin: snapshot
                                              .data!.data![index].userId
                                              .toString(),
                                        )));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    top: 10, left: 20, right: 5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.only(
                                    top: 15, bottom: 15, left: 10),
                                child: Row(children: [
                                  CachedNetworkImage(
                                      imageUrl: IMAGE_URL +
                                          snapshot
                                              .data!.data![index].coverImage!
                                              .toString(),
                                      errorWidget: (error, context, url) =>
                                          const Icon(Icons.person),
                                      placeholder: (context, url) =>
                                          const Icon(Icons.person),
                                      imageBuilder: (context, url) {
                                        return CircleAvatar(
                                          backgroundImage: url,
                                        );
                                      }),
                                  customWidthBox(10),
                                  Column(
                                    crossAxisAlignment: cStart,
                                    children: [
                                      SizedBox(
                                          width: 120,
                                          child: Text(
                                            snapshot.data!.data![index].title
                                                .toString(),
                                            overflow: TextOverflow.fade,
                                            maxLines: null,
                                            softWrap: false,
                                            style: TextStyle(
                                                color: white, fontSize: 11),
                                          )),
                                      customHeightBox(5),
                                      Row(
                                        children: [
                                          customText(
                                              snapshot.data!.data![index]
                                                      .totalMembers
                                                      .toString() +
                                                  " Members",
                                              11,
                                              yellowColor)
                                        ],
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () {
                                      if (snapshot
                                              .data!.data![index].isMember ==
                                          1) {
                                        showLeaveDialogBox(snapshot
                                            .data!.data![index].sId
                                            .toString());
                                      }
                                      if (snapshot.data!.data![index]
                                                  .isMember ==
                                              0 &&
                                          snapshot.data!.data![index]
                                                  .isMember ==
                                              0) {
                                        leaveJoinTheGroup(
                                            snapshot.data!.data![index].sId
                                                .toString(),
                                            2);
                                      }
                                    },
                                    child: Container(
                                      width: 110,
                                      margin: const EdgeInsets.only(right: 20),
                                      padding: const EdgeInsets.only(
                                          top: 10,
                                          bottom: 10,
                                          left: 10,
                                          right: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          gradient: commonButtonLinearGridient),
                                      child: Center(
                                          child: customText(
                                              snapshot.data!.data![index]
                                                          .isMember ==
                                                      1
                                                  ? "Leave"
                                                  : snapshot.data!.data![index]
                                                              .isJoinSent ==
                                                          1
                                                      ? "Cancel Request"
                                                      : snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .isInviteRecieved ==
                                                              1
                                                          ? "Accept Request"
                                                          : "Join Group",
                                              11,
                                              white)),
                                    ),
                                  )
                                ]),
                              ),
                            );
                          })
                      : Center(
                          child: customText("No data found!", 15, white),
                        );
                })
          ],
        ),
      ),
    ));
  }

  List<String> filterList = ["Interests", "Member", "Clear All"];
  var selectedIndex = 0;
  var selectedRange = RangeValues(0, 500);
  int _startRange = 0;
  int _endRange = 500;

  //Show Fillter in bottomsheet
  void openBottomSheet(BuildContext context) {
    getInterests();
    showModalBottomSheet(
        isScrollControlled: true,
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
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: commonBoxDecoration(),
              child: Column(
                children: [
                  customHeightBox(15),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: mBetween,
                      children: [
                        customText(
                            "Filter & Sort", 12, const Color(0xFFDFB48C)),
                        customText(filterList[selectedIndex], 12,
                            const Color(0xFFDFB48C)),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            state(() {
                              selectedIndex = 0;
                              _startRange = 0;
                              _endRange = 500;
                              selectedRange = RangeValues(0, 500);
                              selectedIntrestSId.clear();
                            });
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                  customDivider(5, Colors.white),
                  Row(
                    crossAxisAlignment: cStart,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          mainAxisAlignment: mStart,
                          crossAxisAlignment: cStart,
                          children: [
                            Container(
                              height: 200,
                              width: 100,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filterList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        state(() {
                                          selectedIndex = index;
                                          filterList[selectedIndex] ==
                                                  "Clear All"
                                              ? {
                                                  selectedIndex = 0,
                                                  _startRange = 0,
                                                  _endRange = 500,
                                                  Navigator.pop(context)
                                                }
                                              : null;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 20, left: 10),
                                        width: 50,
                                        decoration: BoxDecoration(
                                            gradient: selectedIndex == index
                                                ? commonButtonLinearGridient
                                                : null,
                                            border: selectedIndex == index
                                                ? null
                                                : Border.all(
                                                    color: Colors.white,
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          child: customText(filterList[index],
                                              12, Colors.white),
                                        )),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      customWidthBox(20),
                      SizedBox(
                        width: 0.5,
                        height: MediaQuery.of(context).size.height * 0.67,
                        child: Container(color: Color(0x3DFFFFFF)),
                      ),
                      selectedIndex == 0
                          ? interestSelectionWidget(state)
                          : Container(
                              margin: const EdgeInsets.only(
                                  top: 15, left: 10, right: 10),
                              width: 270,
                              child: Column(
                                mainAxisAlignment: mCenter,
                                crossAxisAlignment: cCenter,
                                children: [
                                  RangeSlider(
                                    activeColor: yellowColor,
                                    inactiveColor: white,
                                    min: 0,
                                    max: 500,
                                    values: selectedRange,
                                    onChanged: (RangeValues newValue) {
                                      state(() {
                                        selectedRange = newValue;
                                        _startRange = newValue.start.toInt();
                                        _endRange = newValue.end.toInt();
                                      });
                                    },
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 11),
                                    child: Row(
                                      children: [
                                        customText(
                                            "min " + _startRange.toString(),
                                            15,
                                            white),
                                        Spacer(),
                                        customText(
                                            "max " + _endRange.toString(),
                                            15,
                                            white)
                                      ],
                                    ),
                                  )
                                ],
                              ))
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  //Show All interests
  Widget interestSelectionWidget(StateSetter state) {
    return Column(
      mainAxisAlignment: mCenter,
      crossAxisAlignment: cCenter,
      children: [
        Center(
          child: Container(
            height: 40,
            width: 270,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.black),
            margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
            child: const TextField(
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 14, color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 15, left: 15),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFFDFB48C),
                  ),
                )),
          ),
        ),
        customHeightBox(10),
        SingleChildScrollView(
          child: Container(
              height: 470,
              width: 282,
              child: FutureBuilder<AllInterestModel>(
                future: _getAllInterests,
                builder: (context, snapshot) {
                  return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.data!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 15, right: 15),
                                  child: Row(
                                    children: [
                                      customText(
                                          snapshot.data!.data![index].title
                                              .toString(),
                                          15,
                                          white),
                                      const Spacer(),
                                      Checkbox(
                                          value: snapshot
                                              .data!.data![index].isSelected,
                                          onChanged: (value) {
                                            state(() {
                                              snapshot.data!.data![index]
                                                      .isSelected =
                                                  !snapshot.data!.data![index]
                                                      .isSelected!;
                                              addInSelectedArray(
                                                  snapshot
                                                      .data!.data![index].sId
                                                      .toString(),
                                                  snapshot.data!.data![index]
                                                      .isSelected!);
                                            });
                                          })
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 0.2,
                                  width: 282,
                                  child: Container(color: white),
                                )
                              ]),
                            );
                          })
                      : Center(
                          child: customText("No data!", 15, white),
                        );
                },
              )),
        ),
        Container(
          padding:
              const EdgeInsets.only(left: 50, right: 50, top: 7, bottom: 7),
          decoration: BoxDecoration(
              gradient: commonButtonLinearGridient,
              borderRadius: BorderRadius.circular(30)),
          child: Center(child: customText("Done", 15, white)),
        )
      ],
    );
  }

  //Get all interests api
  getInterests() {
    Future.delayed(Duration.zero, () {
      _getAllInterests = getInterestssList(context);
      setState(() {});
      _getAllInterests!.whenComplete(() => () {});
    });
  }

  //Add/Remove the interest id
  addInSelectedArray(String id, bool val) async {
    setState(() {
      if (val) {
        selectedIntrestSId.add(id);
        print(selectedIntrestSId);
      } else {
        selectedIntrestSId.remove(id);
        print(selectedIntrestSId);
      }
    });
  }

  //Show leave group Dialog Box
  void showLeaveDialogBox(String groupId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                  height: 120,
                  width: 200,
                  decoration: BoxDecoration(
                      color: gray1, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                      crossAxisAlignment: cCenter,
                      mainAxisAlignment: mCenter,
                      children: [
                        customText("Afro United", 16, white),
                        customHeightBox(5),
                        customText(
                            "Are you sure to want leave into this group?",
                            13,
                            white),
                        customHeightBox(15),
                        Row(
                          crossAxisAlignment: cCenter,
                          mainAxisAlignment: mCenter,
                          children: [
                            InkWell(
                              onTap: () {
                                leaveJoinTheGroup(groupId, 1);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                width: 80,
                                decoration: BoxDecoration(
                                    gradient: commonButtonLinearGridient,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                    child: customText("Leave", 13, white)),
                              ),
                            ),
                            customWidthBox(30),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                width: 80,
                                decoration: BoxDecoration(
                                    border: Border.all(color: white, width: 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                    child: customText("Cancel", 13, white)),
                              ),
                            ),
                          ],
                        )
                      ])));
        });
  }

  //Leave/Join the group api
  Future<void> leaveJoinTheGroup(String groupId, int type) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    var user = UserDataConstants();
    String token = sharedPreferences.getString(user.token).toString();
    var jsonResponse = null;
    var apiName = type == 1
        ? "leave_group"
        : type == 2
            ? "join_group"
            : "";
    var response = await http.post(Uri.parse(BASE_URL + apiName), headers: {
      'api-key': API_KEY,
      'x-access-token': token,
    }, body: {
      "group_id": groupId
    });
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      if (type == 1) {
        Navigator.pop(context);
      }
      refreshData("");
      print("leave group  api success");
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
      throw Exception("Failed to load the work experience!");
    }
  }
}
