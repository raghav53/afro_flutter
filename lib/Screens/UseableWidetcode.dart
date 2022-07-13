import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/DashboardScreenPage.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/FourmsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupsListScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/Messages/MessageListScreen.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/ProfileSettingScreenPage.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UseableWidgets extends StatefulWidget {
  _Useable createState() => _Useable();
}

class _Useable extends State<UseableWidgets> {
  int selectedItemIndex = 0;
  Widget selectedScreenPage = DashboardPageScreen();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: Container(
              height: 70,
              color: Colors.black,
              padding: EdgeInsets.only(top: 7, bottom: 7),
              child: Row(
                mainAxisAlignment: mAround,
                children: [
                  bottomNavigationBarItem("assets/icons/home.png", "Home", 0),
                  bottomNavigationBarItem("assets/icons/home.png", "Events", 1),
                  bottomNavigationBarItem(
                      "assets/icons/forums.png", "Forums", 2),
                  bottomNavigationBarItem(
                      "assets/icons/group.png", "Groups", 3),
                  bottomNavigationBarItem(
                      "assets/icons/message.png", "Message", 4),
                  bottomNavigationBarItem(
                      "assets/icons/user.png", "Account", 5),
                ],
              ),
            ),
            body: selectedScreenPage));
  }

  Widget bottomNavigationBarItem(String path, String title, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItemIndex = index;
          switch (index) {
            case 0:
              selectedScreenPage = DashboardPageScreen();
              break;
            case 1:
              selectedScreenPage = AllEventsScreen();
              break;
            case 2:
              selectedScreenPage = ForumsScreenPage();
              break;
            case 3:
              selectedScreenPage = GroupsListScreen();
              break;
            case 4:
              selectedScreenPage = MessageListScreen();
              break;
            case 5:
              selectedScreenPage = ProfileSettingScreenPage();
              break;
            default:
              selectedScreenPage = DashboardPageScreen();
              break;
          }
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40,
            decoration: BoxDecoration(
                gradient: index == selectedItemIndex
                    ? commonButtonLinearGridient
                    : null,
                borderRadius: BorderRadius.circular(200)),
            child: Image.asset(
              path,
              scale: 1.5,
            ),
          ),
          Visibility(
              visible: (selectedItemIndex == index) ? false : true,
              child: customText(title, 10, Colors.white))
        ],
      ),
    );
  }
}
