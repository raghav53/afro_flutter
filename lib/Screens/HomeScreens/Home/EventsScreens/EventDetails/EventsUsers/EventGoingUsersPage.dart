import 'dart:convert';
import 'package:afro/Model/Events/InterestedGoingUser/GoingInterstedUserModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
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

import 'package:http/http.dart' as http;

class EventGoingUsersPage extends StatefulWidget {
  String eventId = "";
  EventGoingUsersPage({Key? key, required this.eventId}) : super(key: key);
  @override
  State<EventGoingUsersPage> createState() => _EventGoingUsersPageState();
}

Future<GoingInterstedUserModel>? _getUsers;

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
var userData = UserDataConstants();

class _EventGoingUsersPageState extends State<EventGoingUsersPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _getUsers = getGoingEventUsers("0", context, widget.eventId.toString());

      setState(() {});
      _getUsers!.whenComplete(() => () {});
    });
  }

  refreshData() {
    Future.delayed(Duration.zero, () {
      _getUsers = getGoingEventUsers("0", context, widget.eventId.toString());
      setState(() {});
      _getUsers!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: black),
        child: FutureBuilder<GoingInterstedUserModel>(
          future: _getUsers,
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? GridView.count(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.only(top: 20),
                    crossAxisCount: 3,
                    childAspectRatio: 0.5,
                    children:
                        List.generate(snapshot.data!.data!.length, (index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OtherUserProfilePageScreen(
                                    userID: snapshot
                                        .data!.data![index].user!.sId
                                        .toString(),
                                    name: snapshot
                                        .data!.data![index].user!.fullName
                                        .toString(),
                                  )));
                        },
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: gray1,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: const Color(0xFF191831),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  margin: const EdgeInsets.only(top: 30),
                                  child: Column(
                                    children: [
                                      customText(
                                          snapshot
                                              .data!.data![index].user!.fullName
                                              .toString(),
                                          10,
                                          yellowColor),
                                      customHeightBox(7),
                                      InkWell(
                                        onTap: () {
                                          if (snapshot.data!.data![index].user!
                                                  .isReqSent !=
                                              1) {
                                            FriendRequest(
                                                context,
                                                0,
                                                snapshot.data!.data![index]
                                                    .user!.sId
                                                    .toString());
                                            return;
                                          } else {
                                            FriendRequest(
                                                context,
                                                1,
                                                snapshot.data!.data![index]
                                                    .user!.sId
                                                    .toString());
                                          }
                                          if (snapshot.data!.data![index].user!
                                                  .isReqReceived ==
                                              1) {
                                            showAlertDialog();
                                            return;
                                          }
                                          print("Add Friend");
                                        },
                                        child: snapshot.data!.data![index].user!
                                                    .isFriend ==
                                                0
                                            ? Container(
                                          margin: const EdgeInsets.only(left: 5,right: 5),
                                              alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  gradient:
                                                      commonButtonLinearGridient,
                                                ),
                                                child:Flexible(
                                                  child: customText(
                                                      snapshot
                                                          .data!
                                                          .data![index]
                                                          .user!
                                                          .isReqSent ==
                                                          1
                                                          ? "Cancel Request"
                                                          : snapshot
                                                          .data!
                                                          .data![index]
                                                          .user!
                                                          .isReqReceived ==
                                                          1
                                                          ? "Request Received"
                                                          : "Add Friend",
                                                      7.5,
                                                      white),
                                                ))
                                            : Container(),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                              DottedBorder(
                                radius: const Radius.circular(2),
                                padding: const EdgeInsets.all(5),
                                borderType: BorderType.Circle,
                                color: const Color(0xFF3E55AF),
                                child: Container(
                                  padding: EdgeInsets.all(1),
                                  child: CachedNetworkImage(
                                      imageUrl: IMAGE_URL +
                                          snapshot.data!.data![index].user!
                                              .profileImage
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
                                ),
                              ),
                                Container(
                                height: 9,
                                width: 9,
                                margin: const EdgeInsets.only(right: 3, bottom: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: commonButtonLinearGridient),
                              ),
                          ]),

                          ],
                        ),
                      );
                    }))
                : Center(child: customText("No users available!", 12, white));
          },
        ));
  }

  //Send and Cancel Friend request
  Future<void> FriendRequest(
      BuildContext context, int type, String friendId) async {
    print(friendId);
    print(type);
    showProgressDialogBox(context);
    SharedPreferences userData = await _prefs;
    String? token = userData.getString(user.token).toString();
    print(token);
    Map data = {"friend_id": friendId};
    var response = type == 1
        ? await http.delete(Uri.parse(BASE_URL + "friend_request/$friendId"),
            headers: {'api-key': API_KEY, 'x-access-token': token})
        : await http.post(Uri.parse(BASE_URL + "send_friend_request"),
            headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      refreshData();
      type == 1
          ? print("Friend request successfully deleted....")
          : print("Friend request send successfully...");
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

  showAlertDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                  padding: EdgeInsets.zero,
                  height: 120,
                  width: 200,
                  decoration: BoxDecoration(
                      color: gray1, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                      crossAxisAlignment: cCenter,
                      mainAxisAlignment: mCenter,
                      children: [])));
        });
  }
}
