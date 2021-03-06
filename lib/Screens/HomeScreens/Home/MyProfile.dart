import 'package:afro/Model/UserProfileModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/SignUpProcess/SelectInterest.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/AllMembers.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/BasicInformation.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/EducationPage.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/FollowerFollowing.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/VisitLocationsPage.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/SelectLanguage.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/WorkPage.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_codes/country_codes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProffile createState() => _MyProffile();
}

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

UserProfile userProfile = UserProfile();
String? userID;

class _MyProffile extends State<MyProfilePage> {
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

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getUserProfile = getUserProfileinfo(context, userID.toString());
      setState(() {});
      _getUserProfile!.whenComplete(() => () {});
    });
    getUserData();
    getCode();
  }

  getCode() async {
    await CountryCodes.init();
    Locale? deviceLocale = CountryCodes.getDeviceLocale();
    print(deviceLocale!.languageCode);
    print(deviceLocale.countryCode);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: commonAppbar("My Profile"),
        body: Container(
          padding: const EdgeInsets.only(top: 70),
          decoration: commonBoxDecoration(),
          height: phoneHeight(context),
          width: phoneWidth(context),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: blue, borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(left: 20, right: 20),
                      padding: EdgeInsets.all(10),
                      child: Row(
                        crossAxisAlignment: cStart,
                        children: [
                          //Profile Image
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: yellowColor),
                                borderRadius: BorderRadius.circular(50)),
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: CachedNetworkImage(
                                  imageUrl: IMAGE_URL + imageURl.toString(),
                                  errorWidget: (error, context, url) =>
                                      Icon(Icons.person),
                                  placeholder: (context, url) =>
                                      Icon(Icons.person),
                                  imageBuilder: (context, url) {
                                    return CircleAvatar(
                                      backgroundImage: url,
                                    );
                                  }),
                            ),
                          ),
                          customWidthBox(7),
                          //Basic Info,
                          Column(
                            crossAxisAlignment: cStart,
                            children: [
                              Row(
                                children: [
                                  customText(fullName.toString(), 15, white),
                                  customWidthBox(5),
                                  FutureBuilder<UserProfile>(
                                      future: _getUserProfile,
                                      builder: (context, snapshot) {
                                        return snapshot.hasData
                                            ? Row(
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
                                                        backgroundImage: url,
                                                      );
                                                    },
                                                  ),
                                                ],
                                              )
                                            : Container();
                                      })
                                ],
                              ),
                              customHeightBox(2),
                              customText("Newcorner Buddy", 11, white),
                              customHeightBox(2),
                              customText("Member since April 2022", 11, white),
                              customHeightBox(13),
                              customText('Bio', 15, white),
                              customHeightBox(3),
                              Container(
                                width: phoneWidth(context) / 1.5,
                                child: Text(
                                  bio.toString(),
                                  style: TextStyle(fontSize: 11, color: white),
                                ),
                              ),
                              customHeightBox(15),
                              customHeightBox(15),
                              //Following , Follower , Friends/Contacts
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowerFollowingPage()));
                                    },
                                    child: customText(
                                        "Following: " +
                                            totalFollowings.toString(),
                                        12,
                                        white),
                                  ),
                                  customWidthBox(30),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowerFollowingPage()));
                                    },
                                    child: customText(
                                        "Follower: " +
                                            totalFollowers.toString(),
                                        12,
                                        white),
                                  ),
                                  customWidthBox(30),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AllMembers()));
                                    },
                                    child: customText(
                                        "Contacts: " + totalContacts.toString(),
                                        12,
                                        white),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    customHeightBox(20),
                    Container(
                      child: Column(
                        crossAxisAlignment: cStart,
                        mainAxisAlignment: mStart,
                        children: [
                          customListItemButton(
                              "Basic Information",
                              "Update your basic account/profile data",
                              "basic",
                              context),
                          customDivider(10, Colors.white),
                          customHeightBox(20),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: customText("International Experience", 18,
                                Color(0xFFDFB48C)),
                          ),
                          customHeightBox(20),
                          customListItemButton(
                              "Place lived in",
                              "Have you moved to a new location",
                              "location",
                              context),
                          customDivider(10, Colors.white),
                          customListItemButton(
                              "Languages",
                              "Add/edit languages you speak",
                              "language",
                              context),
                          customDivider(10, Colors.white),
                          customHeightBox(20),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: customText(
                                "Choose your interests", 18, Color(0xFFDFB48C)),
                          ),
                          customHeightBox(20),
                          customListItemButton("Interests",
                              "Add/edit your interest", "interest", context),
                          customDivider(10, Colors.white),
                          customHeightBox(20),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: customText("Career", 18, Color(0xFFDFB48C)),
                          ),
                          customListItemButton("Work",
                              "Update your work history", "work", context),
                          customDivider(10, Colors.white),
                          customHeightBox(10),
                          customListItemButton(
                              "Education",
                              "Update your education background",
                              "education",
                              context),
                          customDivider(10, Colors.white),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//(done)
Widget customSocialMembers(BuildContext context) {
  return Container(
    margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              customText(totalFollowings.toString(), 15, white),
              customHeightBox(5),
              customText("Following", 15, white)
            ],
          ),
        ),
        Container(
          width: 1,
          color: Color(0x3dFFFFFF),
          height: 40,
        ),
        Column(
          children: [
            customText(totalFollowers.toString(), 15, white),
            customHeightBox(5),
            customText("Followers", 15, white)
          ],
        ),
        Container(
          width: 1,
          color: Color(0x3dFFFFFF),
          height: 40,
        ),
        GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              customText(totalContacts.toString(), 15, white),
              customHeightBox(5),
              customText("Members", 15, white)
            ],
          ),
        ),
      ],
    ),
  );
}

//Social Icons Links
Widget socialIconsLink() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(2)),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Image.asset(
              "assets/social/facebook.png",
            ),
          ),
        ),
      ),
      customWidthBox(10),
      InkWell(
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(2)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset("assets/social/instagram.png"),
          ),
        ),
      ),
      customWidthBox(10),
      InkWell(
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(2)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset("assets/social/twitter.png"),
          ),
        ),
      ),
      customWidthBox(10),
      InkWell(
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(2)),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              "assets/social/linkedin.png",
            ),
          ),
        ),
      )
    ],
  );
}

Widget customListItemButton(
    String title, String subTitle, String onClick, BuildContext context) {
  return InkWell(
    onTap: () {
      clickListeners(onClick, context);
    },
    child: Container(
      margin: EdgeInsets.only(top: 10, left: 20, bottom: 10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: cStart,
            children: [
              customText(title, 15, Colors.white),
              customHeightBox(5),
              customText(subTitle, 12, Color(0x3dFFFFFF)),
            ],
          ),
          Spacer(),
          IconButton(
              onPressed: () => {},
              icon: const Icon(
                Icons.arrow_forward_ios_outlined,
                color: Color(0xFFDFB48C),
              )),
        ],
      ),
    ),
  );
}

void clickListeners(String title, BuildContext context) {
  if (title == "basic") {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => BasicInformation()));
  } else if (title == "education") {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EducationPageScreen()));
  } else if (title == "work") {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => WorkPageScreen()));
  } else if (title == "location") {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LocationPageScreen()));
  } else if (title == "language") {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SelectLanguageScreenPage()));
  } else if (title == "interest") {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SelectIntrest()));
  }
}
