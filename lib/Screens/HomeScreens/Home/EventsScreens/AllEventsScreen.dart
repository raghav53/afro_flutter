import 'package:afro/Model/CountryModel.dart';
import 'package:afro/Model/Events/CommonEvent/CommonEventDataModel.dart';
import 'package:afro/Model/Events/Going/GoingInterestedEventsModel.dart';
import 'package:afro/Model/Events/InvitedEvents/InvitedEventsModel.dart';
import 'package:afro/Model/Events/UserEvents/UserEventModel.dart';
import 'package:afro/Network/Apis.dart';

import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/GoingEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/InterestedEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/InvitedEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen/MyEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsDetailsPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/CreateNewEvent.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AllEventsScreen extends StatefulWidget {
  String? type = "";
 late int  selectedIndex ;
  AllEventsScreen({Key? key, this.type,  this.selectedIndex=0}) : super(key: key);

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
/*var selectedIndex = 0;*/

Future<CommonEventsModel>? _getSelectedIndexEvents; //Discover Events
Future<GoingInterestedEventsModel>? _getGoingEvents; //Going Events
Future<GoingInterestedEventsModel>? _getInterestedEvents; //Interested Events
Future<UsersEventsModel>? _getUsersEventList; //Users Events
Future<InvitedEventsModel>? _getInvitedEventList; //Users Events

//Bottomsheet searching
String countriesIds = "";
var selectedRange = const RangeValues(0, 500);
var selectedInterestedRange = const RangeValues(0, 500);
int _startInterestedRange = 0;
int _endIntetestedRange = 500;
int _startGoingRange = 0;
int _endGoingRange = 500;
List<String> tempCountriesIds = [];
Future<CountryModel>? _getCountries;
var _usergroupValue = 0;

TextEditingController searchEditText = TextEditingController();

class _AllEventsScreenState extends State<AllEventsScreen> {
  @override
  void initState() {
    super.initState();
   widget.selectedIndex = 0;
    getCountries();
    defaultValue();
  }

  defaultValue() {
    setState(() {
      selectedRange = const RangeValues(0, 500);
      selectedRange = const RangeValues(0, 500);
      countriesIds = "";
      _usergroupValue = 0;
      _endGoingRange = 500;
      _startGoingRange = 0;
      _endIntetestedRange = 500;
      _startInterestedRange = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: widget.type!.isNotEmpty
            ? AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                automaticallyImplyLeading: true,
                title: const Text("Events"),
              )
            : onlyTitleCommonAppbar("Events"),
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) =>  const CreateNewEvent()))
                .then((value) => setState(() {}));
          },
          child: Container(
            alignment: Alignment.center,
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: commonButtonLinearGridient),
            child:  Image.asset("assets/icons/add.png",height: 30,width: 30,color: Colors.white,)
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 40),
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
                              boxShadow:  [
                                BoxShadow(
                                    color: black, offset: Offset(0, 2))
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
                                  size: 28,
                                  color: Color(0xFFDFB48C),
                                ),
                                hintText: "Search By Name",
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
                            height: 28,
                            width: 28,
                          ),
                        )),
                  ],
                ),
                customHeightBox(25),
                Container(
                  padding: const EdgeInsets.only(left: 20, right: 20),
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
                selectedListView(widget.selectedIndex)
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
        defaultValue();
        setState(() {
          widget.selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            border: widget.selectedIndex == index
                ? null
                : Border.all(color: grey, width: 2),
            gradient:
            widget.selectedIndex == index ? commonButtonLinearGridient : null,
            borderRadius: BorderRadius.circular(20)),
        height: 15,
        width: 80,
        child: Center(child: customText(filterItem, 12, white)),
      ),
    );
  }

  //Get the data according fillters
  void openBottomSheet() {
    var selectedBottomIndex = 0;

    widget.selectedIndex == 0 ? selectedBottomIndex = 0 : selectedBottomIndex = 3;
    var indexTitle = "Country";

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
                        customText(indexTitle, 12, const Color(0xFFDFB48C)),
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
                            Visibility(
                              visible: widget.selectedIndex == 0 ? true : false,
                              child: InkWell(
                                onTap: () {
                                  state(() {
                                    selectedBottomIndex = 0;
                                    indexTitle = "Country";
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: (selectedBottomIndex == 0)
                                          ? commonButtonLinearGridient
                                          : null,
                                      border: selectedBottomIndex != 0
                                          ? Border.all(
                                              color: Colors.white,
                                              width: 1,
                                              style: BorderStyle.solid)
                                          : null,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child:
                                        customText("Country", 12, Colors.white),
                                  )),
                                ),
                              ),
                            ),
                            customHeightBox(15),
                            Visibility(
                              visible: widget.selectedIndex == 0 ? true : false,
                              child: InkWell(
                                onTap: () {
                                  state(() {
                                    selectedBottomIndex = 1;
                                    indexTitle = "Going";
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: (selectedBottomIndex == 1)
                                          ? commonButtonLinearGridient
                                          : null,
                                      border: selectedBottomIndex != 1
                                          ? Border.all(
                                              color: Colors.white,
                                              width: 1,
                                              style: BorderStyle.solid)
                                          : null,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child:
                                        customText("Going", 12, Colors.white),
                                  )),
                                ),
                              ),
                            ),
                            customHeightBox(15),
                            Visibility(
                              visible: widget.selectedIndex == 0 ? true : false,
                              child: InkWell(
                                onTap: () {
                                  state(() {
                                    selectedBottomIndex = 2;
                                    indexTitle = "Interested";
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: (selectedBottomIndex == 2)
                                          ? commonButtonLinearGridient
                                          : null,
                                      border: selectedBottomIndex != 2
                                          ? Border.all(
                                              color:grey,
                                              width: 1,
                                              style: BorderStyle.solid)
                                          : null,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: customText(
                                        "Interested", 12, Colors.white),
                                  )),
                                ),
                              ),
                            ),
                            customHeightBox(15),
                            InkWell(
                              onTap: () {
                                state(() {
                                  selectedBottomIndex = 3;
                                  indexTitle = "Event Type";
                                });
                              },
                              child: Container(
                                width: 80,
                                decoration: BoxDecoration(
                                    gradient: (selectedBottomIndex == 3)
                                        ? commonButtonLinearGridient
                                        : null,
                                    border: selectedBottomIndex != 3
                                        ? Border.all(
                                            color: Colors.white,
                                            width: 1,
                                            style: BorderStyle.solid)
                                        : null,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: customText(
                                      "Event Type", 12, Colors.white),
                                )),
                              ),
                            ),
                            customHeightBox(15),
                            InkWell(
                              onTap: () {
                                state(() {
                                  defaultValue();
                                });
                                Navigator.pop(context);
                              },
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
                                      customText("Clear All", 12, Colors.white),
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                          height: phoneHeight(context) / 2.2,
                          decoration: const BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.grey, width: 1))),
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SizedBox(
                                  width: phoneWidth(context) / 1.5,
                                  child: selectedBottomIndex == 0
                                      ? Column(
                                          children: [
                                            Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.black),
                                              margin: const EdgeInsets.only(
                                                  top: 15, left: 10, right: 10),
                                              child: const TextField(
                                                  keyboardType:
                                                      TextInputType.text,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.white),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            top: 8, left: 15),
                                                    prefixIcon: Icon(
                                                      Icons.search,
                                                      color: Color(0xFFDFB48C),
                                                    ),
                                                  )),
                                            ),
                                            customHeightBox(10),
                                            SizedBox(
                                              height: phoneHeight(context)*2.7,
                                              child: FutureBuilder<CountryModel>(
                                                    future: _getCountries,
                                                    builder: (context, snapshot) {
                                              return snapshot.hasData &&
                                                      snapshot.data !=
                                                          null
                                                  ? ListView.builder(
                                                      itemCount: snapshot.data!.data!.length,
                                                      itemBuilder:
                                                          (context,
                                                              index) {
                                                        return ListTile(
                                                          leading:
                                                              CachedNetworkImage(
                                                            height: 35,
                                                            width: 35,
                                                            imageUrl: flagImageUrl
                                                                    .toString() +
                                                                snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .iso2
                                                                    .toString()
                                                                    .toLowerCase() +
                                                                ".png",
                                                            placeholder: (context,
                                                                    url) =>
                                                                const Icon(
                                                                    Icons
                                                                        .flag),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(
                                                                    Icons
                                                                        .error),
                                                          ),
                                                          title: customText(
                                                              snapshot
                                                                  .data!
                                                                  .data![
                                                                      index]
                                                                  .title
                                                                  .toString(),
                                                              15,
                                                              white),
                                                          trailing:
                                                              Checkbox(
                                                                  side: BorderSide(
                                                                      color:Colors.purple
                                                                  ),
                                                                  activeColor: Colors.purple,
                                                                  checkColor: Colors.black,
                                                                  value: snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .isSelected,
                                                                  onChanged:
                                                                      (val) {
                                                                    state(
                                                                        () {
                                                                      snapshot.data!.data![index].isSelected =
                                                                          !snapshot.data!.data![index].isSelected;
                                                                      addRemoveCountriesIds(snapshot.data!.data![index].sId.toString(),
                                                                          snapshot.data!.data![index].isSelected);
                                                                    });
                                                                  }),
                                                        );
                                                      })
                                                  : Center(
                                                      child: customText(
                                                          "No countries found!",
                                                          15,
                                                          white),
                                                    );
                                                    },
                                                  ),
                                            )
                                          ],
                                        )
                                      : selectedBottomIndex == 1
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                  top: 15, left: 10, right: 10),
                                              width: 270,
                                              child: Column(
                                                  crossAxisAlignment: cCenter,
                                                  children: [
                                                    RangeSlider(
                                                      activeColor: yellowColor,
                                                      inactiveColor: white,
                                                      min: 0,
                                                      max: 500,
                                                      values: selectedRange,
                                                      onChanged: (RangeValues
                                                          newValue) {
                                                        state(() {
                                                          selectedRange =
                                                              newValue;
                                                          _startGoingRange =
                                                              newValue.start
                                                                  .toInt();
                                                          _endGoingRange =
                                                              newValue.end
                                                                  .toInt();
                                                        });
                                                      },
                                                    ),
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 20,
                                                              right: 11),
                                                      child: Row(
                                                        children: [
                                                          customText(
                                                              "min " +
                                                                  _startGoingRange
                                                                      .toString(),
                                                              15,
                                                              white),
                                                          Spacer(),
                                                          customText(
                                                              "max " +
                                                                  _endGoingRange
                                                                      .toString(),
                                                              15,
                                                              white)
                                                        ],
                                                      ),
                                                    )
                                                  ]))
                                          : selectedBottomIndex == 2
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 15,
                                                      left: 10,
                                                      right: 10),
                                                  width: 270,
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          cCenter,
                                                      children: [
                                                        RangeSlider(
                                                          activeColor:
                                                              yellowColor,
                                                          inactiveColor: white,
                                                          min: 0,
                                                          max: 500,
                                                          values:
                                                              selectedInterestedRange,
                                                          onChanged:
                                                              (RangeValues
                                                                  newValue) {
                                                            state(() {
                                                              selectedInterestedRange =
                                                                  newValue;
                                                              _startInterestedRange =
                                                                  newValue.start
                                                                      .toInt();
                                                              _endIntetestedRange =
                                                                  newValue.end
                                                                      .toInt();
                                                            });
                                                          },
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  right: 11),
                                                          child: Row(
                                                            children: [
                                                              customText(
                                                                  "min " +
                                                                      _startInterestedRange
                                                                          .toString(),
                                                                  15,
                                                                  white),
                                                              Spacer(),
                                                              customText(
                                                                  "max " +
                                                                      _endIntetestedRange
                                                                          .toString(),
                                                                  15,
                                                                  white)
                                                            ],
                                                          ),
                                                        )
                                                      ]))
                                              : selectedBottomIndex == 3
                                                  ? Align(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              state(() {
                                                                _usergroupValue =
                                                                    1;
                                                                print(
                                                                    _usergroupValue);
                                                              });
                                                            },
                                                            child: Container(
                                                              width: phoneWidth(
                                                                      context) /
                                                                  3,
                                                              child: Row(
                                                                children: [
                                                                  Radio(
                                                                      focusColor:
                                                                          Colors
                                                                              .blueAccent,
                                                                      value: 1,
                                                                      groupValue:
                                                                          _usergroupValue,
                                                                      onChanged:
                                                                          (index) {}),
                                                                  customText(
                                                                      "In-person",
                                                                      13,
                                                                      Colors
                                                                          .white)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              state(() {
                                                                _usergroupValue =
                                                                    2;
                                                                print(
                                                                    _usergroupValue);
                                                              });
                                                            },
                                                            child: Container(
                                                              width: phoneWidth(
                                                                      context) /
                                                                  3,
                                                              child: Row(
                                                                children: [
                                                                  Radio(
                                                                      focusColor:
                                                                          Colors
                                                                              .blueAccent,
                                                                      value: 2,
                                                                      groupValue:
                                                                          _usergroupValue,
                                                                      onChanged:
                                                                          (index) {}),
                                                                  customText(
                                                                      "Online",
                                                                      13,
                                                                      Colors
                                                                          .white)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                ),

                                InkWell(
                                  onTap: () {
                                    setState(() {});
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                      height: 30,
                                      width: 70,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(bottom: 10),
                                      /*  padding: const EdgeInsets.only(
                                      top: 7, bottom: 5, left: 20, right: 20),*/
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        gradient: commonButtonLinearGridient,
                                      ),
                                      child:
                                      customText("Apply", 16, Colors.white)),
                                )
                              /*  Align(
                                  alignment: Alignment.bottomCenter,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(bottom: 15),
                                        padding: const EdgeInsets.only(
                                            top: 7,
                                            bottom: 7,
                                            left: 20,
                                            right: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          gradient: commonButtonLinearGridient,
                                        ),
                                        child: customText(
                                            "Apply", 16, Colors.white)),
                                  ),
                                )*/
                              ]))
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  refresh() {
    setState(() {});
  }

  selectedListView(int index) {
    if (index == 0) {
      return FutureBuilder<CommonEventsModel>(
          future: getAllEventsUsers(context,
              search: search,
              showProgress: false,
              countryIds: countriesIds,
              isLink: _usergroupValue == 0 ? "" : _usergroupValue.toString(),
              minGoing: _startGoingRange.toString(),
              maxGoing: _endGoingRange.toString(),
              maxInterested: _endIntetestedRange.toString(),
              minInterested: _startInterestedRange.toString()),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? DiscoverEventsScreen(context, snapshot.data!)
                : snapshot.data == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        margin: const EdgeInsets.only(top: 100),
                        alignment: Alignment.center,
                        child: Center(
                          child: customText("No data!", 15, white),
                        ),
                      );
          });
    } else if (index == 1) {
      return FutureBuilder<GoingInterestedEventsModel>(
          future: getAllGoingInterestedEventsUsers(
            context,
            isShow: false,
            type: "0",
            search: search,
            is_online: _usergroupValue == 0 ? "" : _usergroupValue.toString(),
          ),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? GoingEventsScreen(context, snapshot.data!)
                : snapshot.data == null
                ? const Center(
              child: CircularProgressIndicator(),
            )

                : Container(
                    margin: const EdgeInsets.only(top: 100),
                    alignment: Alignment.center,
                    child: Center(
                      child: customText("No data!", 15, white),
                    ),
                  );
          });
    } else if (index == 2) {
      return FutureBuilder<GoingInterestedEventsModel>(
          future: getAllGoingInterestedEventsUsers(context,
              isShow: false,
              type: "1",
              search: search,
              is_online:
                  _usergroupValue == 0 ? "" : _usergroupValue.toString()),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? InterestedEventsScreen(context, snapshot.data!)
                : snapshot.data == null
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Container(
                    margin: const EdgeInsets.only(top: 100),
                    alignment: Alignment.center,
                    child: Center(
                      child: customText("No data!", 15, white),
                    ),
                  );
          });
    } else if (index == 3) {
      return FutureBuilder<InvitedEventsModel>(
          future:
              getAllInvitedEventsUsers(context, isShow: false, search: search),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? InvitedEventsScreen(context, snapshot.data!)
               :Container(
                    margin: EdgeInsets.only(top: 100),
                    alignment: Alignment.center,
                    child: Center(
                      child: customText("No data!", 15, white),
                    ),
                  );
          });
    } else if (index == 4) {
      return FutureBuilder<UsersEventsModel>(
          future: getAllUsersEventsUsers(context,
              isShow: false,
              search: search,
              is_online:
                  _usergroupValue == 0 ? "" : _usergroupValue.toString()),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? MyEventsScreenState(context, snapshot.data!)
                : snapshot.data == null
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : Container(
                    margin: const EdgeInsets.only(top: 100),
                    alignment: Alignment.center,
                    child: Center(
                      child: customText("No data!", 15, white),
                    ),
                  );
          });
    }
  }

  //Discover events
  DiscoverEventsScreen(BuildContext context, CommonEventsModel getAllEvents) {
    return SizedBox(
      width: phoneWidth(context),
      child: Column(
        children: [
          customHeightBox(20),
          Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              height: phoneHeight(context) / 1.5,
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: getAllEvents.data!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EventDetailsScreenPage(
                                  eventId:
                                      getAllEvents.data![index].sId.toString(),
                                  userId: getAllEvents.data![index].userId,
                                )));
                      },
                      child: Column(
                        mainAxisAlignment: mStart,
                        crossAxisAlignment: cStart,
                        children: [
                          CachedNetworkImage(
                            imageUrl: IMAGE_URL +
                                getAllEvents.data![index].coverImage.toString(),
                            imageBuilder: (context, imageProvider) => Container(
                              width: phoneWidth(context),
                              height: 150.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: gray1,
                                        spreadRadius: 0.3
                                    )
                                  ],
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          customHeightBox(10),
                          customText(getAllEvents.data![index].title.toString(),
                              12, Colors.white),
                          customHeightBox(5),
                          customText(
                            getAllEvents.data![index].totalInterested
                                    .toString() +
                                " Interested",
                            11,
                            const Color(0xff7822A0),
                          ),
                          customHeightBox(5),
                          Row(
                            children: [
                              (getAllEvents.data![index].isLink.toString()!="2")? Image.asset("assets/location.png",height: 15,width: 15,): Image.asset(
                                "assets/icons/http.png",
                                height: 15,
                                width: 15,
                                color: yellowColor,
                              ),
                              customWidthBox(5),
                              customText(
                    (getAllEvents.data![index].isLink.toString()!="2")?getAllEvents.data![index].state
                        .toString()+","+getAllEvents.data![index].country!.title
                                      .toString():getAllEvents.data![index].eventLink.toString(),
                                  12,
                                  Colors.white)
                            ],
                          ),
                          customHeightBox(30)
                        ],
                      ),
                    );
                  })),
        ],
      ),
    );
  }

  getCountries() {
    Future.delayed(Duration.zero, () {
      _getCountries = getCountriesList(context, isShow: false);
      setState(() {});
      _getCountries!.whenComplete(() => {});
    });
  }

  addRemoveCountriesIds(String id, bool value) {
    if (value) {
      tempCountriesIds.add(id.toString());
    } else {
      tempCountriesIds.remove(id.toString());
    }
    countriesIds = tempCountriesIds.join(",");
  }
}
