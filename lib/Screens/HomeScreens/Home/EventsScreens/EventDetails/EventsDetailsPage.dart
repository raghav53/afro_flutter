import 'dart:convert';
import 'package:afro/Model/Events/AllUsersForEvent/AllEventUsersModel.dart';
import 'package:afro/Model/Events/EventDetails/EventModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsUserPage.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventPhotos.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventVideos.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsUsers/EventsContacts.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsDiscussion.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EventDetailsScreenPage extends StatefulWidget {
  String? eventId = "";
  String? userId = "";
  EventDetailsScreenPage(
      {Key? key, required this.eventId, required this.userId})
      : super(key: key);
  @override
  State<EventDetailsScreenPage> createState() => _EventDetailsScreenPageState();
}

Future<EventDetailModel>? _getEventDetails;
var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
var loginUserId = "";

//Get users for event
Future<AllEventUsersModel>? _getAllEventUsers;

class _EventDetailsScreenPageState extends State<EventDetailsScreenPage> {
  List<String> filterList = ["Discussion", "Photo", "Video", "Contacts"];
  List<String> filterListItemImages = [
    "assets/icons/menu_line.png",
    "assets/icons/camera.png",
    "assets/icons/video.png",
    "assets/icons/group.png",
  ];
  List<String> reportTypes = [
    "Spam",
    "Inpproprite content",
    "Sexually explicit content",
    "False profile",
    "This account may be compromised",
    "Other"
  ];

  var selectedIndex = 0;

  List<bool> selctionList = [true, false, false, false, false];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _getEventDetails = getEventDetails(context, widget.eventId.toString());
      getUserDetails();
      print(
          "Event Id:- ${widget.eventId} , User Id :- ${widget.userId}  , Login user Id :- ${loginUserId}");
      setState(() {});
      _getEventDetails!.whenComplete(() => () {});
    });
  }

  //Get the updated list of event
  getUpdatedDetails() {
    _getEventDetails = getEventDetails(context, widget.eventId.toString());
    setState(() {});
    _getEventDetails!.whenComplete(() => () {});
  }

  //Get user details
  getUserDetails() async {
    SharedPreferences sharedPreferences = await _prefs;
    loginUserId = sharedPreferences.getString(user.id).toString();
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Example share',
        text: 'Example share text',
        linkUrl: 'https://flutter.dev/',
        chooserTitle: 'Example Chooser Title');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: BackButton(),
          actions: [
            //Save button
            GestureDetector(
              onTap: () {},
              child: Image.asset(
                "assets/icons/save_icon.png",
                height: 30,
                width: 30,
              ),
            ),
            //Share button
            GestureDetector(
              onTap: () {
                setState(() {
                  share();
                });
              },
              child: Image.asset(
                "assets/icons/share_icon.png",
                height: 50,
                width: 50,
              ),
            ),
            //Show popmenu
            GestureDetector(
              onTapDown: (tapDownDetails) {
                loginUserId == widget.userId
                    ? showUserPopupMenu(tapDownDetails)
                    : showPopupMenu(tapDownDetails);
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.more_vert_outlined),
              ),
            )
          ],
        ),
        body: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            child: FutureBuilder<EventDetailModel>(
                future: _getEventDetails,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Column(
                          crossAxisAlignment: cStart,
                          children: [
                            //Image and other functionality
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                //Cover image
                                CachedNetworkImage(
                                  imageUrl: IMAGE_URL +
                                      snapshot.data!.data!.coverImage
                                          .toString(),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: phoneWidth(context),
                                    height: 200.0,
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
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 10, right: 10),
                                    child: Row(
                                      crossAxisAlignment: cEnd,
                                      mainAxisAlignment: mEnd,
                                      children: [
                                        //Going event button
                                        InkWell(
                                          onTap: () {
                                            showDialogBox(
                                                snapshot.data!.data!.sId
                                                    .toString(),
                                                context,
                                                "going",
                                                snapshot.data!.data!.isGoing);
                                            print(snapshot.data!.data!.isGoing
                                                .toString());
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                border: snapshot.data!.data!
                                                            .isGoing ==
                                                        1
                                                    ? null
                                                    : Border.all(
                                                        color: white, width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                gradient: snapshot.data!.data!
                                                            .isGoing ==
                                                        1
                                                    ? commonButtonLinearGridient
                                                    : null),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: Row(
                                                mainAxisAlignment: mCenter,
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/check_right_icon.png",
                                                    height: 15,
                                                    width: 15,
                                                  ),
                                                  customWidthBox(5),
                                                  customText(
                                                      "Going", 10, Colors.white)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        //Interested Event Button
                                        customWidthBox(15),
                                        InkWell(
                                          onTap: () {
                                            showDialogBox(
                                                snapshot.data!.data!.sId
                                                    .toString(),
                                                context,
                                                "interested",
                                                snapshot
                                                    .data!.data!.isInterested);
                                          },
                                          child: Container(
                                            height: 30,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                border: snapshot.data!.data!
                                                            .isInterested ==
                                                        1
                                                    ? null
                                                    : Border.all(
                                                        color: white, width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                gradient: snapshot.data!.data!
                                                            .isInterested ==
                                                        1
                                                    ? commonButtonLinearGridient
                                                    : null),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5, bottom: 5),
                                              child: Row(
                                                mainAxisAlignment: mCenter,
                                                children: [
                                                  Image.asset(
                                                    "assets/icons/star_icon.png",
                                                    height: 15,
                                                    width: 15,
                                                  ),
                                                  customWidthBox(5),
                                                  customText("Interested", 10,
                                                      Colors.white)
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            customHeightBox(20),
                            //1st
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                crossAxisAlignment: cStart,
                                mainAxisAlignment: mStart,
                                children: [
                                  Column(
                                    crossAxisAlignment: cStart,
                                    mainAxisAlignment: mStart,
                                    children: [
                                      //Event Title
                                      customText(
                                          snapshot.data!.data!.title.toString(),
                                          14,
                                          Colors.white),
                                      customHeightBox(10),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_view_week,
                                            color: Color(0xFFDFB48C),
                                            size: 20,
                                          ),
                                          customWidthBox(10),
                                          customText(
                                              dataTimeTextFormater(snapshot
                                                      .data!.data!.startDate
                                                      .toString())["date"] +
                                                  " , " +
                                                  dataTimeTextFormater(snapshot
                                                      .data!.data!.startDate
                                                      .toString())["time"] +
                                                  " to " +
                                                  dataTimeTextFormater(snapshot
                                                      .data!.data!.endDate
                                                      .toString())["date"] +
                                                  " , " +
                                                  dataTimeTextFormater(snapshot
                                                      .data!.data!.endDate
                                                      .toString())["time"],
                                              9,
                                              Colors.white)
                                        ],
                                      )
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 60,
                                    width: 66,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white,
                                            width: 1,
                                            style: BorderStyle.solid),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: customText(
                                          dayTimeTextFormater(snapshot
                                                  .data!.data!.startDate
                                                  .toString())["day"] +
                                              "\n" +
                                              dayTimeTextFormater(snapshot
                                                  .data!.data!.startDate
                                                  .toString())["date"] +
                                              "\n" +
                                              dayTimeTextFormater(snapshot
                                                  .data!.data!.startDate
                                                  .toString())["time"],
                                          12,
                                          Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            //2nd
                            customHeightBox(20),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: Row(
                                children: [
                                  //Country
                                  Container(
                                      child: snapshot.data!.data!.location
                                              .toString()
                                              .isEmpty
                                          ? Row(
                                              children: [
                                                Icon(
                                                  Icons.person,
                                                  color: yellowColor,
                                                ),
                                                customText(
                                                    snapshot.data!.data!.city
                                                        .toString(),
                                                    12,
                                                    white)
                                              ],
                                            )
                                          : null),
                                  //Hosted by
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: yellowColor,
                                      ),
                                      customText(
                                          "Hosted By : " +
                                              snapshot
                                                  .data!.data!.userId!.fullName
                                                  .toString(),
                                          12,
                                          white)
                                    ],
                                  ),
                                  customWidthBox(15),
                                  //Event Privacy
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/icons/world_grid.png",
                                        height: 17,
                                        width: 17,
                                        color: yellowColor,
                                      ),
                                      customWidthBox(5),
                                      customText(
                                          snapshot.data!.data!.privacy == 1
                                              ? "Public"
                                              : snapshot.data!.data!.privacy ==
                                                      2
                                                  ? "Closed"
                                                  : snapshot.data!.data!
                                                              .privacy ==
                                                          3
                                                      ? "Secret"
                                                      : "",
                                          12,
                                          white)
                                    ],
                                  )
                                ],
                              ),
                            ),
                            customHeightBox(20),

                            Padding(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Row(
                                children: [
                                  //Total going
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllEventUsersScreenPage(
                                                    title: "Going",
                                                    type: "0",
                                                    eventId: snapshot
                                                        .data!.data!.sId
                                                        .toString(),
                                                  )));
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/calendar.png",
                                          height: 20,
                                          width: 20,
                                        ),
                                        customWidthBox(5),
                                        customText(
                                            snapshot.data!.data!.totalGoing
                                                    .toString() +
                                                " Going",
                                            12,
                                            white),
                                      ],
                                    ),
                                  ),
                                  customWidthBox(70),
                                  //Total interested
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllEventUsersScreenPage(
                                                    title: "Interested",
                                                    type: "1",
                                                    eventId: snapshot
                                                        .data!.data!.sId,
                                                  )));
                                    },
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/icons/star_icon.png",
                                          height: 20,
                                          width: 20,
                                          color: yellowColor,
                                        ),
                                        customWidthBox(5),
                                        customText(
                                            snapshot.data!.data!.totalInterested
                                                    .toString() +
                                                " Interested",
                                            12,
                                            white)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            customHeightBox(20),
                            //Website link

                            customHeightBox(10),
                            Padding(
                              padding: const EdgeInsets.only(left: 13.0),
                              child: Column(
                                crossAxisAlignment: cStart,
                                children: [
                                  customText(
                                      "Informations & Tickets", 20, white,
                                      bold: "yes"),
                                  customHeightBox(10),
                                  Row(
                                    children: [
                                      Image.asset(
                                        "assets/icons/world_grid.png",
                                        height: 20,
                                        width: 20,
                                        color: yellowColor,
                                      ),
                                      customWidthBox(10),
                                      customText(
                                          snapshot.data!.data!.location
                                                  .toString()
                                                  .isEmpty
                                              ? "No Link available"
                                              : snapshot.data!.data!.location
                                                  .toString(),
                                          12,
                                          white),
                                      Spacer(),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 15,
                                              right: 15),
                                          decoration: BoxDecoration(
                                              gradient: snapshot
                                                      .data!.data!.location
                                                      .toString()
                                                      .isEmpty
                                                  ? null
                                                  : commonButtonLinearGridient,
                                              color: snapshot
                                                      .data!.data!.location
                                                      .toString()
                                                      .isEmpty
                                                  ? null
                                                  : white24,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child:
                                              customText("Ticket", 13, white),
                                        ),
                                      ),
                                      customWidthBox(10)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            customHeightBox(10),
                            customDivider(10, white),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, top: 10, bottom: 10),
                              child: customText(
                                  snapshot.data!.data!.about.toString(),
                                  14,
                                  white),
                            ),
                            customDivider(10, white),
                            customHeightBox(10),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 10, right: 10, top: 10, bottom: 10),
                              height: 25,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: filterList.length,
                                  itemBuilder: (context, index) {
                                    return filterItemView(
                                        filterList[index],
                                        index,
                                        filterListItemImages[index],
                                        selctionList[index]);
                                  }),
                            ),

                            customHeightBox(10),
                            selectedFilterView(selectedIndex,
                                snapshot.data!.data!.userId!.id.toString()),
                            customHeightBox(50)
                          ],
                        )
                      : Center(
                          child: customText(
                              "Details not available at this time!", 15, white),
                        );
                }),
          ),
        ),
      ),
    );
  }

  String getTime(int time) {
    print(DateTime.fromMillisecondsSinceEpoch(time).toString());
    return DateTime.fromMillisecondsSinceEpoch(time).toString();
  }

  //Fillter items
  Widget filterItemView(String title, int index, String image, bool selection) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        decoration: BoxDecoration(
            gradient:
                (selectedIndex == index) ? commonButtonLinearGridient : null,
            border: (selectedIndex == index)
                ? null
                : Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: [
            Image.asset(
              image,
              height: 12,
              width: 12,
            ),
            customWidthBox(5),
            customText(title, 12, white)
          ],
        ),
      ),
    );
  }

  selectedFilterView(int index, String userId) {
    String v = widget.eventId.toString();
    if (index == 0) {
      return EventDiscussionList(
        eventId: widget.eventId.toString(),
        //userId:userId
      );
    } else if (index == 1) {
      return EventPhotos(
        eventId: widget.eventId.toString(),
        //userId:userId
      );
    } else if (index == 2) {
      return EventVideos(
        eventId: widget.eventId.toString(),
        //userId:userId
      );
    } else if (index == 3) {
      return EventContacts(
        eventId: v,
        userId: userId,
      );
    }
  }

  //Show report popup if Login user and event created user is not same
  showPopupMenu(TapDownDetails details) async {
    var tapPosition = details.globalPosition;
    final RenderBox overlay =
        Overlay.of(context)?.context.findRenderObject() as RenderBox;
    await showMenu(
      color: Colors.transparent,
      context: context,
      position: RelativeRect.fromRect(
          tapPosition & const Size(40, 2), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        PopupMenuItem(
            padding: EdgeInsets.zero,
            child: InkWell(
              onTap: (() {
                Navigator.pop(context);
                //openReportOptionsDialog();
              }),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: black),
                child: Row(mainAxisAlignment: mAround, children: [
                  Image.asset(
                    "assets/icons/white_flag.png",
                    height: 15,
                    width: 15,
                  ),
                  customText("Report", 11, white)
                ]),
              ),
            )),
      ],
      elevation: 0.0,
    );
  }

  //Show  popup if Login user and event created user is same
  showUserPopupMenu(TapDownDetails details) async {
    var tapPosition = details.globalPosition;
    final RenderBox overlay =
        Overlay.of(context)?.context.findRenderObject() as RenderBox;
    await showMenu(
      color: Colors.transparent,
      context: context,
      position: RelativeRect.fromRect(
          tapPosition & const Size(30, 1.5), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //Delete Button
        PopupMenuItem(
            padding: EdgeInsets.zero,
            child: InkWell(
              onTap: (() {
                Navigator.pop(context);
                showEventDeleteDialogBox(widget.eventId.toString(), context);
              }),
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: black),
                child: Row(mainAxisAlignment: mCenter, children: [
                  Icon(
                    Icons.delete,
                    size: 15,
                    color: white,
                  ),
                  customWidthBox(10),
                  customText("Delete", 11, white)
                ]),
              ),
            )),

        //Invite Button
        PopupMenuItem(
            padding: EdgeInsets.zero,
            child: InkWell(
              onTap: (() {
                Navigator.pop(context);
                showAllInvitingUsers();
              }),
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: black),
                child: Row(mainAxisAlignment: mCenter, children: [
                  Image.asset(
                    "assets/icons/message.png",
                    height: 15,
                    width: 15,
                  ),
                  customWidthBox(10),
                  customText("Invite", 11, white)
                ]),
              ),
            )),
      ],
      elevation: 0.0,
    );
  }

  Widget cancelPostButton() {
    return Container(
      alignment: Alignment.center,
      width: 200,
      child: Row(
        mainAxisAlignment: mEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: commonButtonLinearGridient),
              child: customText("Send", 15, white),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: commonButtonLinearGridient),
              child: customText("Cancel", 15, white),
            ),
          )
        ],
      ),
    );
  }

  //Show Dialog Box
  void showDialogBox(
      String eventId, BuildContext context, String type, int? staus) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Container(
              height: 120,
              width: 200,
              decoration: BoxDecoration(
                  color: gray1, borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: cCenter,
                mainAxisAlignment: mCenter,
                children: [
                  customHeightBox(10),
                  customText("Afro United", 16, white),
                  customHeightBox(5),
                  staus == 1
                      ? customText(
                          "You are already " +
                              type.toString() +
                              " in this event!",
                          14,
                          white)
                      : customText(
                          type.toString() == "going"
                              ? "Are you Sure you are going this event?"
                              : "Are you interested in this event?",
                          14,
                          white),
                  customHeightBox(20),
                  staus == 1
                      ? InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: 100,
                            height: 30,
                            decoration: BoxDecoration(
                                gradient: commonButtonLinearGridient,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                              child: customText("Okay", 15, white),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: mCenter,
                          children: [
                            InkWell(
                              onTap: () {
                                if (type == "going") {
                                  goingEvent(eventId);
                                } else if (type == "interested") {}
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                    gradient: commonButtonLinearGridient,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: customText(
                                      type == "going" ? "Going" : "Interested",
                                      15,
                                      white),
                                ),
                              ),
                            ),
                            customWidthBox(30),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                    gradient: commonButtonLinearGridient,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: customText("Cancel", 15, white),
                                ),
                              ),
                            )
                          ],
                        )
                ],
              ),
            ),
          );
        });
  }

  //Delete event item alert box
  void showEventDeleteDialogBox(String eId, BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                  height: 120,
                  width: 200,
                  decoration: BoxDecoration(
                      color: gray1, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                      crossAxisAlignment: cCenter,
                      mainAxisAlignment: mCenter,
                      children: [
                        customHeightBox(10),
                        customText("Event Delete!", 16, white),
                        customHeightBox(5),
                        customText("Are you sure want to delete this event?",
                            15, white),
                        customHeightBox(20),
                        Row(
                          mainAxisAlignment: mCenter,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                deleteUserEvent(eId);
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                    gradient: commonButtonLinearGridient,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: customText("Delete", 15, white),
                                ),
                              ),
                            ),
                            customWidthBox(30),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: 100,
                                height: 30,
                                decoration: BoxDecoration(
                                    gradient: commonButtonLinearGridient,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: customText("Cancel", 15, white),
                                ),
                              ),
                            )
                          ],
                        ),
                        customHeightBox(10)
                      ])));
        });
  }

  // Going Event Api
  Future<void> goingEvent(String eventId) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    Map data = {"event_id": eventId, "is_going": "true"};
    print(token);
    var jsonResponse = null;
    var response = await http.post(Uri.parse(BASE_URL + "go_event"),
        headers: {
          'api-key': API_KEY,
          'x-access-token': token,
        },
        body: data);
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      print("Going event  api success");
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
      throw Exception("Failed to load the work experience!");
    }
  }

  // Interested Event Api
  Future<void> interestedEvent(String eventId) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    Map data = {"event_id": eventId, "is_going": true};
    print(token);
    var jsonResponse = null;
    var response = await http.post(Uri.parse(BASE_URL + "go_event"),
        headers: {
          'api-key': API_KEY,
          'x-access-token': token,
        },
        body: data);
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      print("Going event  api success");
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
      throw Exception("Failed to load the work experience!");
    }
  }

  //Delete user event
  Future<void> deleteUserEvent(String eventId) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    var jsonResponse = null;
    var response = await http.delete(
      Uri.parse(BASE_URL + "event/$eventId"),
      headers: {
        'api-key': API_KEY,
        'x-access-token': token,
      },
    );
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
      print("delete event  api success");
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
      throw Exception("Failed to load the work experience!");
    }
  }

  //Show Invites users list
  void showAllInvitingUsers() {
    getUsersForEvent();
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context1) {
          return StatefulBuilder(builder: (context, state) {
            return Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                child: Container(
                  height: 550,
                  width: phoneWidth(context1),
                  decoration: BoxDecoration(
                      color: gray1, borderRadius: BorderRadius.circular(10)),
                  child: FutureBuilder<AllEventUsersModel>(
                      future: _getAllEventUsers,
                      builder: (context, snapshot) {
                        return snapshot.hasData &&
                                snapshot.data!.data!.isNotEmpty
                            ? Column(
                                children: [
                                  customHeightBox(10),
                                  customText("Select", 15, white),
                                  customHeightBox(10),
                                  Container(
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    height: 500,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.data!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5),
                                          child: Row(
                                            children: [
                                              //Profile Image of user
                                              Stack(
                                                alignment:
                                                    Alignment.bottomRight,
                                                children: [
                                                  DottedBorder(
                                                    radius:
                                                        const Radius.circular(
                                                            2),
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    borderType:
                                                        BorderType.Circle,
                                                    color:
                                                        const Color(0xFF3E55AF),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1),
                                                      child: CachedNetworkImage(
                                                          imageUrl: IMAGE_URL +
                                                              snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .profileImage
                                                                  .toString(),
                                                          errorWidget: (error,
                                                                  context,
                                                                  url) =>
                                                              const Icon(
                                                                  Icons.person),
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Icon(
                                                                  Icons.person),
                                                          imageBuilder:
                                                              (context, url) {
                                                            return CircleAvatar(
                                                              backgroundImage:
                                                                  url,
                                                            );
                                                          }),
                                                    ),
                                                  ),
                                                  Container(
                                                    height: 9,
                                                    width: 9,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 3,
                                                            bottom: 3),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        gradient:
                                                            commonButtonLinearGridient),
                                                  )
                                                ],
                                              ),
                                              customWidthBox(10),
                                              //Name , Location
                                              Column(
                                                mainAxisAlignment: mStart,
                                                crossAxisAlignment: cStart,
                                                children: [
                                                  customText(
                                                      snapshot.data!
                                                          .data![index].fullName
                                                          .toString(),
                                                      12,
                                                      Colors.white),
                                                  customHeightBox(7),
                                                  Row(
                                                    children: [
                                                      const Icon(
                                                        Icons.location_pin,
                                                        color:
                                                            Color(0xFFDFB48C),
                                                        size: 15,
                                                      ),
                                                      customWidthBox(2),
                                                      customText(
                                                          snapshot
                                                              .data!
                                                              .data![index]
                                                              .city![0]
                                                              .title
                                                              .toString(),
                                                          12,
                                                          Color(0xFFDFB48C))
                                                    ],
                                                  )
                                                ],
                                              ),
                                              customWidthBox(10),
                                              Spacer(),
                                              //Invite button
                                              InkWell(
                                                onTap: () {
                                                  if (snapshot
                                                              .data!
                                                              .data![index]
                                                              .isEventInviteSent ==
                                                          0 &&
                                                      snapshot
                                                              .data!
                                                              .data![index]
                                                              .isGoing ==
                                                          0) {
                                                    sendInvitation(
                                                        widget.eventId
                                                            .toString(),
                                                        snapshot.data!
                                                            .data![index].sId
                                                            .toString(),
                                                        state);
                                                  } else {
                                                    showGoingInvitedDialog(snapshot
                                                                .data!
                                                                .data![index]
                                                                .isEventInviteSent ==
                                                            1
                                                        ? "invited"
                                                        : snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .isGoing ==
                                                                1
                                                            ? "going"
                                                            : "");
                                                  }

                                                  state(() {});
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 80,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8,
                                                          bottom: 8,
                                                          left: 10,
                                                          right: 10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .isEventInviteSent ==
                                                                  1 ||
                                                              snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .isGoing ==
                                                                  1
                                                          ? white24
                                                          : null,
                                                      gradient: snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .isEventInviteSent ==
                                                                  1 ||
                                                              snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .isGoing ==
                                                                  1
                                                          ? null
                                                          : commonButtonLinearGridient),
                                                  child: customText(
                                                      snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .isEventInviteSent ==
                                                              1
                                                          ? "Invited"
                                                          : snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .isGoing ==
                                                                  1
                                                              ? "Going"
                                                              : "Invite",
                                                      15,
                                                      white),
                                                ),
                                              ),
                                              customWidthBox(10),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )
                            : Center(
                                child: customText("No users!", 15, white),
                              );
                      }),
                ));
          });
        });
  }

  // Get All users for event
  getUsersForEvent() {
    Future.delayed(Duration.zero, () {
      _getAllEventUsers =
          getAllEventsUsers(context, widget.eventId.toString(), "1", "1000");
      setState(() {});
      _getAllEventUsers!.whenComplete(() => () {});
    });
  }

  //Send invitation to user
  Future<void> sendInvitation(
      String eId, String inviteUserId, StateSetter state) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    Map data = {"receiver_id": inviteUserId, "event_id": eId};
    print(token);
    var jsonResponse = null;
    var response = await http.post(Uri.parse(BASE_URL + "send_event_invite"),
        headers: {
          'api-key': API_KEY,
          'x-access-token': token,
        },
        body: data);
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      getUsersForEvent();
      state(() {});
      print("Send Event invitation api success");
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
      throw Exception("Failed to load the work experience!");
    }
  }

  //Show the alert dialog box is invation is already sent Or User is already going in this event
  showGoingInvitedDialog(String title) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                  padding: EdgeInsets.zero,
                  height: 120,
                  width: 200,
                  decoration: BoxDecoration(
                      color: gray1, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: cCenter,
                    mainAxisAlignment: mCenter,
                    children: [
                      customText(
                          title == "invited"
                              ? "User is already invited for this event!"
                              : "User is already going in this event",
                          15,
                          white),
                      customHeightBox(20),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: phoneWidth(context) / 3,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 20, right: 20),
                          decoration: BoxDecoration(
                              gradient: commonButtonLinearGridient,
                              borderRadius: BorderRadius.circular(20)),
                          child: customText("Okay", 15, white),
                        ),
                      )
                    ],
                  )));
        });
  }
}
