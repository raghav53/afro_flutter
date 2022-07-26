import 'package:afro/Model/Events/EventMedia/EventMediaModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/VideoViewPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class EventVideos extends StatefulWidget {
  String eventId = "";

  EventVideos({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventVideos> createState() => _EventVideosState();
}

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<EventMediaModel>? _getEventMedia;

class _EventVideosState extends State<EventVideos> {
  String? _thumbnailUrl;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getEventMedia = getMediaFiles(context, widget.eventId, "video");
      setState(() {});
      _getEventMedia!.whenComplete(() => () {});
    });
  }

  generateThumbnail(String path) async {
    return VideoThumbnail.thumbnailFile(
        video: path,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.WEBP);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      height: 250,
      decoration:
          BoxDecoration(color: black, borderRadius: BorderRadius.circular(10)),
      child: FutureBuilder<EventMediaModel>(
          future: _getEventMedia,
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? GridView.count(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.zero,
                    crossAxisCount: 3,
                    children:
                        List.generate(snapshot.data!.data!.length, (index) {
                      var thumbnailPath = generateThumbnail(
                          snapshot.data!.data![index].path.toString());
                      print("Thumbnail path:-$thumbnailPath");
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => VideoViewPage(
                                        videoUrl: snapshot
                                            .data!.data![index].path
                                            .toString(),
                                      )));
                        },
                        child: Container(
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
