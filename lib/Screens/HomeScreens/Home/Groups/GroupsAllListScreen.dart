import 'dart:convert';
import 'package:afro/Model/Group/AllGroupModel.dart';
import 'package:afro/Model/Group/JoinedGroup/JoinedGroupmodel.dart';
import 'package:afro/Model/Group/UserGroups/UserGroupsModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupDetailsPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/CreateNewGroupScreen.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GroupsAllListScreen extends StatefulWidget {
  const GroupsAllListScreen({Key? key}) : super(key: key);

  @override
  State<GroupsAllListScreen> createState() => _GroupsAllListScreenState();
}

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
String? userID, countryId;
var searchGroup = "";

class _GroupsAllListScreenState extends State<GroupsAllListScreen> {
  int clickPosition = 0;
  bool _showFab = true;
  LinearGradient selectedColor = commonButtonLinearGridient;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await _prefs;
    userID = sharedPreferences.getString(user.id).toString();
    countryId = sharedPreferences.getString(user.countryId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: onlyTitleCommonAppbar("Groups"),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreateNewGroup()));
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: commonButtonLinearGridient),
            child: Icon(
              Icons.add,
              color: white,
            ),
          ),
        ),
        body: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(children: [
              customHeightBox(80),
              custom(),
              customHeightBox(25),
              selectCategory(),
              setFillterLayout(clickPosition)
            ]),
          ),
        ),
      ),
    );
  }

  Widget selectCategory() {
    return Container(
        height: 50,
        child: Row(
          mainAxisAlignment: mEvenly,
          crossAxisAlignment: cStart,
          children: [
            Flexible(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showFab = false;
                    clickPosition = 0;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      gradient: (clickPosition == 0) ? selectedColor : null,
                      border: (clickPosition == 0)
                          ? null
                          : Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    child: customText("Discover", 12, Colors.white),
                  ),
                ),
              ),
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showFab = false;

                    clickPosition = 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      gradient: (clickPosition == 1) ? selectedColor : null,
                      border: (clickPosition == 1)
                          ? null
                          : Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: customText("Joined Group", 12, Colors.white),
                  ),
                ),
              ),
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showFab = true;
                    clickPosition = 2;
                    //setCustomListTile = MyRepliesTile();
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      gradient: (clickPosition == 2) ? selectedColor : null,
                      border: (clickPosition == 2)
                          ? null
                          : Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: customText("My Group", 12, Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  //Search bar
  Widget custom() {
    return Row(
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
                  setState(() {
                    searchGroup = value.toString();
                  });
                },
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFFDFB48C),
                    ),
                    hintText: "Search",
                    contentPadding: const EdgeInsets.only(left: 15, top: 15),
                    hintStyle: const TextStyle(color: Colors.white24)),
              ),
            )),
        customWidthBox(20),
        Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                //openBottomSheet();
              },
              child: Image.asset(
                "assets/icons/fillter.png",
                height: 20,
                width: 20,
              ),
            )),
      ],
    );
  }

  //set the custom fillter view
  setFillterLayout(int postion) {
    if (postion == 0) {
      return FutureBuilder<AllGroupsModel>(
          future: getAllGroups(search: searchGroup),
          builder: (context, snapshot) {
            print("kjvgkvcyvctkucdkghfm: $snapshot");
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? DiscoverGroupsList(snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          });
    } else if (postion == 1) {
      return FutureBuilder<JoinedGroupModel>(
          future: getAllJoinedGroups(search: searchGroup),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? JoinedGroupsList(snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          });
    } else if (postion == 2) {
      return FutureBuilder<UserGroupsModel>(
          future: getAllUsersGroups(search: searchGroup),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? MyGroupsListScreen(context, snapshot.data!)
                : const CircularProgressIndicator();
          });
    }
  }

//Discover groups List
  DiscoverGroupsList(AllGroupsModel snapshot) {
    return Container(
      height: phoneHeight(context),
      width: phoneWidth(context),
      child: ListView.builder(
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
                margin: EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 5,
                    bottom: snapshot.data!.length - 1 == index ? 20 : 0),
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
                      SizedBox(
                          width: 120,
                          child: Text(
                            snapshot.data![index].title.toString(),
                            overflow: TextOverflow.fade,
                            maxLines: null,
                            softWrap: false,
                            style: TextStyle(color: white, fontSize: 11),
                          )),
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
                      if (userID.toString() ==
                          snapshot.data![index].userId.toString()) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GroupDetailsPage(
                                groupId: snapshot.data![index].sId.toString(),
                                groupAdmin:
                                    snapshot.data![index].userId.toString())));
                      }
                      if (snapshot.data![index].isMember == 1 &&
                          userID.toString() !=
                              snapshot.data![index].userId.toString()) {
                        showLeaveDialogBox(
                            context, snapshot.data![index].sId.toString());
                      }
                      if (snapshot.data![index].isMember == 0 &&
                          snapshot.data![index].isMember == 0) {
                        leaveJoinTheGroup(
                            context, snapshot.data![index].sId.toString(), 2);
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
                              snapshot.data![index].userId.toString() ==
                                      userID.toString()
                                  ? "View Details"
                                  : snapshot.data![index].isMember == 1
                                      ? "Leave"
                                      : snapshot.data![index].isJoinSent == 1
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
          }),
    );
  }

//Show leave group Dialog Box
  void showLeaveDialogBox(BuildContext context, String groupId) {
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
                                leaveJoinTheGroup(context, groupId, 1);
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
  Future<void> leaveJoinTheGroup(
      BuildContext context, String groupId, int type) async {
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

  //Joined Groups List
  JoinedGroupsList(JoinedGroupModel snapshot) {
    return Container(
        height: phoneHeight(context),
        width: phoneWidth(context),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(top: 10, left: 10, right: 5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
                child: Column(
                  children: [
                    Row(children: [
                      CachedNetworkImage(
                          imageUrl: IMAGE_URL +
                              snapshot.data![index].group!.coverImage!
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
                                snapshot.data![index].group!.title.toString(),
                                overflow: TextOverflow.fade,
                                maxLines: null,
                                softWrap: false,
                                style: TextStyle(color: white, fontSize: 11),
                              )),
                          customHeightBox(5),
                          Row(
                            children: [
                              customText(
                                  snapshot.data![index].group!.totalMembers
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
                          userID ==
                                  snapshot.data![index].group!.userId!
                                      .toString()
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => GroupDetailsPage(
                                        groupId: snapshot.data![index].groupId
                                            .toString(),
                                        groupAdmin: snapshot
                                            .data![index].group!.userId
                                            .toString(),
                                      )))
                              : showLeaveDialogBox(context,
                                  snapshot.data![index].groupId.toString());
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
                                  userID ==
                                          snapshot.data![index].group!.userId!
                                              .toString()
                                      ? "View Details"
                                      : "Leave",
                                  11,
                                  white)),
                        ),
                      )
                    ]),
                  ],
                ),
              );
            }));
  }

  //User Groups List
  MyGroupsListScreen(BuildContext context, UserGroupsModel snapshot) {
    return Container(
        margin: EdgeInsets.only(bottom: 70),
        width: phoneWidth(context),
        height: phoneHeight(context),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(top: 10, left: 15, right: 5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
                child: Column(
                  children: [
                    Row(children: [
                      CachedNetworkImage(
                          imageUrl: IMAGE_URL +
                              snapshot.data![index].coverImage!.toString(),
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
                                snapshot.data![index].title.toString(),
                                overflow: TextOverflow.fade,
                                maxLines: null,
                                softWrap: false,
                                style: TextStyle(color: white, fontSize: 11),
                              )),
                          customHeightBox(5),
                          Row(
                            children: [
                              customText(
                                  snapshot.data![index].totalMembers
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GroupDetailsPage(
                                    groupId:
                                        snapshot.data![index].id.toString(),
                                    groupAdmin: snapshot.data![index].userId!.id
                                        .toString(),
                                  )));
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
                              child: customText("View Details", 11, white)),
                        ),
                      )
                    ]),
                  ],
                ),
              );
            }));
  }

  //Get all user groups
  Future<UserGroupsModel> getAllUsersGroups({
    String search = "",
    bool showProgress = true,
    String page = "1",
    String limit = "500",
  }) async {
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    String userId = sharedPreferences.getString(user.id).toString();
    print(token);

    var jsonResponse = null;

    var response = await http.get(
        Uri.parse(
            BASE_URL + "user_groups?page=$page&limit=$limit&search=$search"),
        headers: {
          'api-key': API_KEY,
          'x-access-token': token,
        });
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      print("Get All Users groups api success");
      print(jsonResponse["metadata"]["totalDocs"]);
      return UserGroupsModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      customToastMsg(message);
      throw Exception("Failed to load the work experience!");
    }
  }
}
