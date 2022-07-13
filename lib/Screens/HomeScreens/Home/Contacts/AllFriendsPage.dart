import 'dart:convert';

import 'package:afro/Model/Friends/AllFriends/AllFriendsModel.dart';
import 'package:afro/Network/Apis.dart';
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

class AllFriendsPage extends StatefulWidget {
  const AllFriendsPage({Key? key}) : super(key: key);

  @override
  State<AllFriendsPage> createState() => _AllFriendsPageState();
}

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<FriendsModel>? _getAllFriends;
String searchUser = "";

class _AllFriendsPageState extends State<AllFriendsPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getAllFriends = getAllFriends(context);
      setState(() {});
      _getAllFriends!.whenComplete(() => () {});
    });
  }

  updateFriendsList() {
    Future.delayed(Duration.zero, () {
      _getAllFriends = getAllFriends(context);
      setState(() {});
      _getAllFriends!.whenComplete(() => () {});
    });
  }

  //Country
  Future<FriendsModel> getSearchFriends(String search) async {
    FriendsModel mm = await _getAllFriends!;
    var ss = mm.toJson();
    FriendsModel model = FriendsModel.fromJson(ss);

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
    return FutureBuilder<FriendsModel>(
        future: getSearchFriends(searchUser),
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.data!.isNotEmpty
              ? Column(
                  children: [
                    //Search Option
                    customHeightBox(20),
                    Row(mainAxisAlignment: mCenter, children: [
                      Flexible(
                          flex: 12,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black, offset: Offset(0, 2))
                                ]),
                            child: TextField(
                              onChanged: (value) => {
                                setState(() {
                                  searchUser = value.toString();
                                })
                              },
                              keyboardType: TextInputType.text,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xFFDFB48C),
                                  ),
                                  hintText: "Search",
                                  contentPadding:
                                      EdgeInsets.only(left: 15, top: 15),
                                  hintStyle: TextStyle(color: Colors.white24)),
                            ),
                          )),
                      customWidthBox(20),
                    ]),
                    customHeightBox(20),
                    RefreshIndicator(
                      onRefresh: refreshList,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.data!.length,
                          itemBuilder: (context, index) {
                            return Column(
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
                                                          .friend!.city!.isEmpty
                                                      ? "Not available"
                                                      : snapshot
                                                          .data!
                                                          .data![index]
                                                          .friend!
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
                                              "assets/icons/friends.png",
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
                            );
                          }),
                    ),
                  ],
                )
              : Center(
                  child: customText("Not data found!", 15, white),
                );
        });
  }

  Future<void> refreshList() async {
    updateFriendsList();
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
      updateFriendsList();
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
