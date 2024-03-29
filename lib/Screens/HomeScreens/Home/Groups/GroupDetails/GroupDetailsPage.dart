import 'dart:convert';

import 'package:afro/Screens/HomeScreens/Home/MyProfile.dart';
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:afro/Model/Group/AllUserForGroup/AllGroupUsersModel.dart';
import 'package:afro/Model/Group/GroupDetails/Disscussion/GroupPostDataModel.dart';
import 'package:afro/Model/Group/GroupDetails/Disscussion/GroupPostModel.dart';
import 'package:afro/Model/Group/GroupDetails/GroupDetailsModel.dart';
import 'package:afro/Model/Group/GroupDetails/GroupMedia/GroupMediaModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/ShareThoughtsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupContactsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupPostCommentList.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupMembersList.dart';
import 'package:afro/Screens/VideoImageViewPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';

class GroupDetailsPage extends StatefulWidget {
  String groupId = "";
  String groupAdmin = "";
  GroupDetailsPage({Key? key, required this.groupId, required this.groupAdmin})
      : super(key: key);
  @override
  GoupDetailsPageState createState() => GoupDetailsPageState();
}

var user = UserDataConstants();
Future<GroupDetailsModel>? _getGroupDetails;
Future<AllGroupUsersModel>? _getAllGroupUsers;
List<String> filterList = ["Discussion", "Photo", "Video", "Contacts"];
List<String> filterListItemImages = [
  "assets/icons/menu_line.png",
  "assets/icons/camera.png",
  "assets/icons/video.png",
  "assets/icons/group_white.png",
];
var selectedIndex = 0;
var selectedText = "Discussion";

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
var userData = UserDataConstants();
var userId = "";

class GoupDetailsPageState extends State<GroupDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getGroupDetails = getGroupDetails(context, widget.groupId);
      getUserDetails();
      setState(() {});
      _getGroupDetails!.whenComplete(() => () {});
    });
  }

  onResumed() {
    Future.delayed(Duration.zero, () {
      _getGroupDetails =
          getGroupDetails(context, widget.groupId, showProgress: false);
      setState(() {});
      _getGroupDetails!.whenComplete(() => () {});
    });
  }

  getUserDetails() async {
    SharedPreferences data = await _prefs;
    userId = data.getString(userData.id).toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            child: FutureBuilder<GroupDetailsModel>(
              future: _getGroupDetails,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: phoneHeight(context),
                                height: 250,
                                child: CachedNetworkImage(
                                  imageUrl: IMAGE_URL +
                                      snapshot.data!.data!.coverImage
                                          .toString(),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: phoneWidth(context),
                                    height: 150.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                  placeholder: (context, url) =>
                                      CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: //Show popmenu
                                    Container(
                                        margin: EdgeInsets.only(top: 20),
                                        child: snapshot.data!.data!.isMember ==
                                                1
                                            ? GestureDetector(
                                                onTapDown: (tapDownDetails) {
                                                  showUserPopupMenu(
                                                      tapDownDetails);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 10),
                                                  child: Icon(
                                                    Icons.more_vert_outlined,
                                                    color: white,
                                                  ),
                                                ),
                                              )
                                            : null),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: BackButton(
                                  color: white,
                                ),
                              )
                            ],
                          ),
                          customHeightBox(10),
                          Container(
                            margin: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: cStart,
                                      children: [
                                        customText(
                                            snapshot.data!.data!.title
                                                .toString(),
                                            15,
                                            white),
                                        customHeightBox(5),
                                        customText(
                                            snapshot.data!.data!.about
                                                .toString(),
                                            11,
                                            Color(0x3DFFFFFF))
                                      ],
                                    ),
                                    Spacer(),
                                    InkWell(
                                      onTap: () {
                                        if (snapshot.data!.data!.userId!.id ==
                                            userId) {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      MyProfilePage()));
                                        } else {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (builder) =>
                                                      OtherUserProfilePageScreen(
                                                        name: snapshot
                                                            .data!
                                                            .data!
                                                            .userId!
                                                            .fullName,
                                                        userID: snapshot.data!
                                                            .data!.userId!.id,
                                                      )));
                                        }
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Created By: ",
                                          style: const TextStyle(
                                              color: Color(0x3DFFFFFF),
                                              fontSize: 11),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: snapshot.data!.data!
                                                    .userId!.fullName
                                                    .toString(),
                                                style: TextStyle(color: white)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                customHeightBox(15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/world_grid.png",
                                          height: 17,
                                          width: 17,
                                        ),
                                        //1= public , 2=closed , 3=secret
                                        customWidthBox(4),
                                        customText(
                                            getPrivacy(
                                                snapshot.data!.data!.privacy!),
                                            12,
                                            white)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/world_grid.png",
                                          height: 17,
                                          width: 17,
                                        ),
                                        customWidthBox(4),
                                        customText(
                                            snapshot.data!.data!.category!.title
                                                .toString(),
                                            12,
                                            white)
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GroupMemberListScreen(
                                                        group_id: snapshot
                                                            .data!.data!.sId
                                                            .toString(),
                                                        userId: userId)));
                                      },
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "assets/icons/group_white.png",
                                            height: 17,
                                            width: 17,
                                          ),
                                          customWidthBox(4),
                                          customText(
                                              snapshot.data!.data!.totalMembers
                                                      .toString() +
                                                  " Members",
                                              12,
                                              white)
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          customHeightBox(15),
                          customDivider(20, white),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, top: 10, bottom: 10),
                            height: 25,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: filterList.length,
                                itemBuilder: (context, index) {
                                  return filterItemView(filterList[index],
                                      index, filterListItemImages[index]);
                                }),
                          ),
                          customHeightBox(10),
                          selectedFilterView(
                              selectedIndex,
                              snapshot.data!.data!.userId!.id.toString(),
                              snapshot.data!.data!.privacy!),
                        ],
                      )
                    : Center(
                        child: customText("No group details", 15, white),
                      );
              },
            ),
          )),
    ));
  }

  //Fillter items
  Widget filterItemView(String title, int index, String image) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        decoration: BoxDecoration(
            gradient:
                (selectedIndex == index) ? commonButtonLinearGridient : null,
            border: (selectedIndex == index)
                ? null
                : Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: [
            Image.asset(
              image,
              height: 12,
              width: 12,
            ),
            customWidthBox(5),
            customText(title, 12, white),
          ],
        ),
      ),
    );
  }

  //Get the privacy of group
  String getPrivacy(int privacy) {
    String pri = "";
    if (privacy == 1)
      pri = "Public";
    else if (privacy == 2)
      pri = "Closed";
    else if (privacy == 3) pri = "Secret";
    return pri;
  }

  //Show  popup if Login user and group created user is same
  showUserPopupMenu(TapDownDetails details) async {
    var tapPosition = details.globalPosition;
    final RenderBox overlay =
        Overlay.of(context)?.context.findRenderObject() as RenderBox;
    await showMenu(
      color: Colors.transparent,
      context: context,
      position: RelativeRect.fromRect(
          tapPosition & const Size(30, 1.5), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //Delete/Leave Button
        PopupMenuItem(
            padding: EdgeInsets.zero,
            child: InkWell(
              onTap: (() {
                Navigator.pop(context);
                widget.groupAdmin == userId
                    ? showGroupDeleteDialogBox(
                        widget.groupId.toString(), context)
                    : showLeaveGroupDialogBox(
                        widget.groupId.toString(), context);
              }),
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: black),
                child: Row(mainAxisAlignment: mCenter, children: [
                  Icon(
                    widget.groupAdmin == userId.toString()
                        ? Icons.delete
                        : Icons.exit_to_app,
                    size: 15,
                    color: white,
                  ),
                  customWidthBox(10),
                  customText(
                      widget.groupAdmin == userId.toString()
                          ? "Delete"
                          : "Leave",
                      11,
                      white)
                ]),
              ),
            )),

        //Invite Button
        PopupMenuItem(
            padding: EdgeInsets.zero,
            child: InkWell(
              onTap: (() {
                Navigator.pop(context);
                showAllInvitingUsers();
              }),
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: black),
                child: Row(mainAxisAlignment: mCenter, children: [
                  Image.asset(
                    "assets/icons/message.png",
                    height: 15,
                    width: 15,
                  ),
                  customWidthBox(10),
                  customText("Invite", 11, white)
                ]),
              ),
            )),
      ],
      elevation: 0.0,
    );
  }

  //Delete event item alert box
  void showGroupDeleteDialogBox(String gId, BuildContext context) {
    showDialog(
        barrierDismissible: true,
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
                        customHeightBox(10),
                        customText("Event Delete!", 16, white),
                        customHeightBox(5),
                        customText("Are you sure want to delete this group?",
                            15, white),
                        customHeightBox(20),
                        Row(
                          mainAxisAlignment: mCenter,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                deleteUserGroup(gId);
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                    gradient: commonButtonLinearGridient,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: customText("Delete", 15, white),
                                ),
                              ),
                            ),
                            customWidthBox(30),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                    gradient: commonButtonLinearGridient,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: customText("Cancel", 15, white),
                                ),
                              ),
                            )
                          ],
                        ),
                        customHeightBox(10)
                      ])));
        });
  }

  // leave the group
  void showLeaveGroupDialogBox(String gId, BuildContext context) {
    showDialog(
        barrierDismissible: true,
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
                        customHeightBox(10),
                        customText("Afro-United", 16, white),
                        customHeightBox(5),
                        customText("Are you sure want to leave this group?", 15,
                            white),
                        customHeightBox(20),
                        Row(
                          mainAxisAlignment: mCenter,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                leaveTheGroup(widget.groupId.toString());
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                    gradient: commonButtonLinearGridient,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: customText("Leave", 15, white),
                                ),
                              ),
                            ),
                            customWidthBox(30),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                    gradient: commonButtonLinearGridient,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: customText("Cancel", 15, white),
                                ),
                              ),
                            )
                          ],
                        ),
                        customHeightBox(10)
                      ])));
        });
  }

  //Delete user event
  Future<void> deleteUserGroup(String groupId) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    var jsonResponse = null;
    var response = await http.delete(
      Uri.parse(BASE_URL + "group/$groupId"),
      headers: {
        'api-key': API_KEY,
        'x-access-token': token,
      },
    );
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      print("delete group api success");
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

  // Get All users for event
  getUsersForEventGroups() {
    Future.delayed(Duration.zero, () {
      _getAllGroupUsers = getAllGroupsUsers(context, widget.groupId.toString());
      setState(() {});
      _getAllGroupUsers!.whenComplete(() => () {});
    });
  }

  //Show Invites users list
  void showAllInvitingUsers() {
    getUsersForEventGroups();
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context1) {
          return StatefulBuilder(builder: (context, state) {
            return Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                child: Container(
                  height: 550,
                  width: phoneWidth(context1),
                  decoration: BoxDecoration(
                      color: gray1, borderRadius: BorderRadius.circular(10)),
                  child: FutureBuilder<AllGroupUsersModel>(
                      future: _getAllGroupUsers,
                      builder: (context, snapshot) {
                        return snapshot.hasData &&
                                snapshot.data!.data!.isNotEmpty
                            ? Column(
                                children: [
                                  customHeightBox(10),
                                  customText("Select", 15, white),
                                  customHeightBox(10),
                                  Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    height: 500,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.data!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Row(
                                            children: [
                                              //Profile Image of user
                                              Stack(
                                                alignment:
                                                    Alignment.bottomRight,
                                                children: [
                                                  DottedBorder(
                                                    radius:
                                                        const Radius.circular(
                                                            2),
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    borderType:
                                                        BorderType.Circle,
                                                    color:
                                                        const Color(0xFF3E55AF),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1),
                                                      child: CachedNetworkImage(
                                                          imageUrl: IMAGE_URL +
                                                              snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .profileImage
                                                                  .toString(),
                                                          errorWidget: (error,
                                                                  context,
                                                                  url) =>
                                                              const Icon(
                                                                  Icons.person),
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Icon(
                                                                  Icons.person),
                                                          imageBuilder:
                                                              (context, url) {
                                                            return CircleAvatar(
                                                              backgroundImage:
                                                                  url,
                                                            );
                                                          }),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 9,
                                                    width: 9,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 3,
                                                            bottom: 3),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        gradient:
                                                            commonButtonLinearGridient),
                                                  )
                                                ],
                                              ),
                                              customWidthBox(10),
                                              //Name , Location
                                              Column(
                                                mainAxisAlignment: mStart,
                                                crossAxisAlignment: cStart,
                                                children: [
                                                  customText(
                                                      snapshot.data!
                                                          .data![index].fullName
                                                          .toString(),
                                                      12,
                                                      Colors.white),
                                                  customHeightBox(7),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.location_pin,
                                                        color:
                                                            Color(0xFFDFB48C),
                                                        size: 15,
                                                      ),
                                                      customWidthBox(2),
                                                      customText(
                                                          snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .city!
                                                                  .isEmpty
                                                              ? "Not available!"
                                                              : snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .city![0]
                                                                  .title
                                                                  .toString(),
                                                          12,
                                                          yellowColor)
                                                    ],
                                                  )
                                                ],
                                              ),
                                              customWidthBox(10),
                                              Spacer(),
                                              //Invite button
                                              InkWell(
                                                onTap: () {
                                                  sendInvitation(
                                                      widget.groupId.toString(),
                                                      snapshot.data!
                                                          .data![index].sId
                                                          .toString(),
                                                      state);
                                                  state(() {});
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 80,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8,
                                                          bottom: 8,
                                                          left: 10,
                                                          right: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .isGroupInviteSent ==
                                                              0
                                                          ? null
                                                          : white24,
                                                      gradient: snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .isGroupInviteSent ==
                                                              0
                                                          ? commonButtonLinearGridient
                                                          : null),
                                                  child: customText(
                                                      snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .isGroupInviteSent ==
                                                              0
                                                          ? "Invite"
                                                          : "Invited",
                                                      15,
                                                      white),
                                                ),
                                              ),
                                              customWidthBox(10),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: customText("No users!", 15, white),
                              );
                      }),
                ));
          });
        });
  }

  //Send invitation to user
  Future<void> sendInvitation(
      String gId, String inviteUserId, StateSetter state) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    Map data = {"receiver_id": inviteUserId, "group_id": gId};
    print(token);
    var jsonResponse = null;
    var response = await http.post(Uri.parse(BASE_URL + "send_invite"),
        headers: {
          'api-key': API_KEY,
          'x-access-token': token,
        },
        body: data);
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      getUsersForEventGroups();
      state(() {});
      print("Send group invitation api success");
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

  selectedFilterView(int index, String userId, int privacy) {
    if (index == 0) {
      return FutureBuilder<GroupPostModel>(
          future: getGroupPostList(context, widget.groupId),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? DisscussionPage(snapshot.data!)
                : Container(
                    margin: EdgeInsets.only(top: 100),
                    alignment: Alignment.center,
                    child: Center(
                      child: customText("No data!", 15, white),
                    ),
                  );
          });
    } else if (index == 1) {
      return FutureBuilder<GroupMediaModel>(
          future: getGroupMediaFiles(context, widget.groupId, "image"),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? GroupsImageVideo(snapshot.data!)
                : Container(
                    margin: EdgeInsets.only(top: 100),
                    alignment: Alignment.center,
                    child: Center(
                      child: customText("No data!", 15, white),
                    ),
                  );
          });
    } else if (index == 2) {
      return FutureBuilder<GroupMediaModel>(
          future: getGroupMediaFiles(context, widget.groupId, "video"),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? GroupsImageVideo(snapshot.data!)
                : Container(
                    margin: EdgeInsets.only(top: 100),
                    alignment: Alignment.center,
                    child: Center(
                      child: customText("No data!", 15, white),
                    ),
                  );
          });
    } else if (index == 3) {
      return GroupDisscussionContactsPage(
        groupId: widget.groupId.toString(),
        userId: userId,
        privacy: privacy,
      );
    }
  }

  ///Disscussion Page
  DisscussionPage(GroupPostModel snapshot) {
    return Container(
      child: Column(
        crossAxisAlignment: cStart,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: customText("Sngine News", 14, yellowColor),
          ),
          customHeightBox(10),
          //Comment Section
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => ShareThoughts(
                            evenGroupId: widget.groupId,
                            type: "group",
                          )))
                  .then((value) => () {});
            },
            child: Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: black),
                child: Center(
                  child: customText(
                      "What's in your mind? #Hashtag #Tags", 14, gray1),
                )),
          ),
          customHeightBox(20),
          //Comments
          Container(
              height: phoneHeight(context) / 2,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    String? totalLikes =
                        snapshot.data![index].totalLikes.toString();

                    String? totalComments =
                        snapshot.data![index].totalComments.toString();
                    return Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: black),
                      margin: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 10,
                          bottom: index == snapshot.data!.length - 1 ? 120 : 0),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10, top: 10, bottom: 10),
                        child: Column(
                          children: [
                            customWidthBox(10),
                            Column(
                              crossAxisAlignment: cStart,
                              children: [
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: IMAGE_URL +
                                          snapshot
                                              .data![index].user!.profileImage
                                              .toString(),
                                      placeholder: (context, url) => const Icon(
                                        Icons.person,
                                        size: 50,
                                      ),
                                      imageBuilder: (context, image) {
                                        return CircleAvatar(
                                            backgroundImage: image);
                                      },
                                    ),
                                    customWidthBox(10),
                                    customText(
                                        snapshot.data![index].user!.fullName
                                            .toString(),
                                        15,
                                        white),
                                  ],
                                ),
                                customHeightBox(5),
                                Container(
                                  margin: EdgeInsets.only(left: 50),
                                  child:
                                      snapshot.data![index].caption!.isNotEmpty
                                          ? customText(
                                              snapshot.data![index].caption
                                                  .toString(),
                                              12,
                                              white)
                                          : null,
                                ),

                                mediaWidget(snapshot.data![index]),
                                customHeightBox(20),
                                //Likes and Comment
                                Row(
                                  crossAxisAlignment: cCenter,
                                  mainAxisAlignment: mCenter,
                                  children: [
                                    //like
                                    InkWell(
                                      onTap: () {
                                        likeDislike(
                                            context,
                                            snapshot.data![index].sId
                                                .toString(),
                                            snapshot.data![index].isLike!);
                                      },
                                      child: Row(
                                        mainAxisAlignment: mCenter,
                                        crossAxisAlignment: cCenter,
                                        children: [
                                          Image.asset(
                                            "assets/icons/like.png",
                                            height: 17,
                                            width: 17,
                                            color:
                                                snapshot.data![index].isLike ==
                                                        1
                                                    ? Colors.blue
                                                    : null,
                                          ),
                                          customWidthBox(5),
                                          customText(
                                              totalLikes + " Likes", 15, white)
                                        ],
                                      ),
                                    ),
                                    customWidthBox(80),
                                    //Comment

                                    InkWell(
                                      onTap: () async {
                                        await Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GroupPostCommentListPage(
                                                        groupId: widget.groupId
                                                            .toString(),
                                                        postID: snapshot
                                                            .data![index].sId
                                                            .toString())));

                                        debugPrint("From Post");
                                        setState(() {});
                                      },
                                      child: Row(
                                        crossAxisAlignment: cCenter,
                                        children: [
                                          Image.asset(
                                            "assets/icons/comment.png",
                                            height: 17,
                                            width: 17,
                                          ),
                                          customWidthBox(5),
                                          customText(
                                              totalComments + " Comments",
                                              15,
                                              white)
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }))
        ],
      ),
    );
  }

  //Like dislike the post
  Future<void> likeDislike(
      BuildContext context, String eventPostId, int isLike) async {
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    print(token);
    var jsonResponse = null;
    Map data = {
      "type": isLike == 0 ? "Like" : "Dislike",
      "group_id": widget.groupId.toString(),
      "group_post_id": eventPostId
    };
    var response = await http.post(Uri.parse(BASE_URL + "like_group_post"),
        headers: {
          'api-key': API_KEY,
          'x-access-token': token,
        },
        body: data);

    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      setState(() {});
      print("Post like/dislike api success");
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      customToastMsg(message);
      throw Exception("Failed to load the work experience!");
    }
  }

  //Media Widget for comment
  mediaWidget(GroupPostDataModel data) {
    return Container(
        child: data.media!.isNotEmpty
            ? Container(
                padding: EdgeInsets.all(5),
                child: CarouselSlider.builder(
                  itemCount: data.media!.length,
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      data.media![itemIndex].type == "image"
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VideoImageViewPage(
                                                url: IMAGE_URL +
                                                    data.media![itemIndex].path
                                                        .toString(),
                                                type: 1)));
                              },
                              child: Container(
                                height: 150,
                                child: CachedNetworkImage(
                                  imageUrl: IMAGE_URL +
                                      data.media![itemIndex].path.toString(),
                                  placeholder: (context, url) => const Icon(
                                    Icons.person,
                                    size: 50,
                                  ),
                                  imageBuilder: (context, image) {
                                    return Container(
                                        decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: image,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ));
                                  },
                                ),
                              ),
                            )
                          : InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VideoImageViewPage(
                                                url: data.media![itemIndex].path
                                                    .toString(),
                                                type: 0)));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: white24),
                                child: Center(
                                    child: Icon(
                                  Icons.play_circle,
                                  color: white,
                                  size: 70,
                                )),
                              ),
                            ),
                  options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.9,
                    aspectRatio: 2.0,
                    initialPage: 2,
                  ),
                ),
              )
            : null);
  }

  //Only Group photos page/video
  GroupsImageVideo(GroupMediaModel snapshot) {
    return Container(
      height: phoneHeight(context) / 2.5,
      width: phoneWidth(context),
      child: GridView.count(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          crossAxisCount: 3,
          children: List.generate(snapshot.data!.length, (index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoImageViewPage(
                            url: IMAGE_URL +
                                snapshot.data![index].path.toString(),
                            type: 1)));
              },
              child: Container(
                margin: EdgeInsets.all(10),
                height: 200,
                decoration: BoxDecoration(
                    color: white, borderRadius: BorderRadius.circular(10)),
                width: 70,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                      IMAGE_URL + snapshot.data![index].path.toString(),
                      fit: BoxFit.cover, loadingBuilder: (BuildContext context,
                          Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  }),
                ),
              ),
            );
          })),
    );
  }
}
