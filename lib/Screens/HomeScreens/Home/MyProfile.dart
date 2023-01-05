import 'dart:io';

import 'package:afro/Model/UserProfileModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/SignUpProcess/SelectInterest.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:http/http.dart' as http;
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
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
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
var profileImage = null;

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
  }

  refresh() {
    Future.delayed(Duration.zero, () {
      _getUserProfile = getUserProfileinfo(context, userID.toString());
      setState(() {});
      _getUserProfile!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          extendBodyBehindAppBar: true,
          resizeToAvoidBottomInset: false,
          appBar: commonAppbar("Edit Profile"),
          body: Container(
              padding: const EdgeInsets.only(top: 70),
              decoration: commonBoxDecoration(),
              height: phoneHeight(context),
              width: phoneWidth(context),
              child: FutureBuilder<UserProfile>(
                future: getUserProfileinfo(context, userID.toString()),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? SingleChildScrollView(
                          child: Column(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [

                              Card(
                                color: blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                /*decoration: BoxDecoration(
                                    color: blue,
                                    borderRadius: BorderRadius.circular(10)),*/
                                margin: const EdgeInsets.only(left: 20, right: 20),
                                /*padding: const EdgeInsets.all(10),*/
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 8,bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: cStart,
                                    children: [
                 const Padding(padding: EdgeInsets.all(5)),
                                      //Profile Image
                                      InkWell(
                                        onTap: () {
                                          openBottomSheet();
                                        },
                                        child: Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            Container(
                                              height: 60,
                                              width: 60,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1,
                                                      color: yellowColor),
                                                  borderRadius:
                                                      BorderRadius.circular(50)),
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
                                                            const Icon(Icons.person),
                                                    placeholder: (context, url) =>
                                                        const Icon(Icons.person),
                                                    imageBuilder: (context, url) {
                                                      return CircleAvatar(
                                                        backgroundImage: url,
                                                      );
                                                    }),
                                              ),
                                            ),
                                            Align(
                                                child: CircleAvatar(
                                              radius: 10,
                                              backgroundColor: yellowColor,
                                              child: Icon(
                                                Icons.edit,
                                                color: black,
                                                size: 15,
                                              ),
                                            ))
                                          ],
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
                                                  fullName.toString(), 15, white),
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
                                                    imageBuilder: (context, url) {
                                                      return CircleAvatar(
                                                        backgroundImage: url,
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                    width: 150,
                                                    child: ListView.builder(
                                                        shrinkWrap: true,
                                                        itemCount: snapshot.data!
                                                            .data!.visits!.length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 3),
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
                                                                  (context, url) {
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
                                          customText(
                                              "Newcorner Buddy", 11, Colors.white54),
                                          customHeightBox(2),
                                          customText("Member since April 2022",
                                              11, Colors.white54),
                                          Row(
                                            children: [
                                              (facebook ==
                                                  "https://www.facebook.com/")
                                                  ? const SizedBox()
                                                  : Container(
                                                margin: const EdgeInsets.only(right: 5),
                                                alignment: Alignment.center,
                                                height: 30,
                                                width: 30,
                                                decoration:  BoxDecoration(
                                                    color: const Color(0xFF191729),
                                                    borderRadius: BorderRadius.circular(8)
                                                ),
                                                child: IconButton(
                                                    icon: Image.asset(
                                                      "assets/social/facebook.png",

                                                      color:
                                                      Colors.white54,
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
                                                margin: EdgeInsets.only(right: 5),
                                                alignment: Alignment.center,
                                                height: 30,
                                                width: 30,
                                                decoration:  BoxDecoration(
                                                    color: const Color(0xFF191729),
                                                    borderRadius: BorderRadius.circular(8)
                                                ),
                                                child: IconButton(
                                                    icon: Image.asset(
                                                      "assets/social/instagram.png",
                                                      color:
                                                      Colors.white54,
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
                                                margin: const EdgeInsets.only(right: 5),
                                                alignment: Alignment.center,
                                                height: 30,
                                                width: 30,
                                                decoration:  BoxDecoration(
                                                    color: const Color(0xFF191729),
                                                    borderRadius: BorderRadius.circular(8)
                                                ),
                                                child: IconButton(
                                                    icon: Image.asset(
                                                      "assets/social/twitter.png",
                                                      color:
                                                      Colors.white54,
                                                      height: 15,
                                                      width: 15,
                                                    ),
                                                    onPressed: () {
                                                      launchUrlLink(twitter
                                                          .toString());
                                                    }),
                                              ),
                                              (linkdin ==
                                                  "https://www.linkedin.com/")
                                                  ? const SizedBox()
                                                  : Container(
                                                margin: const EdgeInsets.only(right: 5),
                                                alignment: Alignment.center,
                                                height: 30,
                                                width: 30,
                                                decoration:  BoxDecoration(
                                                    color: const Color(0xFF191729),
                                                    borderRadius: BorderRadius.circular(8)
                                                ),
                                                child: IconButton(
                                                    icon: Image.asset(
                                                      "assets/social/linkedin.png",
                                                      color:
                                                      Colors.white54,
                                                      height: 15,
                                                      width: 15,
                                                    ),
                                                    onPressed: () {
                                                      launchUrlLink(linkdin
                                                          .toString());
                                                    }),
                                              ),
                                            ],
                                          ),
                                          customText('Bio', 15, white),
                                          customHeightBox(3),
                                          SizedBox(
                                            width: phoneWidth(context) / 1.5,
                                            child: Text(
                                              bio.toString(),
                                              style: const TextStyle(
                                                  fontSize: 11, color: Colors.white54),
                                            ),
                                          ),
                                          customHeightBox(15),
                                          customHeightBox(15),
                                          //Following , Follower , Friends/Contacts
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
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
                                                    12,
                                                    white),
                                              ),
                                              customWidthBox(15),
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
                                              customWidthBox(15),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AllMembers()));
                                                },
                                                child: Flexible(
                                                  child: customText(
                                                      "Contacts: " +
                                                          totalContacts.toString(),
                                                      12,
                                                      white),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              customHeightBox(20),
                              Column(
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
                                    padding: const EdgeInsets.only(left: 15),
                                    child: customText(
                                        "International Experience",
                                        14,
                                        const Color(0xFFDFB48C)),
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
                                    padding: const EdgeInsets.only(left: 15),
                                    child: customText("Choose your interests",
                                        18, const Color(0xFFDFB48C)),
                                  ),
                                  customHeightBox(20),
                                  customListItemButton(
                                      "Interests",
                                      "Add/edit your interest",
                                      "interest",
                                      context),
                                  customDivider(10, Colors.white),
                                  customHeightBox(20),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: customText(
                                        "Career", 18, const Color(0xFFDFB48C)),
                                  ),
                                  customListItemButton(
                                      "Work",
                                      "Update your work history",
                                      "work",
                                      context),
                                  customDivider(10, Colors.white),
                                  customHeightBox(10),
                                  customListItemButton(
                                      "Education",
                                      "Update your education background",
                                      "education",
                                      context),
                                  customDivider(10, Colors.white),
                                ],
                              )
                            ],
                          )
                        ]))
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
              ))),
    );
  }

  //image selection(camera and gallery)
  openBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: black,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: mCenter,
                crossAxisAlignment: cCenter,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      open("camera");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: white, width: 1),
                            borderRadius: BorderRadius.circular(50)),
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          Icons.camera,
                          color: white,
                          size: 35,
                        )),
                  ),
                  customWidthBox(50),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      open("gallery");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: white, width: 1),
                            borderRadius: BorderRadius.circular(50)),
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          Icons.photo_library,
                          color: white,
                          size: 35,
                        )),
                  )
                ],
              ),
            );
          });
        });
  }

  open(String type) {
    if (type.contains("camera")) {
      pickImage(ImageSource.camera);
    } else if (type.contains("gallery")) {
      pickImage(ImageSource.gallery);
    }
  }

  //Pick image
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      if (!mounted) return;
      uploadProfileImage(imageTemp.path);
      print(imageTemp.toString());
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //Upload user profile image
  Future<void> uploadProfileImage(String path) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var request = http.MultipartRequest(
        'POST', Uri.parse(BASE_URL + "user_profile_image"));
    request.files.add(await http.MultipartFile.fromPath(
        'profile_image', File(path.toString()).path));
    request.headers.addAll({'api-key': API_KEY, 'x-access-token': token!});
    var res = await request.send();
    debugPrint("res.statusCode ${res.statusCode}");
    if (res.statusCode == 200) {
      getUserData();
      setState(() {});
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      customToastMsg("Something gone wrong...");
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
            color: const Color(0x3dFFFFFF),
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
            color: const Color(0x3dFFFFFF),
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
  Widget customListItemButton(
      String title, String subTitle, String onClick, BuildContext context) {
    return InkWell(
      onTap: () {
        clickListeners(onClick, context);
      },
      child: ListTile(
        title: customText(title, 14, Colors.white),
        subtitle: customText(subTitle, 12, Color(0x3dFFFFFF)),
        trailing: const Icon(
      Icons.edit,
      color: Color(0xFFDFB48C),
        ),
      ),
    );
  }

  //Navigation
  void clickListeners(String title, BuildContext context) {
    if (title == "basic") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const BasicInformation()))
          .then((value) => refresh());
    } else if (title == "education") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const EducationPageScreen()))
          .then((value) => refresh());
    } else if (title == "work") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => WorkPageScreen()))
          .then((value) => refresh());
    } else if (title == "location") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LocationPageScreen()))
          .then((value) => refresh());
    } else if (title == "language") {
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => SelectLanguageScreenPage(type: "1")))
          .then((value) => refresh());
    } else if (title == "interest") {
      Navigator.of(context)
          .push(MaterialPageRoute(
              builder: (context) => SelectIntrest(
                    type: "1",
                  )))
          .then((value) => refresh());
    }
  }
}
