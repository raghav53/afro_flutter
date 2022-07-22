import 'dart:convert';

import 'package:afro/Model/MyProfile/FollowingModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
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

class FollowingTab extends StatefulWidget {
  const FollowingTab({Key? key}) : super(key: key);
  @override
  State<FollowingTab> createState() => _FollowingTabState();
}

UserDataConstants _userDataConstants = UserDataConstants();
Future<FollowingModel>? _getFollowingUsers;
Future<SharedPreferences> _pref = SharedPreferences.getInstance();

class _FollowingTabState extends State<FollowingTab> {
  @override
  void initState() {
    super.initState();
    print("Init State");
    Future.delayed(Duration.zero, () {
      _getFollowingUsers = getAllFollowingUsers(context);
      setState(() {});
      _getFollowingUsers!.whenComplete(() => () {});
    });
  }

  //Update the user data list
  updateUSerData() {
    setState(() {
      Future.delayed(Duration.zero, () {
        _getFollowingUsers = getAllFollowingUsers(context);
        setState(() {});
        _getFollowingUsers!.whenComplete(() => () {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FollowingModel>(
        future: _getFollowingUsers,
        builder: (context, snaapshot) {
          return snaapshot.hasData && snaapshot.data!.data!.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(left: 25, right: 25),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0XFF121220)),
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: snaapshot.data!.data!.length,
                    itemBuilder: (context, index) {
                      String? userFullName = snaapshot
                          .data!.data![index].user!.fullName
                          .toString();

                      String? userId =
                          snaapshot.data!.data![index].user!.sId!.toString();

                      String? userImage = IMAGE_URL +
                          snaapshot.data!.data![index].user!.profileImage
                              .toString();

                      String? cName = snaapshot
                          .data!.data![index].user!.country![0].title
                          .toString();
                      return InkWell(
                        onTap: () {
                          print(userId);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OtherUserProfilePageScreen(
                                        name: userFullName,
                                        userID: userId.toString(),
                                      )));
                        },
                        child: Container(
                          margin: EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Color(0xFF191831),
                          ),
                          child: Container(
                            width: phoneWidth(context),
                            margin: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                CachedNetworkImage(
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.person,
                                    size: 40,
                                  ),
                                  placeholder: (context, image) =>
                                      Icon(Icons.person),
                                  imageBuilder: (context, image) =>
                                      CircleAvatar(
                                    backgroundImage: image,
                                  ),
                                  imageUrl: IMAGE_URL +
                                      snaapshot
                                          .data!.data![index].user!.profileImage
                                          .toString(),
                                ),
                                customWidthBox(10),
                                Column(
                                  crossAxisAlignment: cStart,
                                  children: [
                                    customText(userFullName, 13, Colors.white),
                                    customHeightBox(5),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          color: yellowColor,
                                          size: 12,
                                        ),
                                        customWidthBox(5),
                                        customText(cName, 12, white)
                                      ],
                                    ),
                                    customHeightBox(5),
                                    customText("Share 2 Mutual friend", 12,
                                        Color(0x3dFFFFFF)),
                                  ],
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    unfollow(snaapshot
                                        .data!.data![index].user!.sId
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
                                        child: customText(
                                            "UnFollow", 12, Colors.white)),
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
                  child: customText("No data found", 15, white),
                );
        });
  }

  Future<void> unfollow(String userId) async {
    showProgressDialogBox(context);
    SharedPreferences userData = await _pref;
    String? token = userData.getString(_userDataConstants.token).toString();

    Map data = {"user_id": userId, "type": "0"};
    var response = await http.post(Uri.parse(BASE_URL + "follow"),
        headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      await updateUSerData();
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
