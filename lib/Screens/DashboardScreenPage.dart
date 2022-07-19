import 'dart:convert';
import 'package:afro/Model/Events/Discover/DiscoverModel.dart';
import 'package:afro/Model/Fourms/AllFourmDataModel.dart';
import 'package:afro/Model/Fourms/AllFourmModel.dart';
import 'package:afro/Model/Friends/AllUsers/GetAllUsers.dart';
import 'package:afro/Model/Group/AllGroupDataModel.dart';
import 'package:afro/Model/Group/AllGroupModel.dart';
import 'package:afro/Model/UserProfileModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Contacts/AllContactsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsDetailsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/FourmDetailsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupDetailsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/RecommendedGroupsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:http/http.dart' as http;
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/UpcomingEvents.dart';
import 'package:afro/Screens/HomeScreens/Home/MyProfile.dart';
import 'package:afro/Screens/HomeScreens/Home/NotificationScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/SearchOptionScreen.dart';
import 'package:afro/Screens/HomeScreens/SearchLocationScreen.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPageScreen extends StatefulWidget {
  const DashboardPageScreen({Key? key}) : super(key: key);
  @override
  _HomeScreen createState() => _HomeScreen();
}

var user = UserDataConstants();
Future<UserProfile>? _getUserProfile;
Future<DiscoverModel>? _upComingEvent;
Future<AllGroupsModel>? _allGroups;
Future<GetAllFriendsModel>? _exploreUsers;
Future<AllFourmModel>? _exploreForums;

class _HomeScreen extends State<DashboardPageScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? userID, profileImage, fullName, countryName, countryId;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getUserProfile = getUserProfileinfo(context, userID.toString());
      getUserData();
      setState(() {});
      _getUserProfile!.whenComplete(() => () {});
    });
    Future.delayed(Duration.zero, () {
      _upComingEvent = getAllEventsUsers(context, showProgress: false);
      setState(() {});
      _upComingEvent!.whenComplete(() => () {});
    });

    Future.delayed(Duration.zero, () {
      _allGroups = getAllGroups(context,
          showProgress: false, country: countryId.toString());
      setState(() {});
      _allGroups!.whenComplete(() => () {});
    });

    Future.delayed(Duration.zero, () {
      _exploreUsers = getAllUsers(context);
      setState(() {});
      _exploreUsers!.whenComplete(() => () {});
    });

    Future.delayed(Duration.zero, () {
      _exploreForums = getAllFourmsList(context);
      setState(() {});
      _exploreForums!.whenComplete(() => () {});
    });
  }

  onResumed() {
    Future.delayed(Duration.zero, () {
      _upComingEvent = getAllEventsUsers(context, showProgress: false);
      setState(() {});
      _upComingEvent!.whenComplete(() => () {});
    });

    Future.delayed(Duration.zero, () {
      _allGroups = getAllGroups(context,
          showProgress: false, country: countryId.toString());
      setState(() {});
      _allGroups!.whenComplete(() => () {});
    });

    Future.delayed(Duration.zero, () {
      _exploreUsers = getAllUsers(context, showProgress: false);
      setState(() {});
      _exploreUsers!.whenComplete(() => () {});
    });

    Future.delayed(Duration.zero, () {
      _exploreForums = getAllFourmsList(context);
      setState(() {});
      _exploreForums!.whenComplete(() => () {});
    });
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await _prefs;
    userID = sharedPreferences.getString(user.id).toString();
    profileImage = sharedPreferences.getString(user.profileImage).toString();
    fullName = sharedPreferences.getString(user.fullName).toString();
    countryName = sharedPreferences.getString(user.country);
    countryId = sharedPreferences.getString(user.countryId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        title: customText("Dashboard", 20, Colors.white),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchOptionScreen()));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NotificationScreenPage()));
              },
              icon: const Icon(
                Icons.notification_add,
                color: Colors.white,
              )),
          customWidthBox(10),
          InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyProfilePage()));
              },
              child: CachedNetworkImage(
                imageUrl: IMAGE_URL + profileImage!,
                placeholder: (context, url) => const CircleAvatar(
                    backgroundImage: AssetImage("tom_cruise.jpeg")),
                imageBuilder: (context, image) => CircleAvatar(
                  backgroundImage: image,
                ),
              )),
          customWidthBox(10),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: mStart,
            crossAxisAlignment: cStart,
            children: [
              customHeightBox(30),
              Text(
                "Hello " + fullName!,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              customHeightBox(10),
              //Change the location according user requirement
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SearchLocationScreen()));
                },
                child: Row(
                  children: [
                    customText("Let's explore what's happening nearby", 12,
                        Colors.white),
                    const Spacer(),
                    const Icon(
                      Icons.location_pin,
                      size: 20,
                    ),
                    customWidthBox(10),
                    customText(countryName!, 12, Colors.white)
                  ],
                ),
              ),
              customHeightBox(30),

              //UpComing Events
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpcomingEventsScreen()));
                },
                child: Row(
                  children: [
                    customText("Upcoming Events", 14, Colors.white),
                    Spacer(),
                    customText("See all", 12, Colors.white),
                    customWidthBox(10),
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: commonButtonLinearGridient),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
              customHeightBox(15),

              //Upcoming Events on dashboard
              FutureBuilder<DiscoverModel>(
                future: _upComingEvent,
                builder: (context, snapshot) {
                  return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                      ? Container(
                          height: 150,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.data!.length <= 5
                                  ? snapshot.data!.data!.length
                                  : 5,
                              itemBuilder: (context, index) {
                                DateTime datetime = DateTime.parse(snapshot
                                    .data!.data![index].startDate
                                    .toString());
                                String day = DateFormat("dd").format(datetime);
                                String month =
                                    DateFormat("MMM").format(datetime);
                                String city =
                                    snapshot.data!.data![index].city.toString();
                                String country = snapshot
                                    .data!.data![index].country!.title
                                    .toString();
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EventDetailsScreenPage(
                                                  eventId: snapshot
                                                      .data!.data![index].sId
                                                      .toString(),
                                                  userId: snapshot
                                                      .data!.data![index].userId
                                                      .toString(),
                                                )));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment: cStart,
                                      mainAxisAlignment: mStart,
                                      children: [
                                        Container(
                                          width: 100,
                                          height: 80,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Stack(children: [
                                            CachedNetworkImage(
                                              imageUrl: IMAGE_URL +
                                                  snapshot.data!.data![index]
                                                      .coverImage
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
                                                  const CircularProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                height: 35,
                                                width: 25,
                                                decoration: BoxDecoration(
                                                    gradient:
                                                        commonButtonLinearGridient,
                                                    borderRadius:
                                                        const BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    10),
                                                            bottomRight:
                                                                Radius.circular(
                                                                    10))),
                                                child: Center(
                                                    child: customText(
                                                        "$month\n$day",
                                                        10,
                                                        white)),
                                              ),
                                            ),
                                          ]),
                                        ),
                                        customHeightBox(5),
                                        Column(
                                          crossAxisAlignment: cStart,
                                          mainAxisAlignment: mStart,
                                          children: [
                                            customText(
                                                snapshot
                                                    .data!.data![index].title
                                                    .toString(),
                                                12,
                                                white),
                                            customText(
                                                snapshot.data!.data![index]
                                                        .totalInterested
                                                        .toString() +
                                                    " Interested",
                                                12,
                                                white),
                                            customHeightBox(3),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_pin,
                                                  color: yellowColor,
                                                  size: 15,
                                                ),
                                                customWidthBox(2),
                                                SizedBox(
                                                    width: 80,
                                                    child: Text(
                                                      city.isEmpty
                                                          ? country
                                                          : country.isEmpty
                                                              ? city
                                                              : city +
                                                                  " , " +
                                                                  country,
                                                      overflow:
                                                          TextOverflow.fade,
                                                      maxLines: 1,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                          color: white,
                                                          fontSize: 11),
                                                    ))
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Container();
                },
              ),
              customHeightBox(20),
              //Recommended Fourmss
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RecommendedGroups()));
                },
                child: Row(
                  children: [
                    customText("Recommended Fourms", 14, white),
                    Spacer(),
                    customText("See all", 12, white),
                    customWidthBox(10),
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: commonButtonLinearGridient),
                      child: Icon(
                        Icons.add,
                        color: white,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
              customHeightBox(10),
              FutureBuilder<AllFourmModel>(
                  future: _exploreForums,
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                        ? Container(
                            height: 320,
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: snapshot.data!.data!.length <= 2
                                    ? snapshot.data!.data!.length
                                    : 2,
                                itemBuilder: (context, index) {
                                  return Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: InkWell(
                                        onTap: () async {
                                          await Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      FourmDetailsPage(
                                                        fourmId: snapshot.data!
                                                            .data![index].sId
                                                            .toString(),
                                                      )));
                                        },
                                        child: fourmItem(
                                            snapshot.data!.data![index]),
                                      ));
                                }))
                        : Container();
                  }),

              customHeightBox(20),
              //Recommended Groups
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RecommendedGroups()));
                },
                child: Row(
                  children: [
                    customText("Recommended Groups", 14, white),
                    Spacer(),
                    customText("See all", 12, white),
                    customWidthBox(10),
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: commonButtonLinearGridient),
                      child: Icon(
                        Icons.add,
                        color: white,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
              customHeightBox(10),
              FutureBuilder<AllGroupsModel>(
                  future: _allGroups,
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                        ? Container(
                            height: 180,
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.data!.length <= 5
                                  ? snapshot.data!.data!.length
                                  : 5,
                              itemBuilder: (context, index) {
                                return groupListItem(
                                    snapshot.data!.data![index]);
                              },
                            ),
                          )
                        : Container();
                  }),

              //Explore contacts
              customHeightBox(20),
              InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AllContactsListScreen()));
                },
                child: Row(
                  children: [
                    customText("Explore Contacts", 14, Colors.white),
                    Spacer(),
                    customText("See all", 12, Colors.white),
                    customWidthBox(10),
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: commonButtonLinearGridient),
                      child: Icon(
                        Icons.add,
                        color: white,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
              customHeightBox(10),
              Container(
                  child: FutureBuilder<GetAllFriendsModel>(
                future: _exploreUsers,
                builder: (context, snapshot) {
                  return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                      ? Container(
                          height: 300,
                          child: ListView.builder(
                              padding: EdgeInsets.only(top: 10),
                              itemCount: snapshot.data!.data!.length <= 5
                                  ? snapshot.data!.data!.length
                                  : 5,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                OtherUserProfilePageScreen(
                                                  userID: snapshot
                                                      .data!.data![index].sId,
                                                  name: snapshot.data!
                                                      .data![index].fullName
                                                      .toString(),
                                                )))
                                        .then((value) => onResumed());
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
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
                                              Column(
                                                mainAxisAlignment: mStart,
                                                crossAxisAlignment: cStart,
                                                children: [
                                                  customText(
                                                      snapshot.data!
                                                          .data![index].fullName
                                                          .toString(),
                                                      12,
                                                      white),
                                                  customHeightBox(7),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.location_pin,
                                                        color: yellowColor,
                                                        size: 15,
                                                      ),
                                                      customWidthBox(2),
                                                      customText(
                                                          snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .city![0]
                                                                  .title
                                                                  .toString() +
                                                              " , " +
                                                              snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .country![0]
                                                                  .title
                                                                  .toString(),
                                                          12,
                                                          yellowColor)
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          customHeightBox(10),
                                          customDivider(5, white)
                                        ],
                                      )),
                                );
                              }),
                        )
                      : Container();
                },
              )),
            ],
          ),
        ),
      ),
    ));
  }

  //Group item
  Widget groupListItem(AllGroupsDataModel model) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => GroupDetailsPage(
                      groupId: model.sId.toString(),
                      groupAdmin: model.userId.toString(),
                    )))
            .then((value) => {onResumed()});
      },
      child: Container(
        height: 200,
        width: 200,
        margin: const EdgeInsets.only(right: 10),
        child: Column(
          crossAxisAlignment: cStart,
          children: [
            Container(
              height: 150,
              child: CachedNetworkImage(
                imageUrl: IMAGE_URL + model.coverImage.toString(),
                imageBuilder: (context, imageProvider) => Container(
                  width: phoneWidth(context),
                  height: 150.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image:
                        DecorationImage(image: imageProvider, fit: BoxFit.fill),
                  ),
                ),
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            customHeightBox(5),
            customText(model.title.toString(), 12, white)
          ],
        ),
      ),
    );
  }

  //Fourm Item
  Widget fourmItem(AllFourmDataModel model) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: gray1, width: 1)),
      padding: EdgeInsets.only(top: 5, bottom: 5),
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
                      imageUrl:
                          IMAGE_URL + model.userId!.profileImage.toString(),
                      errorWidget: (error, context, url) => Icon(Icons.person),
                      placeholder: (context, url) => Icon(Icons.person),
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
                          model.userId!.fullName.toString(), 15, yellowColor),
                      customHeightBox(10),
                      customText(
                          "Last Post: 04 Jul at 07:30 pm", 15, yellowColor),
                    ],
                  )
                ],
              ),
            ),
            customHeightBox(10),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: customText(model.title.toString(), 15, white),
            ),
            customHeightBox(10),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: customText(model.question.toString(), 15, white),
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
                    likeUnlike(model.sId.toString(), 1);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_up_outlined,
                        color: model.isLike == 1 ? Colors.blueAccent : white,
                        size: 19,
                      ),
                      customWidthBox(3),
                      customText(
                          model.totalLikes.toString() + " Upvote", 15, white)
                    ],
                  ),
                ),

                //Downvote
                InkWell(
                  onTap: () {
                    likeUnlike(model.sId.toString(), 2);
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.thumb_down_outlined,
                        color: model.isDislike == 1 ? Colors.blueAccent : white,
                        size: 19,
                      ),
                      customWidthBox(3),
                      customText(model.totalDislikes.toString() + " Downvote",
                          15, white)
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
                    customText(
                        model.totalReplies.toString() + " Reply", 15, white)
                  ],
                )
              ],
            )
          ]),
    );
  }

  //Like/Unlike the fourm thread
  Future<void> likeUnlike(String id, int type) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    print(token);
    var jsonResponse = null;
    Map data = {
      "type": type == 1
          ? "Like"
          : type == 2
              ? "Dislike"
              : "",
      "form_id": id
    };
    var response = await http.post(Uri.parse(BASE_URL + "form_like"),
        headers: {
          'api-key': API_KEY,
          'x-access-token': token,
        },
        body: data);
    Navigator.pop(context);
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      print(message);
      print("fourm like/dislike api success");
      refershFourmData();
      setState(() {});
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      customToastMsg(message);
      throw Exception("Failed to load the work experience!");
    }
  }

  refershFourmData() {
    Future.delayed(Duration.zero, () {
      _exploreForums = getAllFourmsList(context, isShow: false);
      setState(() {});
      _exploreForums!.whenComplete(() => () {});
    });
  }
}
