import 'dart:convert';
import 'package:afro/Model/Group/GroupDetails/Disscussion/GroupPostDataModel.dart';
import 'package:afro/Model/Group/GroupDetails/Disscussion/GroupPostModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/ShareThoughtsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupPostCommentList.dart';
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
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroupDiscussionPage extends StatefulWidget {
  String groupId = "";
  GroupDiscussionPage({Key? key, required this.groupId}) : super(key: key);
  @override
  State<GroupDiscussionPage> createState() => _GroupSidcussionState();
}

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<GroupPostModel>? _getGroupPosts;
String? userId = "";

class _GroupSidcussionState extends State<GroupDiscussionPage> {
  @override
  void initState() {
    super.initState();
    getUserDetails();
    Future.delayed(Duration.zero, () {
      _getGroupPosts = getGroupPostList(context, widget.groupId);
      setState(() {});
      _getGroupPosts!.whenComplete(() => () {});
    });
  }

  refreshData() {
    Future.delayed(Duration.zero, () {
      _getGroupPosts = getGroupPostList(context, widget.groupId);
      setState(() {});
      _getGroupPosts!.whenComplete(() => () {});
    });
  }

  getUserDetails() async {
    SharedPreferences shared = await _prefs;
    userId = shared.getString(user.id).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: cStart,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: customText("Sngine News", 14, yellowColor),
          ),
          customHeightBox(10),
          //Comment Section
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => ShareThoughts(
                            evenGroupId: widget.groupId,
                            type: "group",
                          )))
                  .then((value) => () {
                        print("lkdjsudgsftluledgfhelrd1111");

                        refreshData();
                      });
            },
            child: Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: black),
                child: Center(
                  child: customText(
                      "What's in your mind? #Hashtag #Tags", 14, gray1),
                )),
          ),
          customHeightBox(20),
          //Comments
          Container(
            height: phoneHeight(context) / 2,
            child: FutureBuilder<GroupPostModel>(
                future: _getGroupPosts,
                builder: (context, snapshot) {
                  return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                      ? ListView.builder(
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
                                            customText(
                                                snapshot.data!.data![index]
                                                    .user!.fullName
                                                    .toString(),
                                                15,
                                                white),
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
                                              onTap: () async {
                                                await Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            GroupPostCommentListPage(
                                                                groupId: widget
                                                                    .groupId
                                                                    .toString(),
                                                                postID: snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .sId
                                                                    .toString())))
                                                    .then((value) => () {
                                                          setState(() {
                                                            print(
                                                                "lkdjsudgsftluledgfhelrd");
                                                            refreshData();
                                                          });
                                                        });
                                                debugPrint("From Post");
                                                setState(() {
                                                  refreshData();
                                                });
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
      ),
    );
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
      "group_id": widget.groupId.toString(),
      "group_post_id": eventPostId
    };
    var response = await http.post(Uri.parse(BASE_URL + "like_group_post"),
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

  mediaWidget(GroupPostDataModel data) {
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
}
