import 'dart:convert';

import 'package:afro/Model/Fourms/MyForumThread/MyForumThreadDataModel.dart';
import 'package:afro/Model/Fourms/MyForumThread/MyForumThreadModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/FourmDetailsPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyThreadsPage extends StatefulWidget {
  MyThreadsPage({Key? key}) : super(key: key);

  @override
  State<MyThreadsPage> createState() => _MyThreadsPageState();
}

var userInfo = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<MyAllThreadsModel>? _getUSerForums;

class _MyThreadsPageState extends State<MyThreadsPage> {
  String? fullName = "", userId = "", profileImage = "";
  @override
  void initState() {
    super.initState();
    getUsersData();
    Future.delayed(Duration.zero, () {
      _getUSerForums = getUserAllFourmsList(context);
      setState(() {});
      _getUSerForums!.whenComplete(() => () {});
    });
  }

  getUsersData() async {
    SharedPreferences sharedData = await _prefs;
    fullName = sharedData.getString(userInfo.fullName).toString();
    userId = sharedData.getString(userInfo.id);
    profileImage = sharedData.getString(userInfo.profileImage).toString();
  }

  refreshData() {
    Future.delayed(Duration.zero, () {
      _getUSerForums = getUserAllFourmsList(context);
      setState(() {});
      _getUSerForums!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MyAllThreadsModel>(
        future: _getUSerForums,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.data!.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: ListView.builder(
                      shrinkWrap: true,
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
                            child: fourmItem(snapshot.data!.data![index]));
                      }),
                )
              : Center(
                  child: customText("No data found!", 15, white),
                );
        });
  }

  //Fourm Item
  Widget fourmItem(MyAllThreadsDataModel model) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: gray1, width: 1)),
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
          mainAxisAlignment: mStart,
          crossAxisAlignment: cStart,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Row(
                crossAxisAlignment: cStart,
                mainAxisAlignment: mStart,
                children: [
                  CachedNetworkImage(
                      imageUrl: IMAGE_URL + profileImage.toString(),
                      errorWidget: (error, context, url) =>
                          const Icon(Icons.person),
                      placeholder: (context, url) => const Icon(Icons.person),
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
                      RichText(
                          text: TextSpan(
                              text: "By: ",
                              style: TextStyle(
                                  color: Colors.grey[600]!, fontSize: 15),
                              children: [
                            TextSpan(
                                text: fullName.toString(),
                                style:
                                    TextStyle(color: yellowColor, fontSize: 14))
                          ])),
                      customHeightBox(10),
                      customText(model.title.toString(), 15, yellowColor),
                    ],
                  ),
                  Spacer(),
                  GestureDetector(
                    onTapDown: (tapDownDetails) {
                      customToastMsg("Hello");
                      showPopupMenu(tapDownDetails, model.sId.toString());
                    },
                    child: Image.asset(
                      "assets/icons/more_option.png",
                      color: white,
                      height: 30,
                      width: 17,
                    ),
                  ),
                  customWidthBox(5)
                ],
              ),
            ),
            customHeightBox(10),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: InkWell(
                  onTap: () {},
                  child: customText(
                      model.link == null
                          ? "Link not available"
                          : model.link.toString(),
                      15,
                      model.link != null ? Colors.blueAccent : white)),
            ),
            customHeightBox(10),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: customText(model.question.toString(), 15, white),
            ),
            Row(
              children: [
                Spacer(),
                customText("Last Post: ", 13, Colors.grey[600]!),
                customText(
                    dataTimeTextFormater(model.createdAt.toString())["date"] +
                        " at " +
                        dataTimeTextFormater(
                            model.createdAt.toString())["time"],
                    12,
                    white),
                customWidthBox(10)
              ],
            ),
            customHeightBox(10),
            customDivider(1, white),
            customHeightBox(5),
            Row(
              mainAxisAlignment: mEvenly,
              children: [
                //Upvote
                InkWell(
                  onTap: () {
                    likeUnlike(model.sId.toString(), 1);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_up_outlined,
                        color: model.isLike == 1 ? Colors.blueAccent : white,
                        size: 19,
                      ),
                      customWidthBox(3),
                      customText("0" + " Upvote", 15, white)
                    ],
                  ),
                ),

                //Downvote
                InkWell(
                  onTap: () {
                    likeUnlike(model.sId.toString(), 2);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_down_outlined,
                        color: model.isDislike == 1 ? Colors.blueAccent : white,
                        size: 19,
                      ),
                      customWidthBox(3),
                      customText("0" + " Downvote", 15, white)
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
                        model.totalReplies.toString() + " Reply", 15, white)
                  ],
                )
              ],
            )
          ]),
    );
  }

  showPopupMenu(TapDownDetails details, String formId) async {
    var tapPosition = details.globalPosition;
    final RenderBox overlay =
        Overlay.of(context)?.context.findRenderObject() as RenderBox;
    await showMenu(
      color: Colors.transparent,
      context: context,
      position: RelativeRect.fromRect(
          tapPosition & const Size(40, 5), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        PopupMenuItem(
            padding: EdgeInsets.zero,
            child: InkWell(
              onTap: (() {
                Navigator.pop(context);
                deleteForm(formId);
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
                  customText("Detele", 11, white)
                ]),
              ),
            )),
      ],
      elevation: 0.0,
    );
  }

  //Delete the form thread
  Future<void> deleteForm(String id) async {
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    print(token);
    var jsonResponse = null;
    var response =
        await http.delete(Uri.parse(BASE_URL + "form/${id}"), headers: {
      'api-key': API_KEY,
      'x-access-token': token,
    });
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      print(message);
      print("fourm delete api success");
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
}
