import 'package:afro/Model/Fourms/MyForumReplies/MyForumAllRepliesDataModel.dart';
import 'package:afro/Model/Fourms/MyForumReplies/MyForumAllRepliesModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRepliesPage extends StatefulWidget {
  MyRepliesPage({Key? key}) : super(key: key);

  @override
  State<MyRepliesPage> createState() => _MyRepliesPageState();
}

Future<MyForumAllRepliesModel>? _getAllMyForumReplies;
var userInfo = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class _MyRepliesPageState extends State<MyRepliesPage> {
  String? fullName = "", userId = "", profileImage = "";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getAllMyForumReplies = getUserAllForumsRepliesList(context);
      getUsersData();
      setState(() {});
      _getAllMyForumReplies!.whenComplete(() => () {});
    });
  }

  getUsersData() async {
    SharedPreferences sharedData = await _prefs;
    fullName = sharedData.getString(userInfo.fullName).toString();
    userId = sharedData.getString(userInfo.id);
    profileImage = sharedData.getString(userInfo.profileImage).toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MyForumAllRepliesModel>(
        future: _getAllMyForumReplies,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.data!.isNotEmpty
              ? Container(
                  margin: EdgeInsets.only(left: 15, right: 15),
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data!.data!.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            replyItem(snapshot.data!.data![index]),
                            customHeightBox(4),
                            customDivider(1, Colors.grey[300]!)
                          ],
                        );
                      }),
                )
              : Center(
                  child: customText("No data found!", 15, white),
                );
        });
  }

  Widget replyItem(MyAllForumRepliesDataModel model) {
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
}
