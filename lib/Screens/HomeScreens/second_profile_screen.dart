import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Model/Education.dart';
import '../../Model/UserInterestModel.dart';
import '../../Model/UserProfileModel.dart';
import '../../Model/second_profile_model.dart';
import '../../Network/Apis.dart';
import '../../Util/Colors.dart';
import '../../Util/CommonMethods.dart';
import '../../Util/CommonUI.dart';
import '../../Util/Constants.dart';
import '../../Util/CustomWidget.dart';
import 'package:http/http.dart' as http;
import '../../Util/CustomWidgetAttributes.dart';
import 'Home/MyProfile.dart';
import 'ProfileNavigationScreens/AllMembers.dart';
import 'ProfileNavigationScreens/FollowerFollowing.dart';

class SecondProfileScreen extends StatefulWidget {
  const SecondProfileScreen({Key? key}) : super(key: key);

  @override
  State<SecondProfileScreen> createState() => _SecondProfileScreenState();
}

class _SecondProfileScreenState extends State<SecondProfileScreen> {
  List<EducationModel>? getEducationLists;
  Map dataMap = {};

  Future<UserProfile>? _getUserProfile;
  String? fullName,
      imageURl,
      since,
      totalFollowers,
      totalFollowings,
      totalContacts,
      twitter,
      instagram,
      bio,
      website,
      facebook,
      linkdin;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  var user = UserDataConstants();

  getUserData() async {
    SharedPreferences sharedPreferences = await _prefs;
    fullName = sharedPreferences.getString(user.fullName);
    imageURl = sharedPreferences.getString(user.profileImage);
    totalFollowers = sharedPreferences.getString(user.totalFollowers);
    totalFollowings = sharedPreferences.getString(user.totalFollowings);
    totalContacts = sharedPreferences.getString(user.totalContacts);
    facebook = sharedPreferences.getString(user.facebook);
    twitter = sharedPreferences.getString(user.twitter);
    bio = sharedPreferences.getString(user.bio);
    instagram = sharedPreferences.getString(user.instagram);
    website = sharedPreferences.getString(user.website);
    linkdin = sharedPreferences.getString(user.linkdin);
    setState(() {});
  }

  SecondProfileApiModel? eventsList;
  List<Events> event = [];
  List<Experiences>? experiencesList;

  Country? countryList;

  List<Visits>? visitsList;

  UserInterestModel? userAllInterests;
  List<Languages>? languagesList = [];
  List<Interests>? interestedList = [];
  String? userID;

  @override
  void initState() {
    super.initState();
    getUsers();

    Future.delayed(Duration.zero, () {
      _getUserProfile = getUserProfileinfo(context, userID.toString());
      setState(() {});
      _getUserProfile!.whenComplete(() => () {});
      getEducation();
    });

    getUserData();
  }

  Future<void> getEducation() async {
    var mm = await getEducationList(null);
    getEducationLists = mm.data!;
    debugPrint("GET_LIST___" + getEducationLists.toString());
    /* setState(() {
   });*/
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: commonAppbar("Profile"),
        bottomNavigationBar: Material(
          elevation: 0,
          child: Container(
            height: 70,
            width: phoneWidth(context),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFF191732),
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 70,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: commonButtonLinearGridient,
              ),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.transparent,
                elevation: 0,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyProfilePage()));
                },
                label: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: white,
                        ),
                      ),
                      customText("Edit Profile", 16, white)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Container(
            padding: const EdgeInsets.only(
              top: 70,
            ),
            color: Color(0xFF191732),
            /*decoration: commonBoxDecoration(),*/
            height: phoneHeight(context),
            width: phoneWidth(context),
            child: FutureBuilder<UserProfile>(
              future: getUserProfileinfo(context, userID.toString()),
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Card(
                                    color: blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8),
                                      child: Row(
                                        crossAxisAlignment: cStart,
                                        children: [
                                          const Padding(
                                              padding: EdgeInsets.all(5)),
                                          //Profile Image
                                          InkWell(
                                            onTap: () {
                                              /* openBottomSheet();*/
                                            },
                                            child: Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: yellowColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: CachedNetworkImage(
                                                    imageUrl: IMAGE_URL +
                                                        snapshot.data!.data!
                                                            .profileImage
                                                            .toString(),
                                                    errorWidget:
                                                        (error, context, url) =>
                                                            const Icon(
                                                                Icons.person),
                                                    placeholder:
                                                        (context, url) =>
                                                            const Icon(
                                                                Icons.person),
                                                    imageBuilder:
                                                        (context, url) {
                                                      return CircleAvatar(
                                                        backgroundImage: url,
                                                      );
                                                    }),
                                              ),
                                            ),
                                          ),
                                          customWidthBox(7),
                                          //Basic Info,
                                          Column(
                                            crossAxisAlignment: cStart,
                                            children: [
                                              Row(
                                                children: [
                                                  customText(
                                                      fullName.toString(),
                                                      15,
                                                      white),
                                                  customWidthBox(5),
                                                  Row(
                                                    children: [
                                                      CachedNetworkImage(
                                                        height: 15,
                                                        width: 15,
                                                        imageUrl: country_code_url +
                                                            snapshot.data!.data!
                                                                .country!.iso2
                                                                .toString()
                                                                .toLowerCase() +
                                                            ".png",
                                                        imageBuilder:
                                                            (context, url) {
                                                          return CircleAvatar(
                                                            backgroundImage:
                                                                url,
                                                          );
                                                        },
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                        width: 150,
                                                        child: ListView.builder(
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: snapshot
                                                                .data!
                                                                .data!
                                                                .visits!
                                                                .length,
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            3),
                                                                child:
                                                                    CachedNetworkImage(
                                                                  height: 15,
                                                                  width: 15,
                                                                  imageUrl: country_code_url +
                                                                      snapshot
                                                                          .data!
                                                                          .data!
                                                                          .visits![
                                                                              index]
                                                                          .iso2
                                                                          .toString()
                                                                          .toLowerCase() +
                                                                      ".png",
                                                                  imageBuilder:
                                                                      (context,
                                                                          url) {
                                                                    return CircleAvatar(
                                                                      backgroundImage:
                                                                          url,
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            }),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                              customHeightBox(2),
                                              customText("Newcorner Buddy", 11,
                                                  Colors.white54),
                                              customHeightBox(2),
                                              customText(
                                                  "Member since April 2022",
                                                  11,
                                                  Colors.white54),
                                              customHeightBox(5),
                                              Row(
                                                children: [
                                                  (facebook ==
                                                          "https://www.facebook.com/")
                                                      ? const SizedBox()
                                                      : Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5),
                                                          alignment:
                                                              Alignment.center,
                                                          height: 30,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              color: const Color(
                                                                  0xFF191729),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: IconButton(
                                                              icon: Image.asset(
                                                                "assets/social/facebook.png",
                                                                color: Colors
                                                                    .white54,
                                                                height: 15,
                                                                width: 15,
                                                              ),
                                                              onPressed: () {
                                                                launchUrlLink(
                                                                    facebook
                                                                        .toString());
                                                              }),
                                                        ),
                                                  (instagram ==
                                                          "https://www.instagram.com/")
                                                      ? const SizedBox()
                                                      : Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 5),
                                                          alignment:
                                                              Alignment.center,
                                                          height: 30,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              color: const Color(
                                                                  0xFF191729),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: IconButton(
                                                              icon: Image.asset(
                                                                "assets/social/instagram.png",
                                                                color: Colors
                                                                    .white54,
                                                                height: 15,
                                                                width: 15,
                                                              ),
                                                              onPressed: () {
                                                                launchUrlLink(
                                                                    instagram
                                                                        .toString());
                                                              }),
                                                        ),
                                                  (twitter ==
                                                          "https://twitter.com/")
                                                      ? const SizedBox()
                                                      : Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5),
                                                          alignment:
                                                              Alignment.center,
                                                          height: 30,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              color: const Color(
                                                                  0xFF191729),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: IconButton(
                                                              icon: Image.asset(
                                                                "assets/social/twitter.png",
                                                                color: Colors
                                                                    .white54,
                                                                height: 15,
                                                                width: 15,
                                                              ),
                                                              onPressed: () {
                                                                launchUrlLink(
                                                                    twitter
                                                                        .toString());
                                                              }),
                                                        ),
                                                  (linkdin ==
                                                          "https://www.linkedin.com/")
                                                      ? const SizedBox()
                                                      : Container(
                                                          margin:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 5),
                                                          alignment:
                                                              Alignment.center,
                                                          height: 30,
                                                          width: 30,
                                                          decoration: BoxDecoration(
                                                              color: const Color(
                                                                  0xFF191729),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                          child: IconButton(
                                                              icon: Image.asset(
                                                                "assets/social/linkedin.png",
                                                                color: Colors
                                                                    .white54,
                                                                height: 15,
                                                                width: 15,
                                                              ),
                                                              onPressed: () {
                                                                launchUrlLink(
                                                                    linkdin
                                                                        .toString());
                                                              }),
                                                        ),
                                                ],
                                              ),
                                              customText('Bio', 14, white),
                                              customHeightBox(3),
                                              SizedBox(
                                                width:
                                                    phoneWidth(context) / 1.5,
                                                child: Text(
                                                  bio.toString(),
                                                  style: TextStyle(
                                                      fontSize: 11,
                                                      color: Colors.white54),
                                                ),
                                              ),
                                              customHeightBox(15),
                                              customHeightBox(15),
                                              //Following , Follower , Friends/Contacts
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const FollowerFollowingPage()));
                                                    },
                                                    child: customText(
                                                        "Following: " +
                                                            totalFollowings
                                                                .toString(),
                                                        10,
                                                        white),
                                                  ),
                                                  customWidthBox(15),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const FollowerFollowingPage()));
                                                    },
                                                    child: customText(
                                                        "Follower: " +
                                                            totalFollowers
                                                                .toString(),
                                                        10,
                                                        white),
                                                  ),
                                                  customWidthBox(15),
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const AllMembers()));
                                                    },
                                                    child: customText(
                                                        "Contacts: " +
                                                            totalContacts
                                                                .toString(),
                                                        10,
                                                        white),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ]),
                            const SizedBox(
                              height: 30,
                            ),
                            customText('Languages', 16, yellowColor),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 30,
                              child: ListView.builder(
                                  itemCount: languagesList!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (
                                    context,
                                    index,
                                  ) {
                                    return filterItemView(index);
                                  }),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            customText('Interests', 16, yellowColor),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 30,
                              child: ListView.builder(
                                  itemCount: interestedList!.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (
                                    context,
                                    index,
                                  ) {
                                    return filterInterestView(index);
                                  }),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            customText('Employment History', 16, yellowColor),
                            const SizedBox(
                              height: 10,
                            ),
                            (experiencesList != null)
                                ? ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: experiencesList!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Card(
                                        color: blue,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                height: 80,
                                                width: 60,
                                                child: ShaderMask(
                                                  shaderCallback:
                                                      (Rect bounds) =>
                                                          const LinearGradient(
                                                    colors: [
                                                      Color(0xff7822A0),
                                                      Color(0xff3958B0),
                                                    ],
                                                  ).createShader(bounds),
                                                  blendMode: BlendMode.srcATop,
                                                  child: Image.asset(
                                                    "assets/employees_bag.png",
                                                    height: 60,
                                                    width: 50,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  customText(
                                                      experiencesList![index]
                                                          .company
                                                          .toString(),
                                                      14,
                                                      Colors.white,
                                                      bold: 'yes'),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  customText(
                                                      experiencesList![index]
                                                          .position
                                                          .toString(),
                                                      12,
                                                      Colors.white),
                                                  const SizedBox(
                                                    height: 3,
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Image.asset(
                                                        "assets/location.png",
                                                        height: 15,
                                                        width: 15,
                                                      ),
                                                      customText(
                                                          experiencesList![
                                                                  index]
                                                              .location
                                                              .toString(),
                                                          12,
                                                          Colors.white),
                                                    ],
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      customText(
                                                          convertHistoryTimestamp(
                                                              experiencesList![
                                                                      index]
                                                                  .createdAt
                                                                  .toString()),
                                                          12,
                                                          Colors.white54),
                                                      const SizedBox(
                                                        width: 1,
                                                      ),
                                                      const Text(
                                                        "-",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white54),
                                                      ),
                                                      const SizedBox(
                                                        width: 1,
                                                      ),
                                                      customText(
                                                          convertHistoryTimestamp(
                                                              experiencesList![
                                                                      index]
                                                                  .updatedAt
                                                                  .toString()),
                                                          12,
                                                          Colors.white54)
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 30,
                            ),
                            customText('Education History', 16, yellowColor),
                            const SizedBox(
                              height: 10,
                            ),
                            if (getEducationLists != null)
                              ListView.builder(
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: getEducationLists!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    color: blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            height: 80,
                                            width: 60,
                                            child: ShaderMask(
                                              shaderCallback: (Rect bounds) =>
                                                  const LinearGradient(
                                                colors: [
                                                  Color(0xff7822A0),
                                                  Color(0xff3958B0),
                                                ],
                                              ).createShader(bounds),
                                              blendMode: BlendMode.srcATop,
                                              child: Image.asset(
                                                "assets/graduation_cap.png",
                                                height: 60,
                                                width: 50,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              customText(
                                                  getEducationLists![index]
                                                      .degree
                                                      .toString(),
                                                  14,
                                                  Colors.white,
                                                  bold: 'yes'),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              customText(
                                                  getEducationLists![index]
                                                      .institution
                                                      .toString(),
                                                  12,
                                                  Colors.white),
                                              const SizedBox(
                                                height: 3,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    "assets/graduation_cap.png",
                                                    height: 20,
                                                    width: 20,
                                                    color: yellowColor,
                                                  ),
                                                  customText(
                                                      getEducationLists![index]
                                                          .degree
                                                          .toString(),
                                                      12,
                                                      Colors.white),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  customText(
                                                      convertTimestamp(
                                                          getEducationLists![
                                                                  index]
                                                              .createdAt
                                                              .toString()),
                                                      12,
                                                      Colors.white54),
                                                  const SizedBox(
                                                    width: 1,
                                                  ),
                                                  const Text(
                                                    "-",
                                                    style: TextStyle(
                                                        color: Colors.white54),
                                                  ),
                                                  const SizedBox(
                                                    width: 1,
                                                  ),
                                                  customText(
                                                      convertTimestamp(
                                                          getEducationLists![
                                                                      index]
                                                                  .updatedAt
                                                                  .toString() +
                                                              "-"),
                                                      12,
                                                      Colors.white54)
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            const SizedBox(
                              height: 30,
                            ),
                            customText("Member Of Events", 16, yellowColor),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 30,
                              child: ListView.builder(
                                  itemCount: event.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (
                                    context,
                                    index,
                                  ) {
                                    return filterEventView(index);
                                  }),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            customText(
                                "International Experience", 16, yellowColor),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: customText("Place lived in", 12, white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Container(
                                height: 50,
                                width: 180,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: blue),
                                alignment: Alignment.center,
                                child: (countryList != null)
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Row(
                                          children: [
                                            CachedNetworkImage(
                                              height: 25,
                                              width: 20,
                                              imageUrl: country_code_url +
                                                  countryList!.iso2
                                                      .toString()
                                                      .toLowerCase() +
                                                  ".png",
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Flexible(
                                                child: customText(
                                                    countryList!.name
                                                        .toString(),
                                                    14,
                                                    white))
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ),
                            ),
                            (visitsList != null)
                                ? ListView.builder(
                                    padding: const EdgeInsets.all(0),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: visitsList!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Column(
                                        children: [
                                          Dash(
                                              direction: Axis.vertical,
                                              length: 100,
                                              dashGap: 5,
                                              dashThickness: 3,
                                              dashColor: yellowColor),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 50),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                customText(
                                                    visitsList![index]
                                                            .country
                                                            .toString() +
                                                        ",",
                                                    12,
                                                    Colors.white54),
                                                customText(
                                                    formatTimestamp(
                                                        visitsList![index]
                                                            .from
                                                            .toString()),
                                                    /*     visitsList![index]
                                                  .from
                                                  .toString(),*/
                                                    12,
                                                    Colors.white54),

                                                 CachedNetworkImage(
                                                  height: 30,
                                                  width: 30,
                                                  fit: BoxFit.fill,
                                                  imageUrl: country_code_url +
                                                      visitsList![index]
                                                          .iso2
                                                          .toString()
                                                          .toLowerCase() +
                                                      ".png",
                                                  imageBuilder:
                                                      (context, imageUrl) {
                                                    return CircleAvatar(
                                                      radius: 30,
                                                      backgroundImage: imageUrl,
                                                    );
                                                  },
                                                ),

                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                customText(
                                                    visitsList![index]
                                                        .city
                                                        .toString(),
                                                    12,
                                                    white),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      )
                    : const Center(
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: LoadingIndicator(
                              indicatorType: Indicator.ballClipRotate,
                              colors: [
                                Colors.white,
                                Colors.black,
                                Colors.yellow,
                              ],
                              strokeWidth: 1,
                              pathBackgroundColor: Colors.black),
                        ),
                      );
              },
            )),
      ),
    );
  }

  Widget filterItemView(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          gradient: commonButtonLinearGridient,
          borderRadius: BorderRadius.circular(20)),
      height: 15,
      width: 80,
      child: Center(
          child: (languagesList != null)
              ? customText(
                  languagesList![index].language!.title.toString(), 10, white)
              : const Text("")),
    );
  }

  Widget filterInterestView(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          gradient: commonButtonLinearGridient,
          borderRadius: BorderRadius.circular(20)),
      height: 15,
      width: 180,
      child: Center(
          child: (interestedList != null)
              ? customText(
                  interestedList![index].interest!.title.toString(), 10, white)
              : const Text("")),
    );
  }

  Widget filterEventView(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
          gradient: commonButtonLinearGridient,
          borderRadius: BorderRadius.circular(20)),
      height: 15,
      width: 180,
      child:
          Center(child: customText(event[index].title.toString(), 10, white)),
    );
  }

  Future<void> getUsers() async {
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    String userId = sharedPreferences.getString(user.id).toString();
    print(token);
    var jsonResponse = null;
    var response =
        await http.get(Uri.parse(BASE_URL + "user?user_id=$userId"), headers: {
      'api-key': API_KEY,
      'x-access-token': token,
    });
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    eventsList = SecondProfileApiModel.fromJson(jsonDecode(response.body));
    if (response.statusCode == 200) {
      event = eventsList!.data!.events!;
      experiencesList = eventsList!.data!.experiences;
      countryList = eventsList!.data!.country;
      visitsList = eventsList!.data!.visits;
      languagesList = eventsList!.data!.languages;
      interestedList = eventsList!.data!.interests;

      debugPrint("experiencee____" + experiencesList.toString());
      print("successededededed");
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      throw Exception("Unauthorized User!");
    } else {
      customToastMsg(message);
      throw Exception("Failed to load the work experience!");
    }
  }
}
