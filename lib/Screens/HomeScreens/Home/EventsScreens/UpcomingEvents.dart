import 'package:afro/Model/CountryModel.dart';
import 'package:afro/Model/Events/CommonEvent/CommonEventDataModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsDetailsPage.dart';
import 'package:afro/Util/Colors.dart';

import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class UpcomingEventsScreen extends StatefulWidget {
  _UpcomingEvent createState() => _UpcomingEvent();
}

UserDataConstants _user = UserDataConstants();
String searchEvent = "";
Future<CommonEventsModel>? _upComingEvent;
Future<CountryModel>? _getCountries;

String countriesIds = "";
var selectedRange = const RangeValues(0, 500);
var selectedInterestedRange = const RangeValues(0, 500);
int _startInterestedRange = 0;
int _endIntetestedRange = 500;
int _startGoingRange = 0;
int _endGoingRange = 500;
List<String> tempCountriesIds = [];

var _usergroupValue = 0;

class _UpcomingEvent extends State<UpcomingEventsScreen> {
  int clickPosition = 0;
  @override
  void initState() {
    super.initState();
   /* getUpcomingEvents();*/
    getCountries();
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
      appBar: commonAppbar("Upcoming Events"),
      body: Container(
        padding: EdgeInsets.only(top: 80),
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: mCenter,
              children: [
                Flexible(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow:  [
                            BoxShadow(color: black, offset: Offset(0, 2))
                          ]),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchEvent = value.toString();
                          });
                        },
                        keyboardType: TextInputType.text,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFFDFB48C),
                            ),
                            hintText: "Search",
                            contentPadding: EdgeInsets.only(left: 15, top: 15),
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
            getUpcomingEvents(),
          ],
        ),
      ),
    ));
  }

  getUpcomingEvents() {
    return FutureBuilder<CommonEventsModel>(
        future: getAllEventsUsers(context,
            search: searchEvent,
            showProgress: false,
            countryIds: countriesIds,
            isLink: _usergroupValue == 0 ? "" : _usergroupValue.toString(),
            minGoing: _startGoingRange.toString(),
            maxGoing: _endGoingRange.toString(),
            maxInterested: _endIntetestedRange.toString(),
            minInterested: _startInterestedRange.toString()),
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data != null
              ? upcominEventsList(snapshot.data!)
              : snapshot.data == null
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Center(
                  child: customText("No events!", 15, white),
                );
        });
  }

  upcominEventsList(CommonEventsModel snapshot) {
    return Flexible(
      child: ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventDetailsScreenPage(
                            eventId: snapshot.data![index].sId.toString(),
                            userId: snapshot.data![index].userId)));
              },
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  mainAxisAlignment: mStart,
                  crossAxisAlignment: cStart,
                  children: [
                    CachedNetworkImage(
                      imageUrl: IMAGE_URL +
                          snapshot.data![index].coverImage.toString(),
                      imageBuilder: (context, imageProvider) => Container(
                        width: phoneWidth(context),
                        height: 150.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    customHeightBox(10),
                    customText(snapshot.data![index].title.toString(), 12,
                        Colors.white),
                    customHeightBox(5),
                    customText(
                      snapshot.data![index].isInterested.toString() +
                          " Interested",
                      11,
                      const Color(0xff7822A0),
                    ),
                    customHeightBox(5),
                    Row(
                      children: [
                        Image.asset("assets/location.png",height: 15,width: 15,),
                        customWidthBox(5),
                        customText(snapshot.data![index].city.toString(), 12,
                            Colors.white)
                      ],
                    ),
                    customHeightBox(30)
                  ],
                ),
              ),
            );
          }),
    );
  }

  //Get the data according fillters
  void openBottomSheet() {
    var selectedBottomIndex = 0;

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
                            InkWell(
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
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child:
                                      customText("Country", 12, Colors.white),
                                )),
                              ),
                            ),
                            customHeightBox(15),
                            InkWell(
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
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: customText("Going", 12, Colors.white),
                                )),
                              ),
                            ),
                            customHeightBox(15),
                            InkWell(
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
                                      "Interested", 12, Colors.white),
                                )),
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
                      Spacer(),
                      Container(
                          height: phoneHeight(context) / 2.07,
                          decoration: const BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: Colors.grey, width: 1))),
                          child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SizedBox(
                                  width: phoneWidth(context) / 1.4,
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
                                            Container(
                                                height:
                                                    phoneHeight(context) / 2.7,
                                                child:
                                                    FutureBuilder<CountryModel>(
                                                  future: _getCountries,
                                                  builder: (context, snapshot) {
                                                    return snapshot.hasData &&
                                                            snapshot.data !=
                                                                null
                                                        ? ListView.builder(
                                                            itemCount: snapshot
                                                                .data!
                                                                .data!
                                                                .length,
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
                                                ))
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
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: InkWell(
                                    onTap: () {
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(bottom: 15),
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
                                )
                              ]))
                    ],
                  ),
                ],
              ),
            );
          });
        });
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
