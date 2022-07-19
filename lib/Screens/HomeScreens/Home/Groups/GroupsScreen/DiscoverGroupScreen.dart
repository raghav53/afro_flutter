import 'dart:convert';

import 'package:afro/Model/Group/AllGroupModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupDetailsPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DiscoverGroupsScreen extends StatefulWidget {
  const DiscoverGroupsScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverGroupsScreen> createState() => _DiscoverGroupsScreenState();
}

Future<AllGroupsModel>? _allGroups;
var user = UserDataConstants();

class _DiscoverGroupsScreenState extends State<DiscoverGroupsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? userID, countryId;
  @override
  void initState() {
    super.initState();
    getUserData();
    Future.delayed(Duration.zero, () {
      _allGroups = getAllGroups(context);
      setState(() {});
      _allGroups!.whenComplete(() => () {});
    });
  }

  refreshData() {
    Future.delayed(Duration.zero, () {
      _allGroups = getAllGroups(context);
      setState(() {});
      _allGroups!.whenComplete(() => () {});
    });
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await _prefs;
    userID = sharedPreferences.getString(user.id).toString();
    countryId = sharedPreferences.getString(user.countryId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AllGroupsModel>(
        future: _allGroups,
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
                                  groupId: snapshot.data!.data![index].sId
                                      .toString(),
                                  groupAdmin: snapshot.data!.data![index].userId
                                      .toString(),
                                )));
                      },
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 20, right: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 10),
                        child: Row(children: [
                          CachedNetworkImage(
                              imageUrl: IMAGE_URL +
                                  snapshot.data!.data![index].coverImage!
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
                                    style:
                                        TextStyle(color: white, fontSize: 11),
                                  )),
                              customHeightBox(5),
                              Row(
                                children: [
                                  customText(
                                      snapshot.data!.data![index].totalMembers
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
                              if (userID.toString() ==
                                  snapshot.data!.data![index].userId
                                      .toString()) {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => GroupDetailsPage(
                                        groupId: snapshot.data!.data![index].sId
                                            .toString(),
                                        groupAdmin: snapshot
                                            .data!.data![index].userId
                                            .toString())));
                              }
                              if (snapshot.data!.data![index].isMember == 1 &&
                                  userID.toString() !=
                                      snapshot.data!.data![index].userId
                                          .toString()) {
                                showLeaveDialogBox(
                                    snapshot.data!.data![index].sId.toString());
                              }
                              if (snapshot.data!.data![index].isMember == 0 &&
                                  snapshot.data!.data![index].isMember == 0) {
                                leaveJoinTheGroup(
                                    snapshot.data!.data![index].sId.toString(),
                                    2);
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
                                      snapshot.data!.data![index].userId
                                                  .toString() ==
                                              userID.toString()
                                          ? "View Details"
                                          : snapshot.data!.data![index]
                                                      .isMember ==
                                                  1
                                              ? "Leave"
                                              : snapshot.data!.data![index]
                                                          .isJoinSent ==
                                                      1
                                                  ? "Cancel Request"
                                                  : snapshot.data!.data![index]
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
      refreshData();
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
