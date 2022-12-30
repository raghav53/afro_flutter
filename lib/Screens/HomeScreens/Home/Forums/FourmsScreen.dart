import 'dart:convert';
import 'package:afro/Helper/ReportOperation.dart';
import 'package:afro/Model/CountryModel.dart';
import 'package:afro/Model/Fourms/AllFourmDataModel.dart';
import 'package:afro/Model/Fourms/AllFourmModel.dart';
import 'package:afro/Model/Fourms/ForumCategoryModel.dart';
import 'package:afro/Model/Fourms/MyForumReplies/MyForumAllRepliesModel.dart';
import 'package:afro/Model/Fourms/MyForumThread/MyForumThreadDataModel.dart';
import 'package:afro/Model/Fourms/MyForumThread/MyForumThreadModel.dart';
import 'package:afro/Model/MediaModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/ForumsAllScreens/MyRepliesPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/FourmDetailsPage.dart';
import 'package:afro/Screens/VideoImageViewPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/ForumsNewThread.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ForumsScreenPage extends StatefulWidget {
  _ForumsPage createState() => _ForumsPage();
}

TextEditingController _search = TextEditingController();
var userInfo = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
var searchThread = "";
var bottomSheetIndex = 0;
var selectedCategoryIndex = -1;
String? searchCategory = "";
String countriesIds = "";
List<String> tempCountriesIds = [];
bool enableFillterButton = true;

Future<CountryModel>? _getCountries;
Future<ForumCategoryModel>? _getCategries;

class _ForumsPage extends State<ForumsScreenPage> {
  String? fullName = "", loginuserId = "", profileImage = "";
  bool _showFab = true;
  int clickPosition = 0;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getUsersData();
  }

  getUsersData() async {
    SharedPreferences sharedData = await _prefs;
    fullName = sharedData.getString(userInfo.fullName).toString();
    loginuserId = sharedData.getString(userInfo.id);
    profileImage = sharedData.getString(userInfo.profileImage).toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: onlyTitleCommonAppbar("Forums"),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => ForumsNewThreadPage()))
              .then((value) {
            setState(() {});
          });
        },
        child:Container(
            alignment: Alignment.center,
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: commonButtonLinearGridient),
            child:  Image.asset("assets/icons/add.png",height: 25,width: 25,color: Colors.white,)
        ),
      ),
      body: Container(
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: cStart,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 80, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: cStart,
                  children: [
                    customText("Forums", 20, Colors.white),
                    customHeightBox(5),
                    customText(
                        "The great place to discuss topics with other users",
                        15,
                        Colors.white),
                  ],
                ),
              ),
              customHeightBox(15),
              customDivider(6, Color(0x3dFFFFFF)),
              customHeightBox(10),
              // Search bar and fillter button
              Row(
                crossAxisAlignment: cCenter,
                mainAxisAlignment: mCenter,
                children: [
                  Flexible(
                      flex: 6,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow:  [
                              BoxShadow(
                                  color: black, offset: Offset(0, 2))
                            ]),
                        child: TextField(
                          focusNode: focusNode,
                          controller: _search,
                          onChanged: (value) {
                            setState(() {
                              searchThread = value.toString();
                            });
                          },
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 14, color: white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: yellowColor,
                              ),
                              hintText: "Search",
                              contentPadding:
                                  const EdgeInsets.only(left: 15, top: 15),
                              hintStyle: TextStyle(color: white24)),
                        ),
                      )),
                  customWidthBox(20),
                  Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          enableFillterButton ? openBottomSheet() : null;
                        },
                        child: Image.asset(
                          "assets/icons/fillter.png",
                          height: 20,
                          width: 20,
                        ),
                      )),
                ],
              ),
              customHeightBox(20),
              Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: mEvenly,
                    crossAxisAlignment: cStart,
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _search.clear();
                              _showFab = false;
                              searchThread = "";
                              clickPosition = 0;
                              focusNode.unfocus();
                              focusNode.canRequestFocus = false;
                            });
                          },
                          child: Container(
                            width: 110,
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            decoration: BoxDecoration(
                                gradient: (clickPosition == 0)
                                    ? commonButtonLinearGridient
                                    : null,
                                border: (clickPosition == 0)
                                    ? null
                                    : Border.all(color: Colors.white, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: mCenter,
                              children: [
                                Image.asset(
                                  "assets/icons/all_thread_icn.png",
                                  color: white,
                                  height: 15,
                                  width: 15,
                                ),
                                customWidthBox(5),
                                customText("All Thread", 12, Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _showFab = false;
                              _search.clear();
                              searchThread = "";
                              clickPosition = 1;
                              focusNode.unfocus();
                              focusNode.canRequestFocus = false;
                            });
                          },
                          child: Container(
                            width: 110,
                            padding: EdgeInsets.only(top: 4, bottom: 4),
                            decoration: BoxDecoration(
                                gradient: (clickPosition == 1)
                                    ? commonButtonLinearGridient
                                    : null,
                                border: (clickPosition == 1)
                                    ? null
                                    : Border.all(color: Colors.white, width: 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: mCenter,
                              children: [
                                Image.asset(
                                  "assets/icons/my_threads.png",
                                  color: white,
                                  height: 15,
                                  width: 15,
                                ),
                                customText("My Threads", 12, Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _showFab = true;
                              clickPosition = 2;
                              _search.clear();
                              focusNode.unfocus();
                              searchThread = "";
                              focusNode.canRequestFocus = false;
                            });
                          },
                          child: Container(
                            width: 110,
                            padding: const EdgeInsets.only(top: 4, bottom: 4),
                            decoration: BoxDecoration(
                                gradient: (clickPosition == 2)
                                    ? commonButtonLinearGridient
                                    : null,
                                border: (clickPosition == 2)
                                    ? null
                                    : Border.all(color: Colors.white, width: 1),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: mCenter,
                              children: [
                                Image.asset(
                                  "assets/icons/my_reply_icon.png",
                                  color: white,
                                  height: 15,
                                  width: 15,
                                ),
                                customWidthBox(5),
                                customText("My Replies", 12, Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(
                  height: phoneHeight(context) / 1.5,
                  child: selectedViewFillter(clickPosition))
            ],
          ),
        ),
      ),
    ));
  }

  //Selected listview
  selectedViewFillter(int index) {
    if (index == 0) {
      setState(() {
        enableFillterButton = true;
      });
    } else if (index == 1) {
      setState(() {
        enableFillterButton = false;
      });
    } else if (index == 2) {
      setState(() {
        enableFillterButton = false;
      });
    } else {
      setState(() {
        enableFillterButton = true;
      });
    }
    if (index == 0) {
      return FutureBuilder<AllFourmModel>(
          future: getAllFourmsList(context,
              search: searchThread,
              country: countriesIds.toString(),
              category_id: searchCategory.toString()),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? AllThreadListPage(snapshot.data!)
                : snapshot.data == null
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Container(
                    margin: const EdgeInsets.only(top: 100),
                    alignment: Alignment.center,
                    child: Center(
                      child: customText("No data!", 15, white),
                    ),
                  );
          });
    } else if (index == 1) {
      return FutureBuilder<MyAllThreadsModel>(
          future: getUserAllFourmsList(context, search: searchThread),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? AllUserThreadList(snapshot.data!)
                : snapshot.data == null
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Container(
                    margin: EdgeInsets.only(top: 100),
                    alignment: Alignment.center,
                    child: Center(
                      child: customText("No data!", 15, white),
                    ),
                  );
          });
    } else if (index == 2) {
      return FutureBuilder<MyForumAllRepliesModel>(
          future: getUserAllForumsRepliesList(context, search: searchThread),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? MyRepliesListPage(profileImage.toString(), snapshot.data!)
                : snapshot.data == null
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Container(
                    margin: const EdgeInsets.only(top: 100),
                    alignment: Alignment.center,
                    child: Center(
                      child: customText("No data!", 15, white),
                    ),
                  );
            ;
          });
    }
  }

  //All User Threads list
  AllUserThreadList(MyAllThreadsModel snapshot) {
    return Container(
      height: phoneHeight(context),
      width: phoneWidth(context),
      margin: const EdgeInsets.only(left: 15, right: 15),
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => FourmDetailsPage(
                            fourmId: snapshot.data![index].sId.toString(),
                          )));
                },
                child: Container(
                  /*height: phoneHeight(context),
                    width: phoneWidth(context),*/
                    margin: EdgeInsets.only(
                        bottom: snapshot.data!.length - 1 == index ? 100 : 0),
                    child: fourmItem(snapshot.data![index])));
          }),
    );
  }

  //MY Fourm Item
  Widget fourmItem(MyAllThreadsDataModel model) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: gray1, width: 1)),
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 5,right: 5
        ),
        child: Column(
            mainAxisAlignment: mStart,
            crossAxisAlignment: cStart,
            children: [
              Row(
                crossAxisAlignment: cStart,
                mainAxisAlignment: mStart,
                children: [
                  CachedNetworkImage(
                      imageUrl: model.type == 0
                          ? IMAGE_URL + profileImage.toString()
                          : "https://cutewallpaper.org/22/profile-picture-aesthetic-wallpapers/2596225445.jpg",
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
                                text: model.type == 0
                                    ? fullName.toString()
                                    : "Anonymous",
                                style:
                                    TextStyle(color: yellowColor, fontSize: 14))
                          ])),
                      customHeightBox(10),
                      customText(model.title.toString(), 15, white),
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
              customHeightBox(15),
              mediaWidget(model.media),
              customHeightBox(15),
              Row(
                children: [
                  Spacer(),
                  customText("Last Post: ", 13, Colors.grey[600]!),
                  customText(
                      getTimeFormat(model.createdAt.toString()), 12, white),
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
                          model.isLike == 1
                              ? Icons.thumb_up_sharp
                              : Icons.thumb_up_outlined,
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
                          model.isDislike == 1
                              ? Icons.thumb_down_sharp
                              : Icons.thumb_down_outlined,
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
      ),
    );
  }

  //Show thread options(Report,Delte)
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
    String token = sharedPreferences.getString(userInfo.token).toString();
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
    String token = sharedPreferences.getString(userInfo.token).toString();
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

  //All threads
  AllThreadListPage(AllFourmModel snapshot) {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => FourmDetailsPage(
                          fourmId: snapshot.data![index].sId.toString(),
                        )));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: gray1, width: 1)),
                padding: EdgeInsets.only(top: 5, bottom: 5),
                margin: index == snapshot.data!.length - 1
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
                                imageUrl: snapshot.data![index].type == 0
                                    ? IMAGE_URL +
                                        snapshot
                                            .data![index].userId!.profileImage
                                            .toString()
                                    : "https://cutewallpaper.org/22/profile-picture-aesthetic-wallpapers/2596225445.jpg",
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
                                    snapshot.data![index].type == 0
                                        ? snapshot.data![index].userId!.fullName
                                            .toString()
                                        : "Anonymous",
                                    15,
                                    yellowColor),
                                customHeightBox(10),
                                RichText(
                                    text: TextSpan(
                                        text: "Last post: ",
                                        style: TextStyle(
                                            color: white24, fontSize: 15),
                                        children: [
                                      TextSpan(
                                          text: getTimeFormat(snapshot
                                              .data![index].createdAt
                                              .toString()),
                                          style: TextStyle(
                                              color: yellowColor, fontSize: 15))
                                    ]))
                              ],
                            ),
                            Spacer(),
                            InkWell(
                              onTapDown: (tapDownDetails) {
                                showAllThreadPopupMenu(
                                    tapDownDetails, snapshot.data![index]);
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
                            snapshot.data![index].title.toString(), 15, white),
                      ),
                      customHeightBox(10),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: GestureDetector(
                          child: Text(snapshot.data![index].link.toString(),
                              style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue)),
                          onTap: () async {
                            String url = snapshot.data![index].title.toString();
                            if (await canLaunch(url)) launch(url);
                          },
                        ),
                      ),
                      customHeightBox(10),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: customText(
                            snapshot.data![index].question.toString(),
                            15,
                            white),
                      ),
                      customHeightBox(15),
                      mediaWidget(snapshot.data![index].media),
                      customHeightBox(15),
                      customDivider(1, white),
                      customHeightBox(5),
                      Row(
                        mainAxisAlignment: mEvenly,
                        children: [
                          //Upvote
                          InkWell(
                            onTap: () {
                              likeUnlike(
                                  snapshot.data![index].sId.toString(), 1);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  snapshot.data![index].isLike == 1
                                      ? Icons.thumb_up_sharp
                                      : Icons.thumb_up_outlined,
                                  color: snapshot.data![index].isLike == 1
                                      ? Colors.blueAccent
                                      : white,
                                  size: 19,
                                ),
                                customWidthBox(3),
                                customText(
                                    snapshot.data![index].totalLikes
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
                                  snapshot.data![index].sId.toString(), 2);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  snapshot.data![index].isDislike == 1
                                      ? Icons.thumb_down_sharp
                                      : Icons.thumb_down_outlined,
                                  color: snapshot.data![index].isDislike == 1
                                      ? Colors.blueAccent
                                      : white,
                                  size: 19,
                                ),
                                customWidthBox(3),
                                customText(
                                    snapshot.data![index].totalDislikes
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
                                  snapshot.data![index].totalReplies
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
          }),
    );
  }

  //Report and delete
  showAllThreadPopupMenu(
      TapDownDetails details, AllFourmDataModel model) async {
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
                Navigator.pop(context);
                model.userId!.id.toString() == loginuserId
                    ? deleteForm(model.sId.toString())
                    : showReportDialogBox(
                        "form", model.sId.toString(), context);
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

  //Get the data according fillters
  void openBottomSheet() {
    var selectedTitle = "Country";
    setState(() {
      countriesIds = "";
      searchCategory = "";
    });
    getCountries();
    getForumsCategories();
    showModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              decoration: commonBoxDecoration(),
              child: Column(
                children: [
                  customHeightBox(15),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: mBetween,
                      children: [
                        customText(
                            "Filter & Sort", 12, const Color(0xFFDFB48C)),
                        customText(selectedTitle, 12, const Color(0xFFDFB48C)),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            state(() {
                              bottomSheetIndex = 0;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                  customDivider(5, Colors.white),
                  Row(
                    crossAxisAlignment: cStart,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 15, left: 10),
                        child: Column(
                          mainAxisAlignment: mStart,
                          crossAxisAlignment: cStart,
                          children: [
                            InkWell(
                              onTap: () {
                                state(() {
                                  selectedTitle = "Country";
                                  bottomSheetIndex = 0;
                                });
                              },
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    border: bottomSheetIndex == 0
                                        ? null
                                        : Border.all(
                                            color: Colors.white,
                                            width: 1,
                                            style: BorderStyle.solid),
                                    gradient: bottomSheetIndex == 0
                                        ? commonButtonLinearGridient
                                        : null,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child:
                                      customText("Country", 12, Colors.white),
                                )),
                              ),
                            ),
                            customHeightBox(15),
                            InkWell(
                              onTap: () {
                                state(() {
                                  selectedTitle = "Category";
                                  bottomSheetIndex = 1;
                                });
                              },
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    border: bottomSheetIndex == 1
                                        ? null
                                        : Border.all(
                                            color: Colors.white,
                                            width: 1,
                                            style: BorderStyle.solid),
                                    gradient: bottomSheetIndex == 1
                                        ? commonButtonLinearGridient
                                        : null,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child:
                                      customText("Category", 12, Colors.white),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        alignment: Alignment.center,
                        height: phoneHeight(context) / 2.13,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                                width: phoneWidth(context) / 1.5,
                                child: bottomSheetIndex == 0
                                    ? Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.black),
                                            margin: const EdgeInsets.only(
                                                top: 15, left: 10, right: 10),
                                            child: const TextField(
                                                keyboardType:
                                                    TextInputType.text,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          top: 8, left: 15),
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Color(0xFFDFB48C),
                                                  ),
                                                )),
                                          ),
                                          customHeightBox(10),
                                          Container(
                                              height:
                                                  phoneHeight(context) / 2.7,
                                              child:
                                                  FutureBuilder<CountryModel>(
                                                future: _getCountries,
                                                builder: (context, snapshot) {
                                                  return snapshot.hasData &&
                                                          snapshot.data != null
                                                      ? ListView.builder(
                                                          itemCount: snapshot
                                                              .data!
                                                              .data!
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ListTile(
                                                              leading:
                                                                  CachedNetworkImage(
                                                                height: 35,
                                                                width: 35,
                                                                imageUrl: flagImageUrl
                                                                        .toString() +
                                                                    snapshot
                                                                        .data!
                                                                        .data![
                                                                            index]
                                                                        .iso2
                                                                        .toString()
                                                                        .toLowerCase() +
                                                                    ".png",
                                                                placeholder: (context,
                                                                        url) =>
                                                                    const Icon(
                                                                        Icons
                                                                            .flag),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                              title: customText(
                                                                  snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .title
                                                                      .toString(),
                                                                  15,
                                                                  white),
                                                              trailing:
                                                                  Checkbox(
                                                                      value: snapshot
                                                                          .data!
                                                                          .data![
                                                                              index]
                                                                          .isSelected,
                                                                      onChanged:
                                                                          (val) {
                                                                        state(
                                                                            () {
                                                                          snapshot
                                                                              .data!
                                                                              .data![index]
                                                                              .isSelected = !snapshot.data!.data![index].isSelected;
                                                                          addRemoveCountriesIds(
                                                                              snapshot.data!.data![index].sId.toString(),
                                                                              snapshot.data!.data![index].isSelected);
                                                                        });
                                                                      }),
                                                            );
                                                          })
                                                      : Center(
                                                          child: customText(
                                                              "No countries found!",
                                                              15,
                                                              white),
                                                        );
                                                },
                                              ))
                                        ],
                                      )
                                    : Container(
                                        child:
                                            FutureBuilder<ForumCategoryModel>(
                                                future: _getCategries,
                                                builder: (context, snapshot) {
                                                  return snapshot.hasData &&
                                                          snapshot.data != null
                                                      ? ListView.builder(
                                                          itemCount: snapshot
                                                              .data!
                                                              .data!
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return ListTile(
                                                              title: customText(
                                                                  snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .title
                                                                      .toString(),
                                                                  15,
                                                                  white),
                                                              trailing:
                                                                  Checkbox(
                                                                      value: snapshot
                                                                          .data!
                                                                          .data![
                                                                              index]
                                                                          .isSelected,
                                                                      onChanged:
                                                                          (val) {
                                                                        state(
                                                                            () {
                                                                          if (selectedCategoryIndex !=
                                                                              -1) {
                                                                            snapshot.data!.data![selectedCategoryIndex].isSelected =
                                                                                false;
                                                                            snapshot.data!.data![index].isSelected =
                                                                                true;
                                                                            selectedCategoryIndex =
                                                                                index;
                                                                            searchCategory =
                                                                                snapshot.data!.data![selectedCategoryIndex].sId;
                                                                          } else {
                                                                            snapshot.data!.data![index].isSelected =
                                                                                true;
                                                                            selectedCategoryIndex =
                                                                                index;
                                                                          }
                                                                          print(
                                                                              selectedCategoryIndex);
                                                                        });
                                                                      }),
                                                            );
                                                          })
                                                      : Center(
                                                          child: customText(
                                                              "No categories found!",
                                                              15,
                                                              white),
                                                        );
                                                }),
                                      )),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: () {
                                  setState(() {});
                                  print(countriesIds.toString());
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 7, bottom: 7, left: 20, right: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: commonButtonLinearGridient,
                                    ),
                                    child:
                                        customText("Apply", 16, Colors.white)),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  addRemoveCountriesIds(String id, bool value) {
    if (value) {
      tempCountriesIds.add(id.toString());
    } else {
      tempCountriesIds.remove(id.toString());
    }
    countriesIds = tempCountriesIds.join(",");
  }

  //Get Countries
  getCountries() {
    Future.delayed(Duration.zero, () {
      _getCountries = getCountriesList(context, isShow: false);
      setState(() {});
      _getCountries!.whenComplete(() => {});
    });
  }

  //Get Categories of Forums
  getForumsCategories() {
    Future.delayed(Duration.zero, () {
      _getCategries = getForumCategorisList(context, isShow: false);
      setState(() {});
      _getCategries!.whenComplete(() => {});
    });
  }

  //Media Widget for comment
  mediaWidget(List<MediaModel>? data) {
    int currentPos = 0;
    return Container(
        child: data!.isNotEmpty
            ? Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int itemIndex,
                              int pageViewIndex) =>
                          data[itemIndex].type == "image"
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoImageViewPage(
                                                    url: IMAGE_URL +
                                                        data[itemIndex]
                                                            .path
                                                            .toString(),
                                                    type: 1)));
                                  },
                                  child: Container(
                                    height: 150,
                                    child: CachedNetworkImage(
                                      imageUrl: IMAGE_URL +
                                          data[itemIndex].path.toString(),
                                      placeholder: (context, url) => const Icon(
                                        Icons.person,
                                        size: 50,
                                      ),
                                      imageBuilder: (context, image) {
                                        return Container(
                                            decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: image,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ));
                                      },
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                VideoImageViewPage(
                                                    url: data[itemIndex]
                                                        .path
                                                        .toString(),
                                                    type: 0)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: white24),
                                    child: Center(
                                        child: Icon(
                                      Icons.play_circle,
                                      color: white,
                                      size: 70,
                                    )),
                                  ),
                                ),
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentPos = index;
                          });
                        },
                        autoPlay: true,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.9,
                        aspectRatio: 2.0,
                        initialPage: 2,
                      ),
                    ),
                    customHeightBox(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: data.map((url) {
                        int index = data.indexOf(url);
                        return Container(
                          width: 8.0,
                          height: 8.0,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPos == index
                                ? Color.fromARGB(228, 218, 218, 218)
                                : Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              )
            : null);
  }
}
