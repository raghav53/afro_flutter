import 'package:afro/Model/Fourms/MyForumReplies/MyForumAllRepliesDataModel.dart';
import 'package:afro/Model/Fourms/MyForumReplies/MyForumAllRepliesModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/FourmDetailsPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';

import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

MyRepliesListPage(String profileImage, MyForumAllRepliesModel snapshot) {
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
                      fourmId: snapshot.data![index].form!.sId.toString())));
            },
            child: Column(
              children: [
                replyItem(profileImage,snapshot.data![index]),
                customHeightBox(4),
                customDivider(1, Colors.grey[300]!)
              ],
            ),
          );
        }),
  );
}

Widget replyItem(String profileImage,MyAllForumRepliesDataModel model) {
  return Container(
    padding: EdgeInsets.all(5),
    child: Row(children: [
      CachedNetworkImage(
          height: 50,
          width: 50,
          imageUrl: IMAGE_URL + profileImage.toString(),
          errorWidget: (error, context, url) => const Icon(Icons.person),
          placeholder: (context, url) => const Icon(Icons.person),
          imageBuilder: (context, url) {
            return CircleAvatar(
              backgroundImage: url,
            );
          }),
      customWidthBox(10),
      Column(
        crossAxisAlignment: cStart,
        children: [
          customText(model.reply.toString(), 15, white),
          customHeightBox(5),
          customText(
              dataTimeTextFormater(model.createdAt.toString())["date"] +
                  " at " +
                  dataTimeTextFormater(model.createdAt.toString())["time"],
              13,
              white24)
        ],
      )
    ]),
  );
}
