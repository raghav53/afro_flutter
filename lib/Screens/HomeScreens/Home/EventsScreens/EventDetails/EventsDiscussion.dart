import 'dart:convert';

import 'package:afro/Model/Events/EventDetails/EventPosts/EventPostDataModel.dart';
import 'package:afro/Model/Events/EventDetails/EventPosts/EventPostModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventCommentsList.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/ShareThoughtsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/MyProfile.dart';
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
import 'package:afro/Screens/VideoImageViewPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class EventDiscussionList extends StatefulWidget {
  String eventId = "";
  EventDiscussionList({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventDiscussionList> createState() => _EventDiscussionListState();
}

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<EventPostModel>? _getEventPosts;
String? userId = "";

class _EventDiscussionListState extends State<EventDiscussionList> {
  String? _tempDir;
  @override
  void initState() {
    super.initState();
    getUserDetails();
    Future.delayed(Duration.zero, () {
      _getEventPosts = getEventPostList(context, widget.eventId);
      setState(() {});
      _getEventPosts!.whenComplete(() => () {});
    });
  }

  refreshData() {
    Future.delayed(Duration.zero, () {
      _getEventPosts = getEventPostList(context, widget.eventId);
      setState(() {});
      _getEventPosts!.whenComplete(() => () {});
    });
  }

  getUserDetails() async {
    SharedPreferences shared = await _prefs;
    userId = shared.getString(user.id).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: cStart,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: customText("Sngine News", 14, yellowColor),
        ),
        customHeightBox(10),
        //Comment Section
        InkWell(
          onTap: () async {
            await Navigator.of(context)
                .push(MaterialPageRoute(
                    builder: (context) => ShareThoughts(
                          evenGroupId: widget.eventId,
                          type: "event",
                        )))
                .then((value) => () {
                      setState(() {
                        refreshData();
                      });
                    });
            debugPrint("From Post");
            setState(() {
              refreshData();
            });
          },
          child: Container(
              margin: const EdgeInsets.only(left: 15, right: 15),
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: black),
              child: Center(
                child: customText(
                    "What's in your mind? #Hashtag #Tags", 14, gray1),
              )),
        ),

        //Comments
        SizedBox(
         /* height: phoneHeight(context) / 2,*/
          child: FutureBuilder<EventPostModel>(
              future: _getEventPosts,
              builder: (context, snapshot) {
                return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                    ? ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data!.data!.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          String? totalLikes = snapshot
                              .data!.data![index].totalLikes
                              .toString();

                          String? totalComments = snapshot
                              .data!.data![index].totalComments
                              .toString();
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: black),
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 10),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, top: 10, bottom: 10),
                              child: Column(
                                children: [
                                  customWidthBox(10),
                                  Column(
                                    crossAxisAlignment: cStart,
                                    children: [
                                      Row(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: IMAGE_URL +
                                                snapshot.data!.data![index]
                                                    .user!.profileImage
                                                    .toString(),
                                            placeholder: (context, url) =>
                                                const Icon(
                                              Icons.person,
                                              size: 50,
                                            ),
                                            imageBuilder: (context, image) {
                                              return CircleAvatar(
                                                  backgroundImage: image);
                                            },
                                          ),
                                          customWidthBox(10),
                                          InkWell(
                                            onTap: () {
                                              if (snapshot.data!.data![index]
                                                      .userId ==
                                                  userId) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (builder) =>
                                                            MyProfilePage()));
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (builder) =>
                                                            OtherUserProfilePageScreen(
                                                              name: snapshot
                                                                  .data!
                                                                  .data![
                                                                      index]
                                                                  .user!
                                                                  .fullName,
                                                              userID: snapshot
                                                                  .data!
                                                                  .data![
                                                                      index]
                                                                  .user!
                                                                  .sId
                                                                  .toString(),
                                                            )));
                                              }
                                            },
                                            child: customText(
                                                snapshot.data!.data![index]
                                                    .user!.fullName
                                                    .toString(),
                                                15,
                                                white),
                                          ),
                                        ],
                                      ),
                                      customHeightBox(5),
                                      Container(
                                        margin: EdgeInsets.only(left: 50),
                                        child: snapshot.data!.data![index]
                                                .caption!.isNotEmpty
                                            ? customText(
                                                snapshot.data!.data![index]
                                                    .caption
                                                    .toString(),
                                                12,
                                                white)
                                            : null,
                                      ),

                                      mediaWidget(
                                          snapshot.data!.data![index]),
                                      customHeightBox(20),
                                      //Likes and Comment
                                      Row(
                                        crossAxisAlignment: cCenter,
                                        mainAxisAlignment: mCenter,
                                        children: [
                                          //like
                                          InkWell(
                                            onTap: () {
                                              likeDislike(
                                                  context,
                                                  snapshot
                                                      .data!.data![index].sId
                                                      .toString(),
                                                  snapshot.data!.data![index]
                                                      .isLike!);
                                            },
                                            child: Row(
                                              mainAxisAlignment: mCenter,
                                              crossAxisAlignment: cCenter,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/like.png",
                                                  height: 17,
                                                  width: 17,
                                                  color: snapshot
                                                              .data!
                                                              .data![index]
                                                              .isLike ==
                                                          1
                                                      ? Colors.blue
                                                      : null,
                                                ),
                                                customWidthBox(5),
                                                customText(
                                                    totalLikes + " Likes",
                                                    15,
                                                    white)
                                              ],
                                            ),
                                          ),
                                          customWidthBox(80),
                                          //Comment

                                          InkWell(
                                            onTap: () {
                                              print("Post Id:-" +
                                                  snapshot
                                                      .data!.data![index].sId
                                                      .toString());
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CommentList(
                                                            parentPostId:
                                                                snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .sId
                                                                    .toString(),
                                                            eventId: snapshot
                                                                .data!
                                                                .data![index]
                                                                .eventId
                                                                .toString(),
                                                          )));
                                            },
                                            child: Row(
                                              crossAxisAlignment: cCenter,
                                              children: [
                                                Image.asset(
                                                  "assets/icons/comment.png",
                                                  height: 17,
                                                  width: 17,
                                                ),
                                                customWidthBox(5),
                                                customText(
                                                    totalComments +
                                                        " Comments",
                                                    15,
                                                    white)
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        })
                    : Center(
                        child: customText("No post available..", 15, white),
                      );
              }),
        )
      ],
    );
  }

  mediaWidget(EventPostDataModel data) {
    return Container(
        child: data.media!.isNotEmpty
            ? Container(
                padding: EdgeInsets.all(5),
                child: CarouselSlider.builder(
                  itemCount: data.media!.length,
                  itemBuilder: (BuildContext context, int itemIndex,
                          int pageViewIndex) =>
                      data.media![itemIndex].type == "image"
                          ? InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VideoImageViewPage(
                                                url: IMAGE_URL +
                                                    data.media![itemIndex].path
                                                        .toString(),
                                                type: 1)));
                              },
                              child: Container(
                                height: 150,
                                child: CachedNetworkImage(
                                  imageUrl: IMAGE_URL +
                                      data.media![itemIndex].path.toString(),
                                  placeholder: (context, url) => const Icon(
                                    Icons.person,
                                    size: 50,
                                  ),
                                  imageBuilder: (context, image) {
                                    return Container(
                                        decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
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
                                print(
                                    "type :- ${data.media![itemIndex].type} , URl :- ${data.media![itemIndex].path.toString()}");

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            VideoImageViewPage(
                                                url: data.media![itemIndex].path
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
                    autoPlay: false,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    viewportFraction: 0.9,
                    aspectRatio: 2.0,
                    initialPage: 2,
                  ),
                ),
              )
            : null);
  }

  //Like dislike the post
  Future<void> likeDislike(
      BuildContext context, String eventPostId, int isLike) async {
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    print(token);
    var jsonResponse = null;
    Map data = {
      "type": isLike == 0 ? "Like" : "Dislike",
      "event_id": widget.eventId.toString(),
      "event_post_id": eventPostId
    };
    var response = await http.post(Uri.parse(BASE_URL + "like_event_post"),
        headers: {
          'api-key': API_KEY,
          'x-access-token': token,
        },
        body: data);

    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      refreshData();
      print(message);
      print("Post like/dislike api success");
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
