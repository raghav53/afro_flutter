import 'dart:convert';

import 'package:afro/Model/CitiesModel.dart';
import 'package:afro/Model/CountryModel.dart';
import 'package:afro/Model/StatesModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/OnBoardingScreen/FirstOnBoard.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddTimelinePageScreen extends StatefulWidget {
  Map dataMap = {};
  AddTimelinePageScreen({Key? key, required this.dataMap}) : super(key: key);
  @override
  _Timeline createState() => _Timeline();
}

String searchCountry = "", searchState = "", searchCity = "";
TextEditingController s = new TextEditingController();
String countryId = "",
    stateId = "",
    cityId = "",
    fromText = "",
    toText = "",
    isUpdateId = "";
String countryName = "",
    stateName = "",
    cityName = "",
    fromDateText = "",
    toDateText = "";
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
var user = UserDataConstants();
Future<CountryModel>? _getCountriesList;
Future<StatesModel>? _getStatesList;
Future<CitiesModel>? _getCityList;

class _Timeline extends State<AddTimelinePageScreen> {
  bool isChecked = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.dataMap);
    countryName = "";
    stateName = "";
    cityName = "";
    fromDateText = "";
    toDateText = "";
    updateapi();
    Future.delayed(Duration.zero, () {
      _getCountriesList = getCountriesList(context);
      _getCountriesList!.whenComplete(() => {setState(() {})});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: commonAppbar(
          widget.dataMap.isEmpty ? "Placed live in" : "Update place details"),
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.only(top: 80, left: 20, right: 20),
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: cStart,
          mainAxisAlignment: mStart,
          children: [
            //Country
            customText("Country", 15, white),
            customHeightBox(10),
            InkWell(
              onTap: () {
                showCountryDialog(context);
              },
              child: Container(
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                width: phoneWidth(context),
                decoration: BoxDecoration(
                    color: black, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    customText(countryName.isEmpty ? "Country" : countryName,
                        12, countryName.isEmpty ? white24 : white),
                    Spacer(),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: white24,
                    )
                  ],
                ),
              ),
            ),
            customHeightBox(15),
            //State
            customText("State", 15, white),
            customHeightBox(10),
            InkWell(
              onTap: () {
                showStatesDialog(context);
              },
              child: Container(
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                width: phoneWidth(context),
                decoration: BoxDecoration(
                    color: black, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    customText(stateName.isEmpty ? "State" : stateName, 12,
                        stateName.isEmpty ? white24 : white),
                    Spacer(),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: white24,
                    )
                  ],
                ),
              ),
            ),
            customHeightBox(15),
            //City
            customText("City", 15, white),
            customHeightBox(10),
            InkWell(
              onTap: () {
                showCitiessDialog(context);
              },
              child: Container(
                padding:
                    EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
                width: phoneWidth(context),
                decoration: BoxDecoration(
                    color: black, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    customText(cityName.isEmpty ? "City" : cityName, 12,
                        cityName.isEmpty ? white24 : white),
                    Spacer(),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: white24,
                    )
                  ],
                ),
              ),
            ),
            customHeightBox(20),
            customText("Duration", 15, white),
            //From date to Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //Start Date
                Flexible(
                    child: InkWell(
                  onTap: () {
                    openBottomSheet(context, "from");
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customHeightBox(10),
                      Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black, offset: Offset(0, 2))
                              ]),
                          height: 50,
                          child: Row(
                            children: [
                              customText(
                                  fromDateText.isEmpty ? "From" : fromDateText,
                                  15,
                                  fromDateText.isEmpty ? white24 : white),
                              Spacer(),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: white24,
                              )
                            ],
                          )),
                    ],
                  ),
                )),
                customWidthBox(20),

                //End Date
                Flexible(
                    child: InkWell(
                  onTap: () {
                    openBottomSheet(context, "to");
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      customHeightBox(10),
                      Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black, offset: Offset(0, 2))
                              ]),
                          height: 50,
                          child: Row(
                            children: [
                              customText(toDateText.isEmpty ? "To" : toDateText,
                                  15, toDateText.isEmpty ? white24 : white),
                              Spacer(),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: white24,
                              )
                            ],
                          )),
                    ],
                  ),
                ))
              ],
            ),
            customHeightBox(10),
            //Checkbox With text
            Container(
              child: Row(
                children: <Widget>[
                  Checkbox(
                    checkColor: white,
                    activeColor: circleColor,
                    value: isChecked,
                    onChanged: (value) {
                      setState(() {
                        isChecked = value!;
                      });
                    },
                  ),
                  customText("I currently living here", 15, white),
                  customWidthBox(80)
                ],
              ),
            ),
            customHeightBox(50),
            //save button
            Center(
              child: InkWell(
                onTap: () {
                  addTheVisitPlace();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: phoneWidth(context) / 2,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    gradient: commonButtonLinearGridient,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: customText("Save", 15, white),
                ),
              ),
            )
          ],
        )),
      ),
    ));
  }

  //BottomSheet
  void openBottomSheet(BuildContext context, String type) {
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
                height: 300,
                margin: EdgeInsets.only(top: 30),
                decoration: commonBoxDecoration(),
                child: Column(
                  crossAxisAlignment: cCenter,
                  children: [
                    Row(
                      mainAxisAlignment: mCenter,
                      crossAxisAlignment: cCenter,
                      children: [
                        Spacer(),
                        Spacer(),
                        customText("Pick Date", 15, white),
                        Spacer(),
                        customWidthBox(25),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: customText("Done", 14, circleColor))
                      ],
                    ),
                    customDivider(10, white),
                    customHeightBox(10),
                    Container(
                      height: 200,
                      child: CupertinoTheme(
                        data: const CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          dateOrder: DatePickerDateOrder.dmy,
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime(1980, 1, 1),
                          onDateTimeChanged: (DateTime newDateTime) {
                            setState(() {
                              //hh:mm:ss
                              final timestamp1 =
                                  newDateTime.millisecondsSinceEpoch;
                              print(timestamp1);
                              String formattedDate =
                                  DateFormat('MM-yyyy').format(newDateTime);
                              if (type == "from") {
                                setState(() {
                                  fromText = timestamp1.toString();
                                  fromDateText = formattedDate;
                                });
                              } else if (type == "to") {
                                setState(() {
                                  toText = timestamp1.toString();
                                  toDateText = formattedDate;
                                });
                              }
                              // dateOfBirth = formattedDate;
                              print(formattedDate);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ));
          });
        });
  }

  //Get All lists(Country , State , Cities)
  //Country Selection dialogbox
  void showCountryDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: phoneHeight(context),
                  decoration: BoxDecoration(
                      color: gray1, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: cCenter,
                    children: [
                      Row(
                        crossAxisAlignment: cCenter,
                        mainAxisAlignment: mCenter,
                        children: [
                          Spacer(),
                          Spacer(),
                          customText("Search Country", 15, white),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close))
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                        child: TextField(
                          onChanged: ((value) {
                            state(() {
                              searchCountry = value;
                            });
                          }),
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter country name!",
                              contentPadding: EdgeInsets.only(left: 10),
                              hintStyle: TextStyle(color: Colors.white24)),
                        ),
                      ),
                      customHeightBox(10),
                      Expanded(
                          child: FutureBuilder<CountryModel>(
                        future: _getSearchCountriesList(searchCountry),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.data!.length,
                                  itemBuilder: (context, index) {
                                    String flageCode = snapshot
                                        .data!.data![index].iso2!
                                        .toString()
                                        .toLowerCase();
                                    String fullImageUrl =
                                        flagImageUrl! + flageCode + ".png";
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          countryName = snapshot
                                              .data!.data![index].name
                                              .toString();
                                          stateName = "";
                                          cityName = "";
                                          countryId = snapshot
                                              .data!.data![index].id
                                              .toString();
                                          print(countryId);
                                          Navigator.pop(context);
                                          getListOfStates(countryId);
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        margin: EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(color: gray4D)),
                                        height: 40,
                                        child: Row(children: [
                                          CachedNetworkImage(
                                            height: 35,
                                            width: 35,
                                            imageUrl: fullImageUrl,
                                            placeholder: (context, url) =>
                                                Icon(Icons.flag),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          customWidthBox(10),
                                          customText(
                                              snapshot.data!.data![index].name
                                                  .toString(),
                                              15,
                                              white),
                                        ]),
                                      ),
                                    );
                                  })
                              : customText("No data available", 15, white);
                        },
                      ))
                    ],
                  ),
                ));
          });
        });
  }

  //State selection dialog box
  void showStatesDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                child: Container(
                    padding: EdgeInsets.all(10),
                    height: phoneHeight(context),
                    decoration: BoxDecoration(
                        color: gray1, borderRadius: BorderRadius.circular(10)),
                    child: Column(crossAxisAlignment: cCenter, children: [
                      //Header
                      Row(
                        crossAxisAlignment: cCenter,
                        mainAxisAlignment: mCenter,
                        children: [
                          Spacer(),
                          Spacer(),
                          customText("Select State", 15, white),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close))
                        ],
                      ),

                      //Search Bar
                      Container(
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                        child: TextField(
                          onChanged: ((value) {
                            state(() {
                              searchState = value;
                            });
                          }),
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter state name!",
                              contentPadding: EdgeInsets.only(left: 10),
                              hintStyle: TextStyle(color: Colors.white24)),
                        ),
                      ),
                      customHeightBox(10),

                      //List of states
                      Expanded(
                          child: FutureBuilder<StatesModel>(
                        future: _getSearchStatesList(searchState),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.data!.length,
                                  itemBuilder: (context, index) {
                                    String? fullName = snapshot
                                        .data!.data![index].name
                                        .toString();
                                    return Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10, bottom: 10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(color: gray4D)),
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              stateName = fullName;
                                              cityName = "";
                                              stateId = snapshot
                                                  .data!.data![index].id
                                                  .toString();
                                              Navigator.pop(context);
                                              getListOfCity(stateId);
                                            });
                                          },
                                          child:
                                              customText(fullName, 15, white)),
                                    );
                                  })
                              : customText("No data available", 15, white);
                        },
                      ))
                    ])));
          });
        });
  }

  //City Selection dialog box
  void showCitiessDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                child: Container(
                    padding: EdgeInsets.all(10),
                    height: phoneHeight(context),
                    decoration: BoxDecoration(
                        color: gray1, borderRadius: BorderRadius.circular(10)),
                    child: Column(crossAxisAlignment: cCenter, children: [
                      //Header
                      Row(
                        crossAxisAlignment: cCenter,
                        mainAxisAlignment: mCenter,
                        children: [
                          Spacer(),
                          Spacer(),
                          customText("Select City", 15, white),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close))
                        ],
                      ),

                      //Search Bar
                      Container(
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                        child: TextField(
                          onChanged: ((value) {
                            state(() {
                              searchCity = value;
                            });
                          }),
                          keyboardType: TextInputType.multiline,
                          maxLines: 1,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter city name!",
                              contentPadding: EdgeInsets.only(left: 10),
                              hintStyle: TextStyle(color: Colors.white24)),
                        ),
                      ),
                      customHeightBox(10),

                      //List of states
                      Expanded(
                          child: FutureBuilder<CitiesModel>(
                        future: _getSearchCitiesList(searchCity),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.data!.length,
                                  itemBuilder: (context, index) {
                                    String? fullName = snapshot
                                        .data!.data![index].name
                                        .toString();
                                    return Container(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 10, bottom: 10),
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(color: gray4D)),
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              cityName = fullName;
                                              cityId = snapshot
                                                  .data!.data![index].sId
                                                  .toString();
                                              Navigator.pop(context);
                                            });
                                          },
                                          child:
                                              customText(fullName, 15, white)),
                                    );
                                  })
                              : customText("No data available", 15, white);
                        },
                      ))
                    ])));
          });
        });
  }

  // Get/Set Response of StateList
  void getListOfStates(String id) {
    Future.delayed(Duration.zero, () {
      _getStatesList = getStatesList(context, id);
      _getStatesList!.whenComplete(() => {setState(() {})});
    });
  }

  // Get/Set Response of CityList
  void getListOfCity(String id) {
    Future.delayed(Duration.zero, () {
      _getCityList = getCitiessList(context, id);
      _getCityList!.whenComplete(() => {setState(() {})});
    });
  }

  //Add the visit place
  void addTheVisitPlace() {
    if (countryName.isEmpty) {
      customToastMsg("Please select the country!");
      return;
    } else if (stateName.isEmpty) {
      customToastMsg("Please select the state!");
      return;
    } else if (cityName.isEmpty) {
      customToastMsg("Please select the city");
      return;
    } else if (fromText.isEmpty) {
      customToastMsg("Please select the start date!");
      return;
    } else if (!isChecked) {
      if (toText.isEmpty) {
        customToastMsg("Please select the end date");
        return;
      }
      int to = int.parse(toText);
      int from = int.parse(fromText);
      if (to < from) {
        customToastMsg(
            "Please select another end date(Greater then start date) ");
        return;
      }
    }

    Map data = {
      "country": countryName,
      "state": stateName,
      "city": cityName,
      "from": fromText,
      'to':
          isChecked ? DateTime.now().millisecondsSinceEpoch.toString() : toText,
      'current': isChecked ? "1" : "0"
    };

    addVisitPlaceApi(data);
  }

  //Add and Update Visit Place api
  Future<void> addVisitPlaceApi(Map data) async {
    if (widget.dataMap.isNotEmpty) {
      data.addAll({"visit_id": isUpdateId});
    }

    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    print(token);

    if (token == null) {
      Navigator.pop(context);
      customToastMsg("Invalid token!");
      return;
    }
    var response = await http.post(
        Uri.parse(widget.dataMap.isEmpty
            ? BASE_URL + "visit"
            : BASE_URL + "update_visit"),
        headers: {'api-key': API_KEY, 'x-access-token': token},
        body: data);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      widget.dataMap.isEmpty
          ? customToastMsg("Visit location added successfully!")
          : customToastMsg("Visit location update successfully!");
      Navigator.of(context).pop();
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }

  updateapi() {
    if (widget.dataMap.isNotEmpty) {
      countryName = widget.dataMap["country"].toString();
      stateName = widget.dataMap["state"].toString();
      cityName = widget.dataMap["city"].toString();
      isUpdateId = widget.dataMap["id"].toString();
      countryName = widget.dataMap["country"].toString();
      fromText = widget.dataMap["fromText"].toString();
      toText = widget.dataMap["toText"].toString();
      fromDateText = widget.dataMap["fromDateText"].toString();
      toDateText = widget.dataMap["toDateText"].toString();
    }
  }

  //Searching of Country , State ,City

  //Country
  Future<CountryModel> _getSearchCountriesList(String search) async {
    CountryModel mm = await _getCountriesList!;
    var ss = mm.toJson();
    CountryModel model = CountryModel.fromJson(ss);

    if (search.isEmpty) {
      return model;
    }

    int i = 0;
    while (i < model.data!.length) {
      if (!model.data![i].name
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase())) {
        model.data!.removeAt(i);
      } else {
        i++;
      }
    }
    return model;
  }

  //State
  Future<StatesModel> _getSearchStatesList(String search) async {
    StatesModel mm = await _getStatesList!;
    var ss = mm.toJson();
    StatesModel model = StatesModel.fromJson(ss);
    if (search.isEmpty) {
      return model;
    }
    int i = 0;
    while (i < model.data!.length) {
      if (!model.data![i].name
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase())) {
        model.data!.removeAt(i);
      } else {
        i++;
      }
    }
    return model;
  }

  //City
  Future<CitiesModel> _getSearchCitiesList(String search) async {
    CitiesModel mm = await _getCityList!;
    var ss = mm.toJson();
    CitiesModel model = CitiesModel.fromJson(ss);
    if (search.isEmpty) {
      return model;
    }
    int i = 0;
    while (i < model.data!.length) {
      if (!model.data![i].name
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase())) {
        model.data!.removeAt(i);
      } else {
        i++;
      }
    }
    return model;
  }
}
