import 'dart:convert';

import 'package:afro/Model/AllInterestsModel.dart';
import 'package:afro/Model/CountryModel.dart';
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
List<String> selectedTempIntrestSId = [];
String selectInterestedIds = "";
String searchGroups = "";

class _RecommendedGroupsState extends State<RecommendedGroups> {
  @override
  void initState() {
    super.initState();
    getInterests();
    getData();
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
        child: SingleChildScrollView(
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
                            boxShadow:  [
                              BoxShadow(color: black, offset: Offset(0, 2))
                            ]),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchGroups = value.toString();
                            });
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
                          openFillterbottomSheet();
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
              getRecommendedGroups()
            ],
          ),
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
  //BottomSheet
  openFillterbottomSheet() {
    var selectedBottomIndex = 1;

    var indexTitle = "Country";
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
            return SingleChildScrollView(
              child: Container(
                  decoration: commonBoxDecoration(),
                  child: Column(children: [
                    customHeightBox(15),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: mBetween,
                        children: [
                          customText(
                              "Filter & Sort", 12, const Color(0xFFDFB48C)),
                          customText(indexTitle, 12, const Color(0xFFDFB48C)),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                    customDivider(5, Colors.white),
                    Row(crossAxisAlignment: cStart, children: [
                      Container(
                          padding: const EdgeInsets.only(top: 15, left: 10),
                          child: Column(
                              mainAxisAlignment: mStart,
                              crossAxisAlignment: cStart,
                              children: [
                                // InkWell(
                                //   onTap: () {
                                //     state(() {
                                //       selectedBottomIndex = 0;
                                //       indexTitle = "Country";
                                //     });
                                //   },
                                //   child: Container(
                                //     width: 80,
                                //     decoration: BoxDecoration(
                                //         gradient: (selectedBottomIndex == 0)
                                //             ? commonButtonLinearGridient
                                //             : null,
                                //         border: selectedBottomIndex != 0
                                //             ? Border.all(
                                //                 color: Colors.white,
                                //                 width: 1,
                                //                 style: BorderStyle.solid)
                                //             : null,
                                //         borderRadius: BorderRadius.circular(20)),
                                //     child: Center(
                                //         child: Padding(
                                //       padding: const EdgeInsets.only(
                                //           top: 8, bottom: 8),
                                //       child:
                                //           customText("Country", 12, Colors.white),
                                //     )),
                                //   ),
                                // ),
                                // customHeightBox(15),
                                InkWell(
                                  onTap: () {
                                    state(() {
                                      selectedBottomIndex = 1;
                                      indexTitle = "Members";
                                    });
                                  },
                                  child: Container(
                                    width: 80,
                                    decoration: BoxDecoration(
                                        gradient: (selectedBottomIndex == 1)
                                            ? commonButtonLinearGridient
                                            : null,
                                        border: selectedBottomIndex != 1
                                            ? Border.all(
                                                color: Colors.white,
                                                width: 1,
                                                style: BorderStyle.solid)
                                            : null,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8),
                                      child:
                                          customText("Members", 12, Colors.white),
                                    )),
                                  ),
                                ),
                                customHeightBox(15),
                                InkWell(
                                  onTap: () {
                                    state(() {
                                      selectedBottomIndex = 2;
                                      indexTitle = "Interests";
                                    });
                                  },
                                  child: Container(
                                    width: 80,
                                    decoration: BoxDecoration(
                                        gradient: (selectedBottomIndex == 2)
                                            ? commonButtonLinearGridient
                                            : null,
                                        border: selectedBottomIndex != 2
                                            ? Border.all(
                                                color: Colors.white,
                                                width: 1,
                                                style: BorderStyle.solid)
                                            : null,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8),
                                      child: customText(
                                          "Interests", 12, Colors.white),
                                    )),
                                  ),
                                ),
                                customHeightBox(15),
                                InkWell(
                                  onTap: () {
                                    state(() {});
                                    defaultValues();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 80,
                                    decoration: BoxDecoration(
                                        gradient: (selectedBottomIndex == 3)
                                            ? commonButtonLinearGridient
                                            : null,
                                        border: selectedBottomIndex != 3
                                            ? Border.all(
                                                color: Colors.white,
                                                width: 1,
                                                style: BorderStyle.solid)
                                            : null,
                                        borderRadius: BorderRadius.circular(20)),
                                    child: Center(
                                        child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8),
                                      child: customText(
                                          "Clear All", 12, Colors.white),
                                    )),
                                  ),
                                ),
                              ])),
                      Container(
                          margin: const EdgeInsets.only(left: 15),
                          height: phoneHeight(context) / 2.07,
                          decoration: const BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.grey, width: 0.8))),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              SizedBox(
                                  width: phoneWidth(context) / 1.5,
                                  child: selectedBottomIndex == 0
                                      ? Column(
                                          children: [
                                            Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black),
                                              margin: const EdgeInsets.only(
                                                  top: 15, left: 10, right: 10),
                                              child: const TextField(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            top: 8, left: 15),
                                                    prefixIcon: Icon(
                                                      Icons.search,
                                                      color: Color(0xFFDFB48C),
                                                    ),
                                                  )),
                                            ),
                                            customHeightBox(10),
                                            Container(
                                                height:
                                                    phoneHeight(context) / 2.7,
                                                child:
                                                    FutureBuilder<CountryModel>(
                                                  // future: _getCountries,
                                                  builder: (context, snapshot) {
                                                    return snapshot.hasData &&
                                                            snapshot.data != null
                                                        ? ListView.builder(
                                                            itemCount: snapshot
                                                                .data!
                                                                .data!
                                                                .length,
                                                            itemBuilder:
                                                                (context, index) {
                                                              return ListTile(
                                                                leading:
                                                                    CachedNetworkImage(
                                                                  height: 35,
                                                                  width: 35,
                                                                  imageUrl: flagImageUrl
                                                                          .toString() +
                                                                      snapshot
                                                                          .data!
                                                                          .data![
                                                                              index]
                                                                          .iso2
                                                                          .toString()
                                                                          .toLowerCase() +
                                                                      ".png",
                                                                  placeholder: (context,
                                                                          url) =>
                                                                      const Icon(
                                                                          Icons
                                                                              .flag),
                                                                  errorWidget: (context,
                                                                          url,
                                                                          error) =>
                                                                      const Icon(Icons
                                                                          .error),
                                                                ),
                                                                title: customText(
                                                                    snapshot
                                                                        .data!
                                                                        .data![
                                                                            index]
                                                                        .title
                                                                        .toString(),
                                                                    15,
                                                                    white),
                                                                trailing:
                                                                    Checkbox(
                                                                        value: snapshot
                                                                            .data!
                                                                            .data![
                                                                                index]
                                                                            .isSelected,
                                                                        onChanged:
                                                                            (val) {
                                                                          state(
                                                                              () {
                                                                            snapshot
                                                                                .data!
                                                                                .data![index]
                                                                                .isSelected = !snapshot.data!.data![index].isSelected;
                                                                            // addRemoveCountriesIds(
                                                                            //     snapshot.data!.data![index].sId.toString(),
                                                                            //     snapshot.data!.data![index].isSelected);
                                                                          });
                                                                        }),
                                                              );
                                                            })
                                                        : Center(
                                                            child: customText(
                                                                "No countries found!",
                                                                15,
                                                                white),
                                                          );
                                                  },
                                                ))
                                          ],
                                        )
                                      : selectedBottomIndex == 1
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  top: 15, left: 10, right: 10),
                                              width: 270,
                                              child: Column(
                                                  crossAxisAlignment: cCenter,
                                                  children: [
                                                    RangeSlider(
                                                      activeColor: yellowColor,
                                                      inactiveColor: white,
                                                      min: 0,
                                                      max: 500,
                                                      values: selectedRange,
                                                      onChanged:
                                                          (RangeValues newValue) {
                                                        state(() {
                                                          selectedRange =
                                                              newValue;
                                                          _startRange = newValue
                                                              .start
                                                              .toInt();
                                                          _endRange = newValue.end
                                                              .toInt();
                                                        });
                                                      },
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 11),
                                                      child: Row(
                                                        children: [
                                                          customText(
                                                              "min " +
                                                                  _startRange
                                                                      .toString(),
                                                              15,
                                                              white),
                                                          Spacer(),
                                                          customText(
                                                              "max " +
                                                                  _endRange
                                                                      .toString(),
                                                              15,
                                                              white)
                                                        ],
                                                      ),
                                                    )
                                                  ]))
                                          : selectedBottomIndex == 2
                                              ? Container(
                                                  child:
                                                      FutureBuilder<
                                                              AllInterestModel>(
                                                          future:
                                                              _getAllInterests,
                                                          builder: (context,
                                                              snapshot) {
                                                            return snapshot
                                                                        .hasData &&
                                                                    snapshot.data !=
                                                                        null
                                                                ? ListView
                                                                    .builder(
                                                                        itemCount: snapshot
                                                                            .data!
                                                                            .data!
                                                                            .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return ListTile(
                                                                            title: customText(
                                                                                snapshot.data!.data![index].title.toString(),
                                                                                15,
                                                                                white),
                                                                            trailing: Checkbox(
                                                                                value: snapshot.data!.data![index].isSelected,
                                                                                onChanged: (val) {
                                                                                  state(() {
                                                                                    snapshot.data!.data![index].isSelected = !snapshot.data!.data![index].isSelected;
                                                                                    addInSelectedArray(snapshot.data!.data![index].sId.toString(), snapshot.data!.data![index].isSelected);
                                                                                  });
                                                                                }),
                                                                          );
                                                                        })
                                                                : Center(
                                                                    child: customText(
                                                                        "No categories found!",
                                                                        15,
                                                                        white),
                                                                  );
                                                          }))
                                              : Container()),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: InkWell(
                                  onTap: () {
                                    setState(() {});

                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(bottom: 20),
                                      padding: const EdgeInsets.only(
                                          top: 7, bottom: 7, left: 20, right: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        gradient: commonButtonLinearGridient,
                                      ),
                                      child:
                                          customText("Apply", 16, Colors.white)),
                                ),
                              )
                            ],
                          ))
                    ])
                  ])),
            );
          });
        });
  }

  //Get all interests api
  getInterests() {
    Future.delayed(Duration.zero, () {
      _getAllInterests = getInterestssList(context, isShow: false);
      setState(() {});
      _getAllInterests!.whenComplete(() => () {});
    });
  }

  //Add/Remove the interest id
  addInSelectedArray(String id, bool val) async {
    if (val) {
      selectedTempIntrestSId.add(id);
      print(selectedTempIntrestSId);
    } else {
      selectedTempIntrestSId.remove(id);
      print(selectedTempIntrestSId);
    }
    selectInterestedIds = selectedTempIntrestSId.join(",");
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
                                padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                                padding: const EdgeInsets.only(top: 8, bottom: 8),
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
      setState(() {});
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

  //Get the recommanded groups
  getRecommendedGroups() {
    return FutureBuilder<AllGroupsModel>(
        future: getAllGroups(
            showProgress: false,
            search: searchGroups,
            members_max: _endRange.toString(),
            members_min: _startRange.toString(),
            interests: selectInterestedIds),
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data != null
              ? groupsListView(snapshot.data!)
              : snapshot.data == null
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Center(
                  child: customText("No groups found!", 15, white),
                );
        });
  }

  //List of groups
  Widget groupsListView(AllGroupsModel snapshot) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GroupDetailsPage(
                        groupId: snapshot.data![index].sId.toString(),
                        groupAdmin: snapshot.data![index].userId.toString(),
                      )));
            },
            child: Container(
              margin: const EdgeInsets.only(top: 10, left: 20, right: 5),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
              child: Row(children: [
                CachedNetworkImage(
                    imageUrl: IMAGE_URL +
                        snapshot.data![index].coverImage!.toString(),
                    errorWidget: (error, context, url) =>
                        const Icon(Icons.person),
                    placeholder: (context, url) => const Icon(Icons.person),
                    imageBuilder: (context, url) {
                      return CircleAvatar(
                        backgroundImage: url,
                      );
                    }),
                customWidthBox(10),
                Column(
                  crossAxisAlignment: cStart,
                  children: [
                    Row(
                      children: [
                        Text(
                          snapshot.data![index].title.toString(),
                          overflow: TextOverflow.fade,
                          maxLines: null,
                          softWrap: false,
                          style: TextStyle(color: white, fontSize: 14),
                        ),
                        const SizedBox(width: 4,),
                        (snapshot.data![index].privacy==1) ?Image.asset("assets/website_icon.png",height: 15,width: 15,color: white,)
                            :(snapshot.data![index].privacy==2)?Container(
                          height: 15,
                          width: 15,
                          decoration:BoxDecoration(
                            shape: BoxShape.circle,
                            color: white
                          ) ,
                          alignment: Alignment.center,
                          child:  ShaderMask(

                            shaderCallback: (Rect bounds) => const RadialGradient(
                              center: Alignment.topCenter,
                              stops: [0.5,1],

                              colors: [
                                Color(0xff694FB1),
                                Color(0xff8134A5),
                              ],
                              tileMode: TileMode.mirror,
                            ).createShader(bounds),
                            child: const Icon(Icons.lock_outline,size: 10,),),
                        )
                            :(snapshot.data![index].privacy==3)?const SizedBox():const SizedBox(),

                      ],
                    ),
                    customHeightBox(5),
                    Row(
                      children: [
                        customText(
                            snapshot.data![index].totalMembers.toString() +
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
                    if (snapshot.data![index].isMember == 1) {
                      showLeaveDialogBox(
                          snapshot.data![index].sId.toString());
                    }
                    if (snapshot.data![index].isMember == 0 &&
                        snapshot.data![index].isMember == 0) {
                      leaveJoinTheGroup(
                          snapshot.data![index].sId.toString(), 2);
                    }
                  },
                  child: Container(
                    width: 110,
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 10, left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: commonButtonLinearGridient),
                    child: Center(
                        child: customText(
                            snapshot.data![index].isMember == 1
                                ?"Leave"
                                :snapshot.data![index].isJoinSent == 1
                                    ? "Cancel Request"
                                    : snapshot.data![index]
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
        });
  }

  //Clear the all fillters
  defaultValues() {
    setState(() {
      _endRange = 500;
      _startRange = 0;
      selectedTempIntrestSId.clear();
      selectInterestedIds = "";
    });
  }
}
