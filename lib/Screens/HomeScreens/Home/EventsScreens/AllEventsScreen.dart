import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/DiscoverEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/GoingEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/InterestedEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/InvitedEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/MyEventsScreen.dart';

import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/CreateNewEvent.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/material.dart';

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({Key? key}) : super(key: key);

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  List<String> filterItem = [
    "Discover",
    "Going",
    "Interested",
    "Invited",
    "My Events"
  ];

  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: onlyTitleCommonAppbar("Events"),
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateNewEvent()));
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: commonButtonLinearGridient),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 40),
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: cStart,
              children: [
                customHeightBox(50),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  height: 30,
                  child: ListView.builder(
                      itemCount: filterItem.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return filterItemView(index, filterItem[index]);
                      }),
                ),
                customHeightBox(20),
                //Selected events list(By default Discover Events listview appeared)
                selectedListView(selectedIndex)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget filterItemView(int index, String filterItem) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            border: selectedIndex == index
                ? null
                : Border.all(color: white, width: 1),
            gradient:
                selectedIndex == index ? commonButtonLinearGridient : null,
            borderRadius: BorderRadius.circular(20)),
        height: 15,
        width: 80,
        child: Center(child: customText(filterItem, 12, white)),
      ),
    );
  }

  //Get the data according fillters
  void openBottomSheet() {
    showModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              decoration: commonBoxDecoration(),
              child: Column(
                children: [
                  customHeightBox(15),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: mBetween,
                      children: [
                        customText(
                            "Filter & Sort", 12, const Color(0xFFDFB48C)),
                        customText("Country", 12, const Color(0xFFDFB48C)),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                  customDivider(5, Colors.white),
                  Row(
                    crossAxisAlignment: cStart,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 15, left: 10),
                        child: Column(
                          mainAxisAlignment: mStart,
                          crossAxisAlignment: cStart,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child:
                                      customText("Country", 12, Colors.white),
                                )),
                              ),
                            ),
                            customHeightBox(15),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: customText("Going", 12, Colors.white),
                                )),
                              ),
                            ),
                            customHeightBox(15),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: customText(
                                      "Interested", 12, Colors.white),
                                )),
                              ),
                            ),
                            customHeightBox(15),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    // gradient: (clickPosition == 3)
                                    //     ? selectedColor
                                    //     : null,
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 1,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child:
                                      customText("Clear All", 12, Colors.white),
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Container(
                            height: 50,
                            width: 240,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.black),
                            margin: const EdgeInsets.only(
                                top: 15, left: 10, right: 10),
                            child: const TextField(
                                keyboardType: TextInputType.text,
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(top: 15, left: 15),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: Color(0xFFDFB48C),
                                  ),
                                )),
                          ),
                          customHeightBox(10),
                          Container(
                            alignment: Alignment.center,
                            height: 40.0,
                            child: RaisedButton(
                                onPressed: () {
                                  // Navigator.of(context).push(
                                  //     MaterialPageRoute(builder: (context) => EmailVerification()));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80.0)),
                                padding: EdgeInsets.all(0.0),
                                child: buttonBackground("Sign Up")),
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  selectedListView(int index) {
    if (index == 0) {
      return const DiscoverEventsScreen();
    } else if (index == 1) {
      return const GoingEventsScreen();
    } else if (index == 2) {
      return const InterestedEventsScreen();
    } else if (index == 3) {
      return const InvitedEventsScreen();
    } else if (index == 4) {
      return const MyEventsScreen();
    }
  }
}
