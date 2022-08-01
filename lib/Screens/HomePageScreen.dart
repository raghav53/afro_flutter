import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/DashboardScreenPage.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/FourmsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupsAllListScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/Messages/MessageListScreen.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/ProfileSettingScreenPage.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';

import 'package:flutter/material.dart';

class HomePagescreen extends StatefulWidget {
  const HomePagescreen({Key? key}) : super(key: key);

  @override
  State<HomePagescreen> createState() => _HomePagescreenState();
}

class _HomePagescreenState extends State<HomePagescreen> {
  int selectedItemIndex = 0;
  Widget selectedScreenPage = DashboardPageScreen();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: Container(
              height: 70,
              color: Colors.black,
              padding: const EdgeInsets.only(top: 7, bottom: 7),
              child: Row(
                mainAxisAlignment: mAround,
                children: [
                  bottomNavigationBarItem("assets/icons/home.png", "Home", 0),
                  bottomNavigationBarItem(
                      "assets/icons/event_icn.png", "Events", 1),
                  bottomNavigationBarItem(
                      "assets/icons/ic_forum_white.PNG", "Forums", 2),
                  bottomNavigationBarItem(
                      "assets/icons/ic_group.PNG", "Groups", 3),
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
              selectedScreenPage = GroupsAllListScreen();
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                path,
                scale: 1.5,
                color: Colors.white,
              ),
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
