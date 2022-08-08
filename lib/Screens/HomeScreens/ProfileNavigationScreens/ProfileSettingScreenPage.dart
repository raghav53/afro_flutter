import 'dart:async';
import 'dart:convert';
import 'package:afro/Screens/Authentication/SignInPage2.dart';
import 'package:afro/Screens/HomeScreens/Home/Contacts/AllContactsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/MembershipScreenPage.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/Home/MyProfile.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/SendFeedbackPage.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/SettingsScreenPage.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Network/Apis.dart';
import '../../../Util/Colors.dart';
import '../../../Util/CommonUI.dart';

class ProfileSettingScreenPage extends StatefulWidget {
  _ProfilePage createState() => _ProfilePage();
}

String? fullName, imageURl;
UserDataConstants user = UserDataConstants();

class _ProfilePage extends State<ProfileSettingScreenPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await _prefs;
    fullName = sharedPreferences.getString(user.fullName);
    imageURl = sharedPreferences.getString(user.profileImage);
    print(imageURl);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: onlyTitleCommonAppbar("Profile"),
            body: Container(
                height: phoneHeight(context),
                width: phoneWidth(context),
                decoration: commonBoxDecoration(),
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    customHeightBox(50),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyProfilePage()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            //Profile Image
                            Container(
                              margin: EdgeInsets.all(20),
                              width: 60,
                              height: 60,
                              child: CachedNetworkImage(
                                imageUrl: IMAGE_URL + imageURl.toString(),
                                placeholder: (context, url) => CircleAvatar(
                                    backgroundImage:
                                        AssetImage("tom_cruise.jpeg")),
                                imageBuilder: (context, image) => CircleAvatar(
                                  backgroundImage: image,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                customText(
                                    fullName.toString(), 19, Colors.white),
                                customText(
                                    "View and Edit Profile", 16, Colors.white)
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
                    ),
                    Divider(
                      height: 10,
                      color: Colors.white,
                    ),
                    listItemButton("Membership", context),
                    customDivider(10, Colors.white),
                    listItemButton("Contacts", context),
                    customDivider(10, Colors.white),
                    listItemButton("Send Feedback", context),
                    customDivider(10, Colors.white),
                    listItemButton("Settings", context),
                    customDivider(10, Colors.white),
                    listItemButton("Logout", context),
                    customDivider(10, Colors.white),
                  ],
                )))));
  }

  //Show Logout dialog box
  void showlogoutdialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: gray1, borderRadius: BorderRadius.circular(10)),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  customText("Afro United", 15, white),
                  customHeightBox(15),
                  customText("Do you want to logout?", 13, white),
                  customHeightBox(20),
                  Row(
                    mainAxisAlignment: mCenter,
                    children: [
                      InkWell(
                        onTap: () {
                          logoutTheUser();
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 25, right: 25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: commonButtonLinearGridient),
                          child:
                              Center(child: customText("Logout?", 13, white)),
                        ),
                      ),
                      customWidthBox(10),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: 10, bottom: 10, left: 25, right: 25),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: commonButtonLinearGridient),
                          child: Center(child: customText("Cancel", 13, white)),
                        ),
                      )
                    ],
                  )
                ]),
              ));
        });
  }

  Widget listItemButton(String title, BuildContext context) {
    String customImage = "";

    if (title == "Membership") {
      customImage = "assets/icons/member.png";
    } else if (title == "Contacts") {
      customImage = "assets/icons/group.png";
    } else if (title == "Send Feedback") {
      customImage = "assets/icons/feedback.png";
    } else if (title == "Settings") {
      customImage = "assets/icons/settings.png";
    } else if (title == "Logout") {
      customImage = "assets/icons/logout.png";
    }
    return InkWell(
        onTap: () => {goNavigate(title, context)},
        child: InkWell(
          child: ListTile(
            leading: Image.asset(
              customImage,
              height: 40,
              width: 40,
            ),
            title: customText(title, 15, Colors.white),
            trailing: const Icon(
              Icons.arrow_forward_ios_outlined,
              color: Color(0xFFDFB48C),
            ),
          ),
        ));
  }

  void goNavigate(String title, BuildContext context) {
    if (title == "Membership") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => MembershipScreenPage()));
    } else if (title == "Contacts") {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => AllContactsListScreen()));
    } else if (title == "Send Feedback") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SendFeedbackPage()));
    } else if (title == "Settings") {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SettingsScreenPage()));
    } else if (title == "Logout") {
      showlogoutdialog(context);
    }
  }

  Future<void> logoutTheUser() async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var jsonResponse = null;
    var response = await http.delete(
      Uri.parse(BASE_URL + "logout"),
      headers: {'api-key': API_KEY, 'x-access-token': token!},
    );
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.clear();
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }
}
