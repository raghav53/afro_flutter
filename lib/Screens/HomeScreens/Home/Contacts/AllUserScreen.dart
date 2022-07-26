import 'dart:convert';

import 'package:afro/Model/Friends/AllUsers/GetAllUsers.dart';

import 'package:afro/Network/Apis.dart';
import 'package:afro/Model/Friends/AllUsers/AllUsersDataModel.dart'
    as AllFriendsDataModel;
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../Util/CustomWidget.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({Key? key}) : super(key: key);
  @override
  State<AllUsersPage> createState() => _AllUsersPageState();
}

Future<GetAllFriendsModel>? _getAllUsersList;
var user = UserDataConstants();
String searchUser = "";
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class _AllUsersPageState extends State<AllUsersPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getAllUsersList = getAllUsers(context);
      setState(() {});
      _getAllUsersList!.whenComplete(() => () {});
    });
  }

  //Search users list
  Future<GetAllFriendsModel> _getSearchCountriesList(String search) async {
    GetAllFriendsModel mm = await _getAllUsersList!;
    var ss = mm.toJson();
    GetAllFriendsModel model = GetAllFriendsModel.fromJson(ss);

    if (search.isEmpty) {
      return model;
    }

    int i = 0;
    while (i < model.data!.length) {
      if (!model.data![i].fullName
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase())) {
        model.data!.removeAt(i);
      } else {
        i++;
      }
    }
    return model;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GetAllFriendsModel>(
        future: _getAllUsersList,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.data!.isNotEmpty
              ? Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: phoneHeight(context) * 0.68,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data!.data!.length,
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OtherUserProfilePageScreen(
                                              name: snapshot
                                                  .data!.data![index].fullName,
                                              userID: snapshot
                                                  .data!.data![index].sId,
                                            )))
                                .then((value) => getListOfDiscoverFriends());
                          },
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        DottedBorder(
                                          radius: const Radius.circular(2),
                                          padding: const EdgeInsets.all(5),
                                          borderType: BorderType.Circle,
                                          color: const Color(0xFF3E55AF),
                                          child: Container(
                                            padding: const EdgeInsets.all(1),
                                            child: snapshot.data!.data![index]
                                                    .profileImage!.isNotEmpty
                                                ? CachedNetworkImage(
                                                    imageUrl: IMAGE_URL +
                                                        snapshot
                                                            .data!
                                                            .data![index]
                                                            .profileImage
                                                            .toString(),
                                                    errorWidget:
                                                        (error, context, url) =>
                                                            const Icon(
                                                                Icons.person),
                                                    placeholder:
                                                        (context, url) =>
                                                            const Icon(
                                                                Icons.person),
                                                    imageBuilder:
                                                        (context, url) {
                                                      return CircleAvatar(
                                                        backgroundImage: url,
                                                      );
                                                    })
                                                : const CircleAvatar(
                                                    child: Icon(Icons.person)),
                                          ),
                                        ),
                                        Container(
                                          height: 9,
                                          width: 9,
                                          margin: const EdgeInsets.only(
                                              right: 3, bottom: 3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient:
                                                  commonButtonLinearGridient),
                                        )
                                      ],
                                    ),
                                    customWidthBox(10),
                                    Column(
                                      crossAxisAlignment: cStart,
                                      children: [
                                        customText(
                                            snapshot.data!.data![index].fullName
                                                .toString(),
                                            15,
                                            white),
                                        customHeightBox(5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_pin,
                                              color: yellowColor,
                                              size: 15,
                                            ),
                                            customText(
                                                snapshot.data!.data![index]
                                                        .city!.isEmpty
                                                    ? "Not available!"
                                                    : snapshot
                                                        .data!
                                                        .data![index]
                                                        .city![0]
                                                        .title
                                                        .toString(),
                                                9.5,
                                                white)
                                          ],
                                        )
                                      ],
                                    ),
                                    const Spacer(),
                                    //Check user
                                    checkStatus(
                                        context, snapshot.data!.data![index])!
                                  ],
                                ),
                              ),
                              customDivider(10, white)
                            ],
                          ),
                        );
                      }),
                )
              : Center(
                  child: customText("Not data found....", 15, white),
                );
        });
  }

  Future<void> _refreshUsersList() async {
    getListOfDiscoverFriends();
  }

  Widget? checkStatus(
      BuildContext context, AllFriendsDataModel.AllUserDataModel user) {
    return user.isFriend == 0 && user.isReqReceived == 0 && user.isReqSent == 0
        ? InkWell(
            onTap: () {
              FriendRequest(context, 0, user.sId.toString());
              getListOfDiscoverFriends();
            },
            child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  "assets/icons/add_user.png",
                  height: 25,
                  width: 25,
                  color: circleColor,
                )),
          )
        : user.isReqSent == 1
            ? InkWell(
                onTap: () {
                  showCancelTheAlertBox(
                      context, user.fullName.toString(), user.sId.toString());
                },
                child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.asset(
                      "assets/icons/request_send.png",
                      height: 25,
                      width: 25,
                      color: circleColor,
                    )),
              )
            : user.isFriend == 1
                ? InkWell(
                    onTap: () {
                      showUnFriendTheAlertBox(context, user.fullName.toString(),
                          user.sId.toString());
                    },
                    child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Image.asset(
                          "assets/icons/friends.png",
                          height: 25,
                          width: 25,
                          color: circleColor,
                        )),
                  )
                : user.isReqReceived == 1
                    ? Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Image.asset(
                              "assets/icons/check_right_icon.png",
                              height: 18,
                              width: 18,
                              color: white,
                            ),
                          ),
                          customWidthBox(10),
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.close,
                              size: 25,
                              color: Colors.red,
                            ),
                          )
                        ],
                      )
                    : null;
  }

  getListOfDiscoverFriends() {
    Future.delayed(Duration.zero, () {
      _getAllUsersList = getAllUsers(context);
      setState(() {});
      _getAllUsersList!.whenComplete(() => () {});
    });
  }

  //Send Friend request
  Future<void> FriendRequest(
      BuildContext context, int type, String friendId) async {
    print(friendId);
    print(type);
    showProgressDialogBox(context);
    SharedPreferences userData = await _prefs;
    String? token = userData.getString(user.token).toString();
    print(token);
    Map data = {"friend_id": friendId};
    var response = await http.post(Uri.parse(BASE_URL + "send_friend_request"),
        headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      print("Friend request send successfully...");
      getListOfDiscoverFriends();
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      print(message);
      customToastMsg(message);
    }
  }

  //Cancel the friend request
  showCancelTheAlertBox(BuildContext context, String name, String friendId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                padding: EdgeInsets.all(20),
                height: 170,
                decoration: BoxDecoration(
                    color: gray1, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    customText("Cancel friend request!", 15, white),
                    customHeightBox(15),
                    const Text(
                      "Are you sure want to cancel friend request?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0x3DFFFFFF),
                          fontWeight: FontWeight.bold),
                    ),
                    customHeightBox(30),
                    Row(mainAxisAlignment: mCenter, children: [
                      InkWell(
                        onTap: () {
                          cancelFriendRequest(context, friendId);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: commonButtonLinearGridient),
                          child: Center(
                            child: customText("Remove", 15, white),
                          ),
                        ),
                      ),
                      customWidthBox(10),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: white, width: 1)),
                          child: Center(
                            child: customText("Cancel", 15, white),
                          ),
                        ),
                      )
                    ])
                  ],
                ),
              ));
        });
  }

  //Alert dialog box of the cancel friend request
  Future<void> cancelFriendRequest(
      BuildContext context, String friendId) async {
    print(friendId);

    showProgressDialogBox(context);
    SharedPreferences userData = await _prefs;
    String? token = userData.getString(user.token).toString();
    print(token);

    var response = await http.delete(
        Uri.parse(BASE_URL + "friend_request/$friendId"),
        headers: {'api-key': API_KEY, 'x-access-token': token});
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      print("Cancel friend request successfully......");
      Navigator.pop(context);
      Navigator.pop(context);
      getListOfDiscoverFriends();
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      print(message);
      customToastMsg(message);
    }
  }

  //show the alertbox of Unfriend the user
  showUnFriendTheAlertBox(BuildContext context, String name, String friendId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                padding: EdgeInsets.all(20),
                height: 170,
                decoration: BoxDecoration(
                    color: gray1, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    customText("Remove " + name + " as a friend", 15, white),
                    customHeightBox(15),
                    Text(
                      "Are you sure want to remove " +
                          name +
                          " as your friend?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0x3DFFFFFF),
                          fontWeight: FontWeight.bold),
                    ),
                    customHeightBox(30),
                    Row(mainAxisAlignment: mCenter, children: [
                      InkWell(
                        onTap: () {
                          unfriendUser(context, friendId);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: commonButtonLinearGridient),
                          child: Center(
                            child: customText("Remove", 15, white),
                          ),
                        ),
                      ),
                      customWidthBox(10),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: white, width: 1)),
                          child: Center(
                            child: customText("Cancel", 15, white),
                          ),
                        ),
                      )
                    ])
                  ],
                ),
              ));
        });
  }

//Unfriend the user
  Future<void> unfriendUser(BuildContext context, String friendId) async {
    print(friendId);

    showProgressDialogBox(context);
    SharedPreferences userData = await _prefs;
    String? token = userData.getString(user.token).toString();
    print(token);
    Map data = {"friend_id": friendId};
    var response = await http.post(Uri.parse(BASE_URL + "unfriend"),
        headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      print("Unfriend successfully......");
      Navigator.pop(context);
      Navigator.pop(context);
      getListOfDiscoverFriends();
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      print(message);
      customToastMsg(message);
    }
  }
}
