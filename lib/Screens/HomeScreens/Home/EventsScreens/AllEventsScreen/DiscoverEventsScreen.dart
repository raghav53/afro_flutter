import 'package:afro/Model/Events/Discover/DiscoverModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsDetailsPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DiscoverEventsScreen extends StatefulWidget {
  const DiscoverEventsScreen({Key? key}) : super(key: key);
  @override
  State<DiscoverEventsScreen> createState() => _DiscoverEventsScreenState();
}

UserDataConstants _user = UserDataConstants();
String searchEvent = "";
Future<DiscoverModel>? _getAllEvents;

class _DiscoverEventsScreenState extends State<DiscoverEventsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getAllEvents = getAllEventsUsers(context);
      setState(() {});
      _getAllEvents!.whenComplete(() => () {});
    });
  } 

  updateEventlist(String searchEvent) {
    Future.delayed(Duration.zero, () {
      _getAllEvents = getAllEventsUsers(context);
      setState(() {});
      _getAllEvents!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: phoneWidth(context),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: mCenter,
            children: [
              Flexible(
                  flex: 5,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(0, 2))
                        ]),
                    child: TextField(
                      onSubmitted: (value) {
                        setState(() {
                          updateEventlist(value.toString());
                        });
                      },
                      onChanged: (value) {},
                      textInputAction: TextInputAction.go,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFFDFB48C),
                          ),
                          hintText: "Search",
                          contentPadding: EdgeInsets.only(left: 15, top: 15),
                          hintStyle: TextStyle(color: Colors.white24)),
                    ),
                  )),
              customWidthBox(20),
              Flexible(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      //openBottomSheet();
                    },
                    child: Image.asset(
                      "assets/icons/fillter.png",
                      height: 20,
                      width: 20,
                    ),
                  )),
            ],
          ),
          customHeightBox(20),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            height: phoneHeight(context) / 1.6,
            child: FutureBuilder<DiscoverModel>(
                future: _getAllEvents,
                builder: (context, snapshot) {
                  return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                      ? ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.data!.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        EventDetailsScreenPage(
                                          eventId: snapshot
                                              .data!.data![index].sId
                                              .toString(),
                                          userId: snapshot
                                              .data!.data![index].userId,
                                        )));
                              },
                              child: Column(
                                mainAxisAlignment: mStart,
                                crossAxisAlignment: cStart,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: IMAGE_URL +
                                        snapshot.data!.data![index].coverImage
                                            .toString(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: phoneWidth(context),
                                      height: 150.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  customHeightBox(10),
                                  customText(
                                      snapshot.data!.data![index].title
                                          .toString(),
                                      12,
                                      Colors.white),
                                  customHeightBox(5),
                                  customText(
                                    snapshot.data!.data![index].totalInterested
                                            .toString() +
                                        " Interested",
                                    11,
                                    const Color(0xff7822A0),
                                  ),
                                  customHeightBox(5),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_pin,
                                        color: Color(0xFFDFB48C),
                                        size: 15,
                                      ),
                                      customWidthBox(5),
                                      customText(
                                          snapshot
                                              .data!.data![index].country!.title
                                              .toString(),
                                          12,
                                          Colors.white)
                                    ],
                                  ),
                                  customHeightBox(30)
                                ],
                              ),
                            );
                          })
                      : Center(
                          child: customText("Not data found....", 15, white),
                        );
                }),
          ),
        ],
      ),
    );
  }
}
