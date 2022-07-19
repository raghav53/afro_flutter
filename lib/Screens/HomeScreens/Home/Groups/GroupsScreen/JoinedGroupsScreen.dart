import 'dart:convert';

import 'package:afro/Model/Group/JoinedGroup/JoinedGroupmodel.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class JoinedGroupsScreen extends StatefulWidget {
  const JoinedGroupsScreen({Key? key}) : super(key: key);

  @override
  State<JoinedGroupsScreen> createState() => _JoinedGroupsScreenState();
}

Future<JoinedGroupModel>? _allGroups;
var user = UserDataConstants();
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
String? loginUserId = "";

class _JoinedGroupsScreenState extends State<JoinedGroupsScreen> {
  @override
  void initState() {
    super.initState();
    getUserData();
    Future.delayed(Duration.zero, () {
      _allGroups = getAllJoinedGroups(context);
      setState(() {});
      _allGroups!.whenComplete(() => () {});
    });
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await _prefs;
    loginUserId = sharedPreferences.getString(user.id).toString();
  }

  refreshData() {
    Future.delayed(Duration.zero, () {
      _allGroups = getAllJoinedGroups(context);
      setState(() {});
      _allGroups!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<JoinedGroupModel>(
        future: _allGroups,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.data!.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                          const EdgeInsets.only(top: 15, bottom: 15, left: 10),
                      child: Column(
                        children: [
                          Row(children: [
                            CachedNetworkImage(
                                imageUrl: IMAGE_URL +
                                    snapshot
                                        .data!.data![index].group!.coverImage!
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
                                      snapshot.data!.data![index].group!.title
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
                                        snapshot.data!.data![index].group!
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
                                loginUserId ==
                                        snapshot
                                            .data!.data![index].group!.userId!
                                            .toString()
                                    ? Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GroupDetailsPage(
                                                  groupId: snapshot.data!
                                                      .data![index].groupId
                                                      .toString(),
                                                  groupAdmin: snapshot
                                                      .data!
                                                      .data![index]
                                                      .group!
                                                      .userId
                                                      .toString(),
                                                )))
                                    : leaveTheGroup(snapshot
                                        .data!.data![index].groupId
                                        .toString());
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
                                        loginUserId ==
                                                snapshot.data!.data![index]
                                                    .group!.userId!
                                                    .toString()
                                            ? "View Details"
                                            : "Leave",
                                        11,
                                        white)),
                              ),
                            )
                          ]),
                          customHeightBox(5),
                          customDivider(1, white24)
                        ],
                      ),
                    );
                  })
              : Center(
                  child: customText("No data found!", 15, white),
                );
        });
  }

  //Leave/Join the group api
  Future<void> leaveTheGroup(String groupId) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    var user = UserDataConstants();
    String token = sharedPreferences.getString(user.token).toString();
    var jsonResponse = null;
    var response =
        await http.post(Uri.parse(BASE_URL + "leave_group"), headers: {
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
      refreshData();
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
}
