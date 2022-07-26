import 'dart:convert';

import 'package:afro/Model/Friends/SendRequest/GetAllSendRequests.dart';
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

class SendFriendsRequest extends StatefulWidget {
  const SendFriendsRequest({Key? key}) : super(key: key);
  @override
  State<SendFriendsRequest> createState() => _SendFriendsRequestState();
}

Future<SendRequestModel>? _getAllSendRequestsList;
var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
String searchUser = "";

class _SendFriendsRequestState extends State<SendFriendsRequest> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getAllSendRequestsList = getAllSendRequests(context);
      setState(() {});
      _getAllSendRequestsList!.whenComplete(() => () {});
    });
  }

  //Search Friend request list

  Future<SendRequestModel> _getSearchRequestList(String search) async {
    SendRequestModel mm = await _getAllSendRequestsList!;
    var ss = mm.toJson();
    SendRequestModel model = SendRequestModel.fromJson(ss);

    if (search.isEmpty) {
      return model;
    }

    int i = 0;
    while (i < model.data!.length) {
      if (!model.data![i].friend!.fullName
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
    return FutureBuilder<SendRequestModel>(
        future: _getSearchRequestList(searchUser),
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.data!.isNotEmpty
              ? Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: RefreshIndicator(
                    onRefresh: refreshList,
                    child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.data!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OtherUserProfilePageScreen(
                                            name: snapshot.data!.data![index]
                                                .friend!.fullName,
                                            userID: snapshot
                                                .data!.data![index].friend!.sId,
                                          ))).then((value) =>
                                  updateGetListOfSendFriendsRequest());
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
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
                                              child: CachedNetworkImage(
                                                  imageUrl: IMAGE_URL +
                                                      snapshot
                                                          .data!
                                                          .data![index]
                                                          .friend!
                                                          .profileImage
                                                          .toString(),
                                                  errorWidget:
                                                      (error, context, url) =>
                                                          Icon(Icons.person),
                                                  placeholder: (context, url) =>
                                                      Icon(Icons.person),
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
                                              snapshot.data!.data![index]
                                                  .friend!.fullName
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
                                                      .friend!.city![0].name
                                                      .toString(),
                                                  9.5,
                                                  white)
                                            ],
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          showTheAlertBox(
                                              context,
                                              snapshot.data!.data![index]
                                                  .friend!.fullName
                                                  .toString(),
                                              snapshot.data!.data![index]
                                                  .friend!.sId
                                                  .toString());
                                        },
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                                right: 8.0),
                                            child: Image.asset(
                                              "assets/icons/request_send.png",
                                              height: 25,
                                              width: 25,
                                              color: circleColor,
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                                customDivider(10, white)
                              ],
                            ),
                          );
                        }),
                  ),
                )
              : Center(
                  child: customText("Not data found!", 15, white),
                );
        });
  }

  showTheAlertBox(BuildContext context, String name, String friendId) {
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

  Future<void> refreshList() async {
    updateGetListOfSendFriendsRequest();
  }

  updateGetListOfSendFriendsRequest() {
    Future.delayed(Duration.zero, () {
      _getAllSendRequestsList = getAllSendRequests(context);
      setState(() {});
      _getAllSendRequestsList!.whenComplete(() => () {});
    });
  }

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
      updateGetListOfSendFriendsRequest();
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
