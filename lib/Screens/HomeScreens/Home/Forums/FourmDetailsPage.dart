import 'dart:convert';

import 'package:afro/Model/Fourms/ForumsReplies/ForumsRepliesDataModel.dart';
import 'package:afro/Model/Fourms/ForumsReplies/ForumsRepliesModel.dart';
import 'package:afro/Model/Fourms/FourmDetails/FourmDetailsModel.dart';
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

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class FourmDetailsPage extends StatefulWidget {
  String fourmId = "";
  FourmDetailsPage({Key? key, required this.fourmId}) : super(key: key);

  @override
  State<FourmDetailsPage> createState() => _FourmDetailsPageState();
}

Future<FourmDetailsModel>? _getFourmDetails;
Future<ForumsRepliesModel>? _getForumReplies;
Future<ForumsRepliesModel>? _getForumParentReplies;
TextEditingController _controller = TextEditingController();
bool? replyComment = false;
String? parentCommentId = "";
String? commentCaption = "";
String? replyCommentUserName = "";

class _FourmDetailsPageState extends State<FourmDetailsPage> {
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    print(widget.fourmId);
    Future.delayed(Duration.zero, () {
      _getForumReplies = getForumsRepliesList(
          widget.fourmId.toString(), context,
          isShow: false);
      setState(() {});
      _getForumReplies!.whenComplete(() => () {});
    });
    Future.delayed(Duration.zero, () {
      _getFourmDetails = getFourmDetails(context, widget.fourmId);
      setState(() {});
      _getFourmDetails!.whenComplete(() => () {});
    });
  }

  refreshData() {
    Future.delayed(Duration.zero, () {
      _getForumReplies = getForumsRepliesList(
          widget.fourmId.toString(), context,
          isShow: false);
      setState(() {});
      _getForumReplies!.whenComplete(() => () {});
    });
  }

  getParentReplies(String parentFormReplyId) {
    Future.delayed(Duration.zero, () {
      _getForumParentReplies = getForumsRepliesList(widget.fourmId, context,
          isShow: false, parentReplyId: parentFormReplyId.toString());
      setState(() {});
      _getForumParentReplies!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: commonAppbar("Detail"),
      body: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          padding: EdgeInsets.only(top: 70),
          child: Stack(
            children: [
              FutureBuilder<FourmDetailsModel>(
                future: _getFourmDetails,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? SingleChildScrollView(
                          child: Column(
                          crossAxisAlignment: cStart,
                          children: [
                            //Main Content
                            Container(
                                margin: EdgeInsets.only(left: 15, right: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border:
                                        Border.all(color: white24, width: 1)),
                                child: Column(
                                  crossAxisAlignment: cStart,
                                  children: [
                                    customHeightBox(10),
                                    Row(
                                      mainAxisAlignment: mStart,
                                      crossAxisAlignment: cStart,
                                      children: [
                                        customWidthBox(10),
                                        CachedNetworkImage(
                                          imageUrl: IMAGE_URL +
                                              snapshot.data!.data!.userId!
                                                  .profileImage
                                                  .toString(),
                                          placeholder: (context, url) =>
                                              const CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      "tom_cruise.jpeg")),
                                          imageBuilder: (context, image) =>
                                              CircleAvatar(
                                            backgroundImage: image,
                                          ),
                                        ),
                                        customWidthBox(10),
                                        Column(
                                          crossAxisAlignment: cStart,
                                          children: [
                                            customText(
                                                snapshot.data!.data!.userId!
                                                    .fullName
                                                    .toString(),
                                                15,
                                                yellowColor),
                                            customHeightBox(7),
                                            customText(
                                                snapshot.data!.data!.title
                                                    .toString(),
                                                13,
                                                white)
                                          ],
                                        ),
                                        Spacer(),
                                        customText(
                                            dataTimeTextFormater(snapshot
                                                    .data!.data!.createdAt
                                                    .toString())["date"] +
                                                " at " +
                                                dataTimeTextFormater(snapshot
                                                    .data!.data!.createdAt
                                                    .toString())["time"],
                                            15,
                                            yellowColor),
                                        customWidthBox(10),
                                      ],
                                    ),
                                    customHeightBox(20),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: customText(
                                          snapshot.data!.data!.question
                                              .toString(),
                                          15,
                                          white),
                                    ),
                                    customHeightBox(10)
                                  ],
                                )),
                            customHeightBox(20),
                            customDivider(1, yellowColor),

                            Padding(
                              padding:
                                  EdgeInsets.only(top: 10, left: 15, right: 15),
                              child: RichText(
                                  text: const TextSpan(
                                      style: TextStyle(fontSize: 15),
                                      text:
                                          "Remember to keep comments respectful and to follow our",
                                      children: [
                                    TextSpan(
                                        text: " Community Guidelines ",
                                        style:
                                            TextStyle(color: Colors.blueAccent))
                                  ])),
                            ),

                            Container(
                              child: FutureBuilder<ForumsRepliesModel>(
                                future: _getForumReplies,
                                builder: (context, snapshot) {
                                  return snapshot.hasData &&
                                          snapshot.data!.data!.isNotEmpty
                                      ? ListView.builder(
                                          physics: ClampingScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount:
                                              snapshot.data!.data!.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                forumReplyTile(
                                                  model: snapshot
                                                      .data!.data![index],
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(left: 75),
                                                  child: Row(
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
                                                            13,
                                                            white24),
                                                      ),
                                                      Spacer(),
                                                      Container(
                                                        child: snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .totalReplies !=
                                                                0
                                                            ? Row(
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      if (snapshot
                                                                              .data!
                                                                              .data![index]
                                                                              .totalReplies ==
                                                                          0) {
                                                                        return;
                                                                      }
                                                                      getParentReplies(snapshot
                                                                          .data!
                                                                          .data![
                                                                              index]
                                                                          .sId
                                                                          .toString());
                                                                      setState(
                                                                          () {
                                                                        snapshot
                                                                            .data!
                                                                            .data![index]
                                                                            .parentRepliesShow = !snapshot.data!.data![index].parentRepliesShow!;
                                                                      });
                                                                    },
                                                                    child: customText(
                                                                        "total reply " +
                                                                            snapshot.data!.data![index].totalReplies.toString(),
                                                                        13,
                                                                        white24),
                                                                  ),
                                                                  Icon(
                                                                    Icons
                                                                        .arrow_drop_down,
                                                                    color:
                                                                        white24,
                                                                  )
                                                                ],
                                                              )
                                                            : null,
                                                      ),
                                                      customWidthBox(20)
                                                    ],
                                                  ),
                                                ),
                                                customHeightBox(5),
                                                Container(
                                                    width: phoneWidth(context) /
                                                        1.4,
                                                    child: snapshot
                                                            .data!
                                                            .data![index]
                                                            .parentRepliesShow!
                                                        ? totalCommentReplies()
                                                        : null),
                                              ],
                                            );
                                          },
                                        )
                                      : Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(top: 200),
                                          child: customText(
                                              "No comments...", 15, white));
                                },
                              ),
                            )
                          ],
                        ))
                      : Center(
                          child: customText("No details available", 15, white),
                        );
                },
              ),
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
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                commentCaption = value.toString();
                              },
                              showCursor: true,
                              scribbleEnabled: false,
                              enableIMEPersonalizedLearning: false,
                              readOnly: false,
                              focusNode: focusNode,
                              decoration: const InputDecoration(
                                  hintText: "Write message...",
                                  hintStyle: TextStyle(color: Colors.black54),
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
                              );
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
            ],
          )),
    ));
  }

  Widget totalCommentReplies() {
    return FutureBuilder<ForumsRepliesModel>(
        future: _getForumParentReplies,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.data!.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data!.data!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      child: forumReplyTile(model: snapshot.data!.data![index]),
                    );
                  })
              : SizedBox();
        });
  }

  //Comment on post
  Future<void> commentOnpost(
    BuildContext context,
  ) async {
    if (commentCaption.toString().isEmpty) {
      customToastMsg("Please type sommething!");
      return;
    }
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    print(token);
    var jsonResponse = null;

    Map data = {
      "reply": commentCaption.toString(),
      "form_id": widget.fourmId,
    };
    if (replyComment == true) {
      data.addAll({"parent_reply_id": parentCommentId});
    }
    print(data);
    var response = await http.post(Uri.parse(BASE_URL + "form_reply"),
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
      setState(() {});
      commentCaption = "";
      parentCommentId = "";
      _controller.text = "";
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
}

class forumReplyTile extends StatelessWidget {
  ForumsRepliesDataModel? model;
  forumReplyTile({Key? key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        leading: CachedNetworkImage(
            imageUrl: IMAGE_URL + model!.user!.profileImage.toString(),
            errorWidget: (error, context, url) => const Icon(Icons.person),
            placeholder: (context, url) => const Icon(Icons.person),
            imageBuilder: (context, url) {
              return CircleAvatar(
                backgroundImage: url,
              );
            }),
        title: Row(
          children: [
            customText(model!.user!.fullName.toString(), 14, white),
            Spacer(),
            customText(
                dataTimeTextFormater(model!.createdAt!.toString())["date"] +
                    " at " +
                    dataTimeTextFormater(model!.createdAt.toString())["time"],
                12,
                white24),
          ],
        ),
        subtitle: Padding(
            padding: EdgeInsets.only(top: 5),
            child: customText(model!.reply.toString(), 12, white)),
      ),
    );
  }
}
