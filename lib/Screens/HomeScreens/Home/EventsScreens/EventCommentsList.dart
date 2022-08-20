import 'dart:convert';

import 'package:afro/Model/Events/EventDetails/EventComments/EventCommetModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CommentList extends StatefulWidget {
  String parentPostId = "";
  String eventId = "";
  CommentList({Key? key, required this.parentPostId, required this.eventId})
      : super(key: key);

  @override
  State<CommentList> createState() => _CommentListState();
}

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<EventCommentModel>? _getComments;
Future<EventCommentModel>? _getCommentsOfComments;

bool? replyComment = false;
String? parentCommentId = "";

String? replyCommentUserName = "";

class _CommentListState extends State<CommentList> {
  FocusNode focusNode = FocusNode();
  TextEditingController comment = TextEditingController();
  @override
  void initState() {
    super.initState();
    replyComment = false;
    print("Received post id :-" + widget.parentPostId.toString());
    Future.delayed(Duration.zero, () {
      _getComments =
          getEventCommentsList(context, widget.parentPostId, progress: "yes");
      setState(() {});
      _getComments!.whenComplete(() => () {});
    });
  }

  refreshDataList() {
    Future.delayed(Duration.zero, () {
      _getComments = getEventCommentsList(context, widget.parentPostId);
      setState(() {});
      _getComments!.whenComplete(() => () {});
    });
  }

  getCommentsReplies(String parentCommentId) {
    Future.delayed(Duration.zero, () {
      _getCommentsOfComments = getEventCommentsoCommentList(
          context, widget.parentPostId, parentCommentId);
      setState(() {});
      _getCommentsOfComments!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            extendBodyBehindAppBar: true,
            extendBody: true,
            appBar: commonAppbar("Comments"),
            body: Container(
                padding: EdgeInsets.only(top: 55),
                decoration: commonBoxDecoration(),
                height: phoneHeight(context),
                width: phoneWidth(context),
                child: Stack(children: [
                  Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      margin: EdgeInsets.only(bottom: 30),
                      child: FutureBuilder<EventCommentModel>(
                        future: _getComments,
                        builder: (context, snapshot) {
                          return snapshot.hasData &&
                                  snapshot.data!.data!.isNotEmpty
                              ? ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.data!.length,
                                  itemBuilder: (context, index) {
                                    bool? isShown =
                                        snapshot.data!.data![index].isShown;
                                    return Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      padding: const EdgeInsets.only(top: 10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: cStart,
                                        children: [
                                          CachedNetworkImage(
                                              imageUrl: IMAGE_URL +
                                                  snapshot.data!.data![index]
                                                      .user!.profileImage
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
                                          customWidthBox(10),
                                          Container(
                                            width: 185,
                                            child: Column(
                                              crossAxisAlignment: cStart,
                                              children: [
                                                customHeightBox(5),
                                                customText(
                                                    snapshot.data!.data![index]
                                                        .user!.fullName
                                                        .toString(),
                                                    14,
                                                    yellowColor),
                                                customHeightBox(5),
                                                customText(
                                                    snapshot.data!.data![index]
                                                        .comment
                                                        .toString(),
                                                    13,
                                                    white),
                                                customHeightBox(18),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            replyComment =
                                                                !replyComment!;
                                                            if (replyComment ==
                                                                true) {
                                                              parentCommentId =
                                                                  snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .sId
                                                                      .toString();
                                                              replyCommentUserName =
                                                                  snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .user!
                                                                      .fullName
                                                                      .toString();
                                                            } else {
                                                              parentCommentId =
                                                                  "";
                                                              replyCommentUserName =
                                                                  "";
                                                            }
                                                            print("Parent Comment Id:-" +
                                                                parentCommentId
                                                                    .toString());
                                                            print(replyComment);
                                                          });
                                                        },
                                                        child: customText(
                                                            "Reply",
                                                            12,
                                                            gray1)),
                                                    customWidthBox(30),
                                                    InkWell(
                                                      onTap: () {
                                                        if (snapshot
                                                                .data!
                                                                .data![index]
                                                                .totalReplies ==
                                                            0) {
                                                          return;
                                                        }
                                                        print("Total replies");
                                                        snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .isShown !=
                                                                true
                                                            ? getCommentsReplies(
                                                                snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .sId
                                                                    .toString())
                                                            : null;
                                                        setState(() {
                                                          snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .isShown =
                                                              !snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .isShown!;
                                                        });
                                                      },
                                                      child: Row(children: [
                                                        customText(
                                                            snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .totalReplies
                                                                    .toString() +
                                                                "  Total replies",
                                                            12,
                                                            gray1),
                                                        Icon(
                                                          Icons.arrow_drop_down,
                                                          color: gray1,
                                                        )
                                                      ]),
                                                    )
                                                  ],
                                                ),
                                                Container(
                                                    width: phoneWidth(context) /
                                                        1.7,
                                                    child: snapshot
                                                                .data!
                                                                .data![index]
                                                                .isShown ==
                                                            true
                                                        ? totalCommentReplies()
                                                        : null),
                                                customHeightBox(10)
                                              ],
                                            ),
                                          ),
                                          Text(
                                            getTimeFormat(snapshot
                                                .data!.data![index].createdAt
                                                .toString()),
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: gray1,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  })
                              : Center(
                                  child: customText("No comments!", 15, white),
                                );
                        },
                      )),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      width: phoneWidth(context),
                      color: Color(0xFF37364D),
                      height: replyComment == false ? 57 : 80,
                      child: Column(
                        children: [
                          Container(
                            child: replyComment == true
                                ? Row(
                                    children: [
                                      customText(
                                          "Replying to " +
                                              replyCommentUserName.toString(),
                                          13,
                                          white),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            replyComment = false;
                                            parentCommentId = "";
                                          });
                                        },
                                        child: Icon(
                                          Icons.close,
                                          color: white,
                                        ),
                                      ),
                                      customWidthBox(15)
                                    ],
                                  )
                                : SizedBox(),
                          ),
                          Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: white, width: 1),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: TextField(
                                  controller: comment,
                                  showCursor: true,
                                  scribbleEnabled: false,
                                  enableIMEPersonalizedLearning: false,
                                  readOnly: false,
                                  focusNode: focusNode,
                                  decoration: const InputDecoration(
                                      hintText: "Write message...",
                                      hintStyle:
                                          TextStyle(color: Colors.black54),
                                      border: InputBorder.none),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              FloatingActionButton(
                                onPressed: () {
                                  commentOnpost(
                                      context,
                                      widget.eventId.toString(),
                                      widget.parentPostId.toString());
                                  FocusScope.of(context).unfocus();
                                },
                                child: const Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ]))));
  }

  //Comment on post
  Future<void> commentOnpost(
    BuildContext context,
    String eventId,
    String eventPId,
  ) async {
    if (comment.text.isEmpty) {
      customToastMsg("Please type sommething!");
      return;
    }
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    print(token);
    var jsonResponse = null;

    Map data = {
      "comment": comment.text.toString(),
      "event_id": eventId,
      "event_post_id": eventPId,
    };
    if (replyComment == true) {
      data.addAll({"parent_comment_id": parentCommentId});
    }
    print(data);
    var response = await http.post(Uri.parse(BASE_URL + "event_post_comment"),
        headers: {
          'api-key': API_KEY,
          'x-access-token': token,
        },
        body: data);

    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      refreshDataList();
      getCommentsReplies(parentCommentId.toString());
      parentCommentId = "";
      setState(() {
        replyComment = false;
      });
      print(message);
      print("Post comment api success");
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      customToastMsg(message);
      throw Exception("Failed to load the work experience!");
    }
  }

  totalCommentReplies() {
    return FutureBuilder<EventCommentModel>(
      future: _getCommentsOfComments,
      builder: (context, snapshot) {
        return snapshot.hasData && snapshot.data!.data!.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: snapshot.data!.data!.length,
                itemBuilder: (context, index) {
                  bool? isShown = snapshot.data!.data![index].isShown;
                  return Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.only(top: 10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: cStart,
                      children: [
                        CachedNetworkImage(
                            imageUrl: IMAGE_URL +
                                snapshot.data!.data![index].user!.profileImage
                                    .toString(),
                            errorWidget: (error, context, url) =>
                                Icon(Icons.person),
                            placeholder: (context, url) => Icon(Icons.person),
                            imageBuilder: (context, url) {
                              return CircleAvatar(
                                backgroundImage: url,
                              );
                            }),
                        customWidthBox(10),
                        Column(
                          crossAxisAlignment: cStart,
                          children: [
                            customHeightBox(5),
                            customText(
                                snapshot.data!.data![index].user!.fullName
                                    .toString(),
                                14,
                                yellowColor),
                            customHeightBox(5),
                            customText(
                                snapshot.data!.data![index].comment.toString(),
                                13,
                                white),
                            customHeightBox(18),
                            customHeightBox(10)
                          ],
                        ),
                        Spacer(),
                        customText("05:12 PM", 12, gray1)
                      ],
                    ),
                  );
                })
            : SizedBox();
      },
    );
  }
}
