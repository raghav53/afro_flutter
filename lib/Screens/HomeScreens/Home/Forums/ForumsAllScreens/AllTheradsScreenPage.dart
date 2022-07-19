import 'dart:convert';

import 'package:afro/Model/Fourms/AllFourmDataModel.dart';
import 'package:afro/Model/Fourms/AllFourmModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/FourmDetailsPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AllThreadsPageScreen extends StatefulWidget {
  AllThreadsPageScreen({Key? key}) : super(key: key);
  @override
  State<AllThreadsPageScreen> createState() => _AllThreadsPageScreenState();
}

Future<AllFourmModel>? _exploreForums;
var userInfo = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
String? loginuserId = "";

class _AllThreadsPageScreenState extends State<AllThreadsPageScreen> {
  @override
  void initState() {
    super.initState();
    getUserDetails();
    Future.delayed(Duration.zero, () {
      _exploreForums = getAllFourmsList(context);

      setState(() {});
      _exploreForums!.whenComplete(() => () {});
    });
  }

  refreshData() {
    Future.delayed(Duration.zero, () {
      _exploreForums = getAllFourmsList(context);
      setState(() {});
      _exploreForums!.whenComplete(() => () {});
    });
  }

  //Get user details
  getUserDetails() async {
    SharedPreferences sharedPreferences = await _prefs;
    loginuserId = sharedPreferences.getString(user.id).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: FutureBuilder<AllFourmModel>(
          future: _exploreForums,
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: snapshot.data!.data!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FourmDetailsPage(
                                    fourmId: snapshot.data!.data![index].sId
                                        .toString(),
                                  )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: gray1, width: 1)),
                          padding: EdgeInsets.only(top: 5, bottom: 5),
                          margin: index == snapshot.data!.data!.length - 1
                              ? EdgeInsets.only(bottom: 150)
                              : EdgeInsets.only(bottom: 10),
                          child: Column(
                              mainAxisAlignment: mStart,
                              crossAxisAlignment: cStart,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Row(
                                    crossAxisAlignment: cStart,
                                    mainAxisAlignment: mStart,
                                    children: [
                                      CachedNetworkImage(
                                          imageUrl: IMAGE_URL +
                                              snapshot.data!.data![index]
                                                  .userId!.profileImage
                                                  .toString(),
                                          errorWidget: (error, context, url) =>
                                              Icon(Icons.person),
                                          placeholder: (context, url) =>
                                              Icon(Icons.person),
                                          imageBuilder: (context, url) {
                                            return CircleAvatar(
                                              backgroundImage: url,
                                            );
                                          }),
                                      customWidthBox(10),
                                      Column(
                                        crossAxisAlignment: cStart,
                                        mainAxisAlignment: mStart,
                                        children: [
                                          customText(
                                              snapshot.data!.data![index]
                                                  .userId!.fullName
                                                  .toString(),
                                              15,
                                              yellowColor),
                                          customHeightBox(10),
                                          RichText(
                                              text: TextSpan(
                                                  text: "Last post: ",
                                                  style: TextStyle(
                                                      color: white24,
                                                      fontSize: 15),
                                                  children: [
                                                TextSpan(
                                                    text: dataTimeTextFormater(
                                                                snapshot
                                                                    .data!
                                                                    .data![index]
                                                                    .createdAt
                                                                    .toString())[
                                                            "date"] +
                                                        " at " +
                                                        dataTimeTextFormater(
                                                                snapshot
                                                                    .data!
                                                                    .data![index]
                                                                    .createdAt
                                                                    .toString())[
                                                            "time"],
                                                    style: TextStyle(
                                                        color: yellowColor,
                                                        fontSize: 15))
                                              ]))
                                        ],
                                      ),
                                      Spacer(),
                                      InkWell(
                                        onTapDown: (tapDownDetails) {
                                          showPopupMenu(tapDownDetails,
                                              snapshot.data!.data![index]);
                                        },
                                        child: Icon(
                                          Icons.more_vert,
                                          color: white,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                customHeightBox(10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: customText(
                                      snapshot.data!.data![index].title
                                          .toString(),
                                      15,
                                      white),
                                ),
                                customHeightBox(10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: GestureDetector(
                                    child: Text(
                                        snapshot.data!.data![index].link
                                            .toString(),
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.blue)),
                                    onTap: () async {
                                      String url = snapshot
                                          .data!.data![index].title
                                          .toString();
                                      if (await canLaunch(url)) launch(url);
                                    },
                                  ),
                                ),
                                customHeightBox(10),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: customText(
                                      snapshot.data!.data![index].question
                                          .toString(),
                                      15,
                                      white),
                                ),
                                customHeightBox(10),
                                customDivider(1, white),
                                customHeightBox(2),
                                customDivider(1, white),
                                customHeightBox(5),
                                Row(
                                  mainAxisAlignment: mEvenly,
                                  children: [
                                    //Upvote
                                    InkWell(
                                      onTap: () {
                                        likeUnlike(
                                            snapshot.data!.data![index].sId
                                                .toString(),
                                            1);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.thumb_up_outlined,
                                            color: snapshot.data!.data![index]
                                                        .isLike ==
                                                    1
                                                ? Colors.blueAccent
                                                : white,
                                            size: 19,
                                          ),
                                          customWidthBox(3),
                                          customText(
                                              snapshot.data!.data![index]
                                                      .totalLikes
                                                      .toString() +
                                                  " Upvote",
                                              15,
                                              white)
                                        ],
                                      ),
                                    ),

                                    //Downvote
                                    InkWell(
                                      onTap: () {
                                        likeUnlike(
                                            snapshot.data!.data![index].sId
                                                .toString(),
                                            2);
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.thumb_down_outlined,
                                            color: snapshot.data!.data![index]
                                                        .isDislike ==
                                                    1
                                                ? Colors.blueAccent
                                                : white,
                                            size: 19,
                                          ),
                                          customWidthBox(3),
                                          customText(
                                              snapshot.data!.data![index]
                                                      .totalDislikes
                                                      .toString() +
                                                  " Downvote",
                                              15,
                                              white)
                                        ],
                                      ),
                                    ),

                                    //Reply
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/comment.png",
                                          height: 17,
                                          width: 17,
                                        ),
                                        customWidthBox(3),
                                        customText(
                                            snapshot.data!.data![index]
                                                    .totalReplies
                                                    .toString() +
                                                " Reply",
                                            15,
                                            white)
                                      ],
                                    )
                                  ],
                                )
                              ]),
                        ),
                      );
                    })
                : Center(
                    child: customText("No forums found", 15, white),
                  );
          }),
    );
  }

  //Like/Unlike the fourm thread
  Future<void> likeUnlike(String id, int type) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    print(token);
    var jsonResponse = null;
    Map data = {
      "type": type == 1
          ? "Like"
          : type == 2
              ? "Dislike"
              : "",
      "form_id": id
    };
    var response = await http.post(Uri.parse(BASE_URL + "form_like"),
        headers: {
          'api-key': API_KEY,
          'x-access-token': token,
        },
        body: data);
    Navigator.pop(context);
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      print(message);
      print("fourm like/dislike api success");
      refreshData();
      setState(() {});
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      customToastMsg(message);
      throw Exception("Failed to load the work experience!");
    }
  }

  //Report and delete
  showPopupMenu(TapDownDetails details, AllFourmDataModel model) async {
    var tapPosition = details.globalPosition;
    final RenderBox overlay =
        Overlay.of(context)?.context.findRenderObject() as RenderBox;
    await showMenu(
      color: Colors.transparent,
      context: context,
      position: RelativeRect.fromRect(
          tapPosition & const Size(40, 5), Offset.zero & overlay.size),
      items: [
        PopupMenuItem(
            padding: EdgeInsets.zero,
            child: InkWell(
              onTap: (() {
                // model.userId!.id.toString() == loginuserId
                //     ? deleteForm()
                //     : reportForm();
              }),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: black),
                child: Row(mainAxisAlignment: mAround, children: [
                  Image.asset(
                    "assets/icons/white_flag.png",
                    height: 15,
                    width: 15,
                  ),
                  customText(
                      model.userId!.id.toString() == loginuserId
                          ? "Delete"
                          : "Report",
                      11,
                      white)
                ]),
              ),
            )),
      ],
      elevation: 0.0,
    );
  }
}
