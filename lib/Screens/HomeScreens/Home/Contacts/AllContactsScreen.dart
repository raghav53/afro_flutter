import 'package:afro/Screens/HomeScreens/Home/Contacts/AllFriendsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Contacts/AllUserScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/Contacts/ReceivedFriendRequests.dart';
import 'package:afro/Screens/HomeScreens/Home/Contacts/SendFriendsRequest.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';

import 'package:flutter/material.dart';

class AllContactsListScreen extends StatefulWidget {
  const AllContactsListScreen({Key? key}) : super(key: key);

  @override
  State<AllContactsListScreen> createState() => _AllContactsListScreenState();
}

class _AllContactsListScreenState extends State<AllContactsListScreen> {
  var selectedIndex = 0;
  var selectedText = "People You may Know";

  List<String> titleList = [
    "People You May Know",
    "Contacts Requests",
    "Send Requests",
    "My Friends"
  ];

  List<String> filterList = [
    "Discover",
    "Contacts Requests",
    "Sent Requests",
    "My Friends"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: commonAppbar("Explore Contacts"),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.only(top: 70, left: 20, right: 20),
          decoration: commonBoxDecoration(),
          height: phoneHeight(context),
          width: phoneWidth(context),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: cStart,
              children: [
                customHeightBox(15),
                //Fillters List
                customText("Choose Fillters", 13, yellowColor),
                customHeightBox(10),
                Container(
                  height: 25,
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: filterList.length,
                      itemBuilder: (context, index) {
                        return filterItem(
                            filterList[index], index, titleList[index]);
                      }),
                ),
                customHeightBox(30),
                customText(selectedText, 12, yellowColor),
                customDivider(20, white),

                //Selected Listview(Discover by default)
                setTheListview(selectedIndex)
              ],
            ),
          ),
        ),
      ),
    );
  }

  //filterItem listview
  Widget filterItem(String filterList, int index, String title) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
          selectedText = title;
          setTheListview(index);
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
            gradient:
                (selectedIndex == index) ? commonButtonLinearGridient : null,
            border: (selectedIndex == index)
                ? null
                : Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          child: customText(filterList, 10, Colors.white),
        ),
      ),
    );
  }

  //Selected  list
  setTheListview(int index) {
    print(index);
    if (index == 0) {
      return AllUsersPage();
    } else if (index == 1) {
      return ReceivedFriendRequest();
    } else if (index == 2) {
      return SendFriendsRequest();
    } else if (index == 3) {
      return AllFriendsPage();
    }
  }
}
