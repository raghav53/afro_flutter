import 'package:afro/Model/Events/CommonEvent/CommonEventDataModel.dart';
import 'package:afro/Model/Events/Going/GoingInterestedEventsModel.dart';
import 'package:afro/Model/Events/InvitedEvents/InvitedEventsModel.dart';
import 'package:afro/Model/Events/UserEvents/UserEventModel.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/DiscoverEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/GoingEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/InterestedEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/InvitedEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/MyEventsScreen.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/CreateNewEvent.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/material.dart';

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({Key? key}) : super(key: key);

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

UserDataConstants _user = UserDataConstants();

List<String> filterItem = [
  "Discover",
  "Going",
  "Interested",
  "Invited",
  "My Events"
];

var search = "";
var selectedIndex = 0;

Future<CommonEventsModel>? _getSelectedIndexEvents; //Discover Events
Future<GoingInterestedEventsModel>? _getGoingEvents; //Going Events
Future<GoingInterestedEventsModel>? _getInterestedEvents; //Interested Events
Future<UsersEventsModel>? _getUsersEventList; //Users Events
Future<InvitedEventsModel>? _getInvitedEventList; //Users Events

TextEditingController searchEditText = TextEditingController();

class _AllEventsScreenState extends State<AllEventsScreen> {
  @override
  void initState() {
    super.initState();
  }

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
                customHeightBox(35),
                //Searching
                Row(
                  mainAxisAlignment: mCenter,
                  children: [
                    Flexible(
                        flex: 5,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black, offset: Offset(0, 2))
                              ]),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                search = value.toString();
                              });
                            },
                            textInputAction: TextInputAction.go,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFFDFB48C),
                                ),
                                hintText: "Search",
                                contentPadding:
                                    EdgeInsets.only(left: 15, top: 15),
                                hintStyle: TextStyle(color: Colors.white24)),
                          ),
                        )),
                    customWidthBox(20),
                    Flexible(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            openBottomSheet();
                          },
                          child: Image.asset(
                            "assets/icons/fillter.png",
                            height: 20,
                            width: 20,
                          ),
                        )),
                  ],
                ),
                customHeightBox(25),
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
      return FutureBuilder<CommonEventsModel>(
          future:
              getAllEventsUsers(context, search: search, showProgress: false),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? DiscoverEventsScreen(context, snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          });
    } else if (index == 1) {
      return FutureBuilder<GoingInterestedEventsModel>(
          future: getAllGoingInterestedEventsUsers(context,
              isShow: false, type: "0", search: search),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? GoingEventsScreen(context, snapshot.data!)
                : const Center(child: CircularProgressIndicator());
          });
    } else if (index == 2) {
      return FutureBuilder<GoingInterestedEventsModel>(
          future: getAllGoingInterestedEventsUsers(context,
              isShow: false, type: "1", search: search),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? InterestedEventsScreen(context, snapshot.data!)
                : const Center(child: CircularProgressIndicator());
          });
    } else if (index == 3) {
      return FutureBuilder<InvitedEventsModel>(
          future:
              getAllInvitedEventsUsers(context, isShow: false, search: search),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? InvitedEventsScreen(context, snapshot.data!)
                : const Center(child: CircularProgressIndicator());
          });
    } else if (index == 4) {
      return FutureBuilder<UsersEventsModel>(
          future:
              getAllUsersEventsUsers(context, isShow: false, search: search),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? MyEventsScreenState(context, snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          });
    }
  }
}
