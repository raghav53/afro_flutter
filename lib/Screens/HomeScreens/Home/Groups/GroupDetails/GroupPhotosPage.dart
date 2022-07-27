import 'package:afro/Model/Group/GroupDetails/GroupMedia/GroupMediaModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/VideoImageViewPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupDisscussionPhotosPage extends StatefulWidget {
  String groupdId = "";
  GroupDisscussionPhotosPage({Key? key, required this.groupdId})
      : super(key: key);

  @override
  State<GroupDisscussionPhotosPage> createState() =>
      _GroupDisscussionPhotosPageState();
}

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<GroupMediaModel>? _getGroupMedia;

class _GroupDisscussionPhotosPageState
    extends State<GroupDisscussionPhotosPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getGroupMedia = getGroupMediaFiles(context, widget.groupdId, "image");
      setState(() {});
      _getGroupMedia!.whenComplete(() => () {});
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
          future: _getGroupMedia,
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? GridView.count(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    crossAxisCount: 3,
                    children:
                        List.generate(snapshot.data!.data!.length, (index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideoImageViewPage(
                                      url: IMAGE_URL +
                                          snapshot.data!.data![index].path
                                              .toString(),
                                      type: 1)));
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          height: 200,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius: BorderRadius.circular(10)),
                          width: 70,
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
