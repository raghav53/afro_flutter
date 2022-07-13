import 'package:afro/Model/Group/GroupDetails/GroupMedia/GroupMediaModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../Util/CustomWidget.dart';

class GroupDisscussionVideosPage extends StatefulWidget {
  String groupId = "";
  GroupDisscussionVideosPage({Key? key, required this.groupId})
      : super(key: key);

  @override
  State<GroupDisscussionVideosPage> createState() =>
      _GroupDisscussionVideosPageState();
}

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<GroupMediaModel>? _getEventMedia;

class _GroupDisscussionVideosPageState
    extends State<GroupDisscussionVideosPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getEventMedia = getGroupMediaFiles(context, widget.groupId, "video");
      setState(() {});
      _getEventMedia!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: 250,
      decoration:
          BoxDecoration(color: black, borderRadius: BorderRadius.circular(10)),
      child: FutureBuilder<GroupMediaModel>(
          future: _getEventMedia,
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? GridView.count(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    crossAxisCount: 3,
                    children:
                        List.generate(snapshot.data!.data!.length, (index) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: white,
                        ),
                        margin: EdgeInsets.all(10),
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                              IMAGE_URL +
                                  snapshot.data!.data![index].path.toString(),
                              fit: BoxFit.cover, loadingBuilder:
                                  (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          }),
                        ),
                      );
                    }))
                : Center(
                    child: customText("no media!", 15, white),
                  );
          }),
    );
  }
}
