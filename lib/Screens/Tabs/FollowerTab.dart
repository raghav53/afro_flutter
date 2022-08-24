import 'dart:convert';
import 'package:afro/Model/MyProfile/FollowerModel.dart';
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
import 'package:http/http.dart' as http;

import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowerTab extends StatefulWidget {
  const FollowerTab({Key? key}) : super(key: key);

  @override
  State<FollowerTab> createState() => _FollowerTabState();
}

UserDataConstants _userDataConstants = UserDataConstants();
Future<FollowerModel>? _getFollowerUsers;
Future<SharedPreferences> _pref = SharedPreferences.getInstance();

class _FollowerTabState extends State<FollowerTab> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getFollowerUsers = getAllFollowerUsers(context);
      setState(() {});
      _getFollowerUsers!.whenComplete(() => () {});
    });
  }

  //Update the user data list
  updateUsersData() {
    setState(() {
      Future.delayed(Duration.zero, () {
        _getFollowerUsers = getAllFollowerUsers(context);
        setState(() {});
        _getFollowerUsers!.whenComplete(() => () {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customHeightBox(10),
                Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(color: Colors.black, offset: Offset(0, 2))
                      ]),
                  height: 50,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        //search = value.toString();
                      });
                    },
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFFDFB48C),
                        ),
                        border: InputBorder.none,
                        hintText: "Search",
                        contentPadding: EdgeInsets.only(left: 15, top: 15),
                        hintStyle: TextStyle(color: Colors.white24)),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<FollowerModel>(
              future: _getFollowerUsers,
              builder: (context, snaapshot) {
                return snaapshot.hasData
                    ? Container(
                        margin: const EdgeInsets.only(left: 25, right: 25),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: snaapshot.data!.data!.length,
                          itemBuilder: (context, index) {
                            String? userFullName = snaapshot
                                .data!.data![index].follower?.fullName
                                .toString();

                            String? userImage = snaapshot
                                .data!.data![index].follower?.profileImage
                                .toString();

                            String? cName = snaapshot
                                .data!.data![index].follower!.country?[0].title
                                .toString();
                            bool _isVisible =
                                snaapshot.data!.data![index].isFollowing == 1
                                    ? false
                                    : true;

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OtherUserProfilePageScreen(
                                              name: userFullName,
                                              userID: snaapshot.data!
                                                  .data![index].follower!.sId
                                                  .toString(),
                                            )));
                              },
                              child: Container(
                                margin: EdgeInsets.all(7),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Color(0xFF191831),
                                ),
                                child: Container(
                                  width: phoneWidth(context),
                                  margin: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      CachedNetworkImage(
                                        placeholder: (context, image) =>
                                            Icon(Icons.person),
                                        imageBuilder: (context, image) =>
                                            CircleAvatar(
                                          backgroundImage: image,
                                        ),
                                        imageUrl:
                                            IMAGE_URL + userImage.toString(),
                                      ),
                                      customWidthBox(10),
                                      Column(
                                        crossAxisAlignment: cStart,
                                        children: [
                                          customText(
                                              userFullName!, 13, Colors.white),
                                          customHeightBox(5),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_pin,
                                                color: yellowColor,
                                                size: 12,
                                              ),
                                              customWidthBox(5),
                                              customText(cName!, 12, white)
                                            ],
                                          ),
                                          customHeightBox(5),
                                          customText("Share 2 Mutual friend",
                                              12, Color(0x3dFFFFFF)),
                                        ],
                                      ),
                                      Spacer(),
                                      Visibility(
                                        visible: _isVisible,
                                        child: InkWell(
                                          onTap: () {
                                            unfollow(snaapshot
                                                .data!.data![index].followerId!
                                                .toString());
                                          },
                                          child: Container(
                                            decoration: fixedButtonDesign(),
                                            child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 20,
                                                    right: 20,
                                                    bottom: 10),
                                                child: customText("Follow  ",
                                                    12, Colors.white)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: customText("Not data found", 15, white),
                      );
              }),
        ],
      ),
    );
  }

  Future<void> unfollow(String userId) async {
    showProgressDialogBox(context);
    SharedPreferences userData = await _pref;
    String? token = userData.getString(_userDataConstants.token).toString();

    Map data = {"user_id": userId, "type": "1"};
    var response = await http.post(Uri.parse(BASE_URL + "follow"),
        headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      updateUsersData();
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }
}
