import 'package:afro/Model/Events/Discover/DiscoverModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsDetailsPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UpcomingEventsScreen extends StatefulWidget {
  _UpcomingEvent createState() => _UpcomingEvent();
}

UserDataConstants _user = UserDataConstants();
String searchEvent = "";
Future<DiscoverModel>? _upComingEvent;

class _UpcomingEvent extends State<UpcomingEventsScreen> {
  int clickPosition = 0;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _upComingEvent = getAllEventsUsers(context);
      setState(() {});
      _upComingEvent!.whenComplete(() => () {});
    });
  }

  updateEventlist(String searchEvent) {
    Future.delayed(Duration.zero, () {
      _upComingEvent = getAllEventsUsers(context);
      setState(() {});
      _upComingEvent!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: commonAppbar("Upcoming Events"),
      body: Container(
        padding: EdgeInsets.only(top: 80),
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: mCenter,
              children: [
                Flexible(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(color: Colors.black, offset: Offset(0, 2))
                          ]),
                      child: const TextField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        decoration: InputDecoration(
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
                        openBottomSheet(context);
                      },
                      child: Image.asset(
                        "assets/icons/fillter.png",
                        height: 20,
                        width: 20,
                      ),
                    )),
              ],
            ),
            customHeightBox(25),
            Container(
              height: phoneHeight(context) / 1.3,
              child: FutureBuilder<DiscoverModel>(
                  future: _upComingEvent,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: snapshot.data!.data!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EventDetailsScreenPage(
                                                  eventId: snapshot
                                                      .data!.data![index].sId
                                                      .toString(),
                                                  userId: snapshot.data!
                                                      .data![index].userId)));
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, right: 20),
                                  child: Column(
                                    mainAxisAlignment: mStart,
                                    crossAxisAlignment: cStart,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: IMAGE_URL +
                                            snapshot
                                                .data!.data![index].coverImage
                                                .toString(),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: phoneWidth(context),
                                          height: 150.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                        snapshot.data!.data![index].isInterested
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
                                              snapshot.data!.data![index].city
                                                  .toString(),
                                              12,
                                              Colors.white)
                                        ],
                                      ),
                                      customHeightBox(30)
                                    ],
                                  ),
                                ),
                              );
                            })
                        : Center(
                            child: customText("No events found!", 15, white),
                          );
                  }),
            )
          ],
        ),
      ),
    ));
  }

  //open fillter bottom sheet
  List<String> filterList = ["Interests", "Member", "Clear All"];
  var selectedIndex = 0;
  var selectedRange = const RangeValues(0, 500);
  int _startRange = 0;
  int _endRange = 500;

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: commonBoxDecoration(),
              child: Column(
                children: [
                  customHeightBox(15),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: mBetween,
                      children: [
                        customText(
                            "Filter & Sort", 12, const Color(0xFFDFB48C)),
                        customText(filterList[selectedIndex], 12,
                            const Color(0xFFDFB48C)),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            state(() {
                              selectedIndex = 0;
                              _startRange = 0;
                              _endRange = 500;
                              selectedRange = RangeValues(0, 500);
                            });
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                  customDivider(5, Colors.white),
                  Row(
                    crossAxisAlignment: cStart,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 15),
                        child: Column(
                          mainAxisAlignment: mStart,
                          crossAxisAlignment: cStart,
                          children: [
                            Container(
                              height: 200,
                              width: 100,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: filterList.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        state(() {
                                          selectedIndex = index;
                                          filterList[selectedIndex] ==
                                                  "Clear All"
                                              ? {
                                                  selectedIndex = 0,
                                                  _startRange = 0,
                                                  _endRange = 500,
                                                  Navigator.pop(context)
                                                }
                                              : null;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            bottom: 20, left: 10),
                                        width: 50,
                                        decoration: BoxDecoration(
                                            gradient: selectedIndex == index
                                                ? commonButtonLinearGridient
                                                : null,
                                            border: selectedIndex == index
                                                ? null
                                                : Border.all(
                                                    color: Colors.white,
                                                    width: 1,
                                                    style: BorderStyle.solid),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Center(
                                            child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          child: customText(filterList[index],
                                              12, Colors.white),
                                        )),
                                      ),
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      customWidthBox(20),
                      SizedBox(
                        width: 0.5,
                        height: MediaQuery.of(context).size.height * 0.67,
                        child: Container(color: const Color(0x3DFFFFFF)),
                      ),
                      selectedIndex == 0
                          ? interestSelectionWidget()
                          : Container(
                              margin: const EdgeInsets.only(
                                  top: 15, left: 10, right: 10),
                              width: 270,
                              child: Column(
                                mainAxisAlignment: mCenter,
                                crossAxisAlignment: cCenter,
                                children: [
                                  RangeSlider(
                                    activeColor: yellowColor,
                                    inactiveColor: white,
                                    min: 0,
                                    max: 500,
                                    values: selectedRange,
                                    onChanged: (RangeValues newValue) {
                                      state(() {
                                        selectedRange = newValue;
                                        _startRange = newValue.start.toInt();
                                        _endRange = newValue.end.toInt();
                                      });
                                    },
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 11),
                                    child: Row(
                                      children: [
                                        customText(
                                            "min " + _startRange.toString(),
                                            15,
                                            white),
                                        Spacer(),
                                        customText(
                                            "max " + _endRange.toString(),
                                            15,
                                            white)
                                      ],
                                    ),
                                  )
                                ],
                              ))
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  Widget interestSelectionWidget() {
    return Column(
      mainAxisAlignment: mCenter,
      crossAxisAlignment: cCenter,
      children: [
        Center(
          child: Container(
            height: 40,
            width: 270,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.black),
            margin: const EdgeInsets.only(top: 15, left: 10, right: 10),
            child: const TextField(
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 14, color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 15, left: 15),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFFDFB48C),
                  ),
                )),
          ),
        ),
        customHeightBox(10),
        SingleChildScrollView(
          child: Container(
              height: 470,
              width: 282,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: 5, bottom: 5, left: 15, right: 15),
                          child: Row(
                            children: [
                              customText("Hello World", 15, white),
                              Spacer(),
                              Checkbox(value: false, onChanged: (value) {})
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 0.2,
                          width: 282,
                          child: Container(color: white),
                        )
                      ]),
                    );
                  })),
        ),
        Container(
          padding: EdgeInsets.only(left: 50, right: 50, top: 7, bottom: 7),
          decoration: BoxDecoration(
              gradient: commonButtonLinearGridient,
              borderRadius: BorderRadius.circular(30)),
          child: Center(child: customText("Done", 15, white)),
        )
      ],
    );
  }
}
