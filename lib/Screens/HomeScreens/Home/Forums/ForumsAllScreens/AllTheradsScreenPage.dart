import 'package:afro/Model/Fourms/AllFourmModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AllThreadsPageScreen extends StatefulWidget {
  AllThreadsPageScreen({Key? key}) : super(key: key);
  @override
  State<AllThreadsPageScreen> createState() => _AllThreadsPageScreenState();
}

Future<AllFourmModel>? _exploreForums;

class _AllThreadsPageScreenState extends State<AllThreadsPageScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _exploreForums = getAllFourmsList(context);
      setState(() {});
      _exploreForums!.whenComplete(() => () {});
    });
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
                      return Container(
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
                                            snapshot.data!.data![index].userId!
                                                .profileImage
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
                                            snapshot.data!.data![index].userId!
                                                .fullName
                                                .toString(),
                                            15,
                                            yellowColor),
                                        customHeightBox(10),
                                        customText(
                                            "Last Post: 04 Jul at 07:30 pm",
                                            15,
                                            yellowColor),
                                      ],
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
                                      // likeUnlike(model.sId.toString(), 1);
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
                                      customText(" Reply", 15, white)
                                    ],
                                  )
                                ],
                              )
                            ]),
                      );
                    })
                : Center(
                    child: customText("No forums found", 15, white),
                  );
          }),
    );
  }
}
