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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AllMembers extends StatefulWidget {
  const AllMembers({Key? key}) : super(key: key);

  @override
  State<AllMembers> createState() => _AllMembersState();
}

String searchFriend = "";
var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class _AllMembersState extends State<AllMembers> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: commonAppbar("Contacts"),
        body: Container(
          padding: EdgeInsets.only(top: 80),
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 17, right: 17),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(0, 2))
                    ]),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchFriend = value.toString();
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
              ),
              customHeightBox(25),
              FutureBuilder<UsersFriendsModel>(
                  future: getAllFriends(context, search: searchFriend),
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data != null
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.data!.length,
                            itemBuilder: (context, index) {
                              return contactTileView(snapshot.data!, index);
                            })
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  })
            ],
          ),
        ),
      ),
    );
  }

  contactTileView(UsersFriendsModel snapshot, int index) {
    return ListTile(
      leading: CachedNetworkImage(
          height: 55,
          width: 55,
          imageUrl:
              IMAGE_URL + snapshot.data![index].friend!.profileImage.toString(),
          errorWidget: (error, context, url) => const Icon(Icons.person),
          placeholder: (context, url) => const Icon(Icons.person),
          imageBuilder: (context, url) {
            return CircleAvatar(
              backgroundImage: url,
            );
          }),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customText(
              snapshot.data![index].friend!.fullName.toString(), 15, white),
          Row(
            children: [
              Icon(
                Icons.location_pin,
                size: 15,
                color: yellowColor,
              ),
              customText(
                  snapshot.data![index].friend!.country![0].title.toString(),
                  13,
                  Colors.white54)
            ],
          )
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: customText("Share 2 mutaul friends", 14, white24),
      ),
      trailing: InkWell(
        onTap: () {
          showTheUnFriendAlertBox(
              snapshot.data![index].friend!.fullName.toString(),
              snapshot.data![index].friend!.sId.toString());
        },
        child: Container(
          width: 80,
          height: 35,
          margin: const EdgeInsets.only(right: 20),
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: commonButtonLinearGridient),
          child: Center(child: customText("Unfriend", 13, white)),
        ),
      ),
    );
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
      setState(() {});
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

  //Show the unfriend alertbox
  showTheUnFriendAlertBox(String name, String friendId) {
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
}
