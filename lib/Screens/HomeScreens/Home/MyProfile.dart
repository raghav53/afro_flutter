import 'package:afro/Model/UserProfileModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/SignUpProcess/SelectInterest.dart';
import 'package:afro/Util/Colors.dart';
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
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProffile createState() => _MyProffile();
}

String? fullName,
    imageURl,
    since,
    totalFollowers,
    totalFollowings,
    totalContacts;

//Social links
String? twitter, instagram, website, facebook, linkdin;
UserProfile userProfile = UserProfile();

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
    instagram = sharedPreferences.getString(user.instagram);
    website = sharedPreferences.getString(user.website);
    linkdin = sharedPreferences.getString(user.linkdin);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserData();
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
                      child: Stack(alignment: Alignment.bottomRight, children: [
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: red,
                                width: 1.0,
                              ),
                              shape: BoxShape.circle,
                            ),
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(5),
                            child: CachedNetworkImage(
                              imageUrl: IMAGE_URL + imageURl.toString(),
                              placeholder: (context, url) => const CircleAvatar(
                                  backgroundImage:
                                      AssetImage("tom_cruise.jpeg")),
                              imageBuilder: (context, image) => CircleAvatar(
                                backgroundImage: image,
                              ),
                            )),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                                gradient: commonButtonLinearGridient,
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Image.asset(
                              "assets/icons/camera.png",
                            ),
                          ),
                        )
                      ]),
                    ),
                    customHeightBox(10),
                    customText(fullName.toString(), 15, Colors.white),
                    customHeightBox(10),
                    customText(
                        "Member since 2020", 15, const Color(0x3dFFFFFF)),
                    customHeightBox(10),
                    socialIconsLink(),
                    //Follwers/Following/Members
                    customSocialMembers(context),
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
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FollowerFollowingPage()));
          },
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
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AllMembers()));
          },
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
