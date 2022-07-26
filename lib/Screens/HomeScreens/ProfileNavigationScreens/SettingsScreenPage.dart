import 'package:afro/Screens/Authentication/ChooseLanguage.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/ChangePasswordPage.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/PrivacyPolicyScreen.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/SelectLanguage.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreenPage extends StatefulWidget {
  @override
  State<SettingsScreenPage> createState() => _SettingsScreenPageState();
}

class _SettingsScreenPageState extends State<SettingsScreenPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            leading: BackButton(),
            title: customText("Settings", 20, Colors.white)),
        body: Container(
          padding: EdgeInsets.only(top: 60),
          decoration: commonBoxDecoration(),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: cStart,
            children: [
              listItemButton("Change Password", context),
              customDivider(10, Colors.white),
              listItemButton("Privacy Policy", context),
              customDivider(10, Colors.white),
              listItemButton("Switch Language", context),
              customDivider(10, Colors.white),
              customHeightBox(10),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: customText("Version\nv.1.0", 13, Colors.white),
              ),
              customHeightBox(10),
              customDivider(10, Colors.white)
            ],
          ),
        ),
      ),
    );
  }
}

Widget listItemButton(String title, BuildContext context) {
  String customImage = "";

  if (title == "Change Password") {
    customImage = "assets/icons/change_password.png";
  } else if (title == "Privacy Policy") {
    customImage = "assets/icons/feedback.png";
  } else if (title == "Switch Language") {
    customImage = "assets/icons/logout.png";
  }
  return InkWell(
    onTap: () => {goNavigate(title, context)},
    child: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: ListTile(
          leading: Image.asset(
            customImage,
            height: 40,
            width: 40,
          ),
          title: customText(title, 15, Colors.white),
          trailing: Icon(
            Icons.arrow_forward_ios_outlined,
            color: Color(0xFFDFB48C),
          ),
        )),
  );
}

void goNavigate(String title, BuildContext context) {
  if (title == "Change Password") {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ChangePasswordPage()));
  } else if (title == "Privacy Policy") {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()));
  } else if (title == "Switch Language") {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ChooseLanguage()));
  }
}
