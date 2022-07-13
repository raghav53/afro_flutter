import 'dart:convert';
import 'package:afro/Model/Group/AllUserForGroup/AllGroupUsersModel.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupContactsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupDiscussion.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupPhotosPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupVideoPage.dart';
import 'package:http/http.dart' as http;
import 'package:afro/Model/Group/GroupDetails/GroupDetailsModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupMembersList.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: BackButton(),
        actions: [
          //Show popmenu
          Container(
            child: widget.groupAdmin == userId.toString()
                ? GestureDetector(
                    onTapDown: (tapDownDetails) {
                      showUserPopupMenu(tapDownDetails);
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.more_vert_outlined),
                    ),
                  )
                : null,
          )
        ],
      ),
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
                          Container(
                            width: phoneHeight(context),
                            height: 250,
                            child: CachedNetworkImage(
                              imageUrl: IMAGE_URL +
                                  snapshot.data!.data!.coverImage.toString(),
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: phoneWidth(context),
                                height: 150.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.fill),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          ),
                          customHeightBox(10),
                          Container(
                            margin: EdgeInsets.only(left: 20, right: 20),
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
                                    RichText(
                                      text: TextSpan(
                                        text: "Created By: ",
                                        style: const TextStyle(
                                            color: Color(0x3DFFFFFF),
                                            fontSize: 11),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: snapshot
                                                  .data!.data!.userId!.fullName
                                                  .toString(),
                                              style: TextStyle(color: white)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                customHeightBox(15),
                                Row(
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
                                    customWidthBox(60),
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
                                    customWidthBox(60),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    GroupMemberListScreen(
                                                      group_id: snapshot
                                                          .data!.data!.sId
                                                          .toString(),
                                                    )));
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
        //Delete Button
        PopupMenuItem(
            padding: EdgeInsets.zero,
            child: InkWell(
              onTap: (() {
                Navigator.pop(context);
                showGroupDeleteDialogBox(widget.groupId.toString(), context);
              }),
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: black),
                child: Row(mainAxisAlignment: mCenter, children: [
                  Icon(
                    Icons.delete,
                    size: 15,
                    color: white,
                  ),
                  customWidthBox(10),
                  customText("Delete", 11, white)
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

  selectedFilterView(int index, String userId, int privacy) {
    if (index == 0) {
      return GroupDiscussionPage(
        groupId: widget.groupId.toString(),
      );
    } else if (index == 1) {
      return GroupDisscussionPhotosPage(
        groupdId: widget.groupId.toString(),
      );
    } else if (index == 2) {
      return GroupDisscussionVideosPage(
        groupId: widget.groupId.toString(),
      );
    } else if (index == 3) {
      return GroupDisscussionContactsPage(
        groupId: widget.groupId.toString(),
        userId: userId,
        privacy: privacy,
      );
    }
  }
}
