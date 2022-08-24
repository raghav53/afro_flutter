import 'dart:convert';

import 'package:afro/Model/CitiesModel.dart';
import 'package:afro/Model/CountryModel.dart';
import 'package:afro/Model/StatesModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:http/http.dart' as http;
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/ProfileSettingScreenPage.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BasicInformation extends StatefulWidget {
  const BasicInformation({Key? key}) : super(key: key);

  @override
  _Basic createState() => _Basic();
}

String dateOfBirth = "",
    dobTimeStamp = "",
    gender = "",
    firstName = "",
    lastName = "",
    email = "",
    homeTown = "",
    sTwitter = "",
    sInstagram = "",
    sFacebook = "",
    sWebsite = "",
    sLinkedIn = "",
    stateName = "",
    bio = "",
    dobStamp = "",
    city = "",
    country = "";
String countryId = "", stateId = "", cityId = "";
final _gender = ["Male", "Female", "Others"];
String? selectedGender;

TextEditingController fName = TextEditingController();
TextEditingController lName = TextEditingController();
TextEditingController instagram = TextEditingController();
TextEditingController twitter = TextEditingController();
TextEditingController facebook = TextEditingController();
TextEditingController linkdin = TextEditingController();
TextEditingController website = TextEditingController();
TextEditingController hometown = TextEditingController();
TextEditingController userBio = TextEditingController();

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//SharedPreferences sharedData = _prefs;
var user = UserDataConstants();

//Country
Future<CountryModel>? _getCountriesList;

//State
Future<StatesModel>? _getStatesList;

//City
Future<CitiesModel>? _getCityList;

class _Basic extends State<BasicInformation> {
  @override
  void initState() {
    super.initState();
    getUserData();

    Future.delayed(Duration.zero, () {
      _getCountriesList = getCountriesList(context);
      setState(() {});
      _getCountriesList!.whenComplete(() => () {});
    });
  }

  //Get the information from shared Preferences
  getUserData() async {
    SharedPreferences sharedPreferences = await _prefs;
    firstName = sharedPreferences.getString(user.firstName).toString();
    lastName = sharedPreferences.getString(user.lastName)!;
    email = sharedPreferences.getString(user.useremail).toString();
    dateOfBirth =
        convetFullFormat(sharedPreferences.getString(user.userdob).toString());
    dobStamp = sharedPreferences.getString(user.userdob).toString();
    dobTimeStamp = sharedPreferences.getString(user.userdob).toString();
    sInstagram = sharedPreferences.getString(user.instagram).toString();
    sLinkedIn = sharedPreferences.getString(user.linkdin).toString();
    sFacebook = sharedPreferences.getString(user.facebook).toString();
    sWebsite = sharedPreferences.getString(user.website).toString();
    sTwitter = sharedPreferences.getString(user.twitter).toString();
    country = sharedPreferences.getString(user.country).toString();
    city = sharedPreferences.getString(user.city).toString();
    stateName = sharedPreferences.getString(user.state).toString();
    homeTown = sharedPreferences.getString(user.hometown).toString();
    gender = sharedPreferences.getString(user.gender).toString();
    bio = sharedPreferences.getString(user.bio).toString();
    countryId = sharedPreferences.getString(user.countryId).toString();
    stateId = sharedPreferences.getString(user.stateId).toString();
    cityId = sharedPreferences.getString(user.cityId).toString();

    print(
        "country Id :-${countryId}\nstate Id :- $stateId \ncity Id:- $cityId");
    selectedGender = gender;
    setState(() {
      setTheBasicDataInformation();
    });
  }

  //set the information from shared Preferences
  setTheBasicDataInformation() {
    fName.text = firstName.toString();
    lName.text = lastName.toString();
    instagram.text = sInstagram.toString();
    website.text = sLinkedIn.toString();
    linkdin.text = sFacebook.toString();
    facebook.text = sWebsite.toString();
    twitter.text = sTwitter.toString();
    hometown.text = homeTown.toString();
    userBio.text = bio.toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: true,
            appBar: commonAppbar("Basic Information"),
            body: Container(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 80),
              height: phoneHeight(context),
              width: phoneWidth(context),
              decoration: commonBoxDecoration(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: cStart,
                  children: [
                    //Heading
                    customText("Your Login Details", 15, white),
                    customHeightBox(5),
                    customText(
                        "Share your information with our community", 13, white),
                    customHeightBox(30),
                    customText("Your Basic Details", 15, white),
                    customHeightBox(10),
                    customDivider(10, white),

                    //First Name
                    customHeightBox(20),
                    customEdittext("First Name", fName, "", firstName),

                    //Last Name
                    customHeightBox(20),
                    customEdittext("Last Name", lName, "", lastName),

                    /////////////////////////////////////////////////////////////////////////////
                    /***Location Information / Gender Selection  / Date Of Birth */
                    //Country
                    customHeightBox(20),
                    customText("Country", 15, white),
                    customHeightBox(10),
                    InkWell(
                      onTap: () {
                        showCountryDialog(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 10, right: 10),
                        width: phoneWidth(context),
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            customText(country.isEmpty ? "Country" : country,
                                12, country.isEmpty ? white24 : white),
                            Spacer(),
                            Icon(
                              Icons.arrow_drop_down_rounded,
                              color: yellowColor,
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
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 10, right: 10),
                        width: phoneWidth(context),
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            customText(stateName.isEmpty ? "State" : stateName,
                                12, stateName.isEmpty ? white24 : white),
                            Spacer(),
                            Icon(
                              Icons.arrow_drop_down_rounded,
                              color: yellowColor,
                            )
                          ],
                        ),
                      ),
                    ),

                    //City and Hometown
                    customHeightBox(20),
                    buildLocationInfo(),

                    //Gender
                    customHeightBox(20),
                    customText("I AM", 12, white),
                    customHeightBox(10),
                    Container(
                      padding: EdgeInsets.only(left: 16, right: 10),
                      decoration: BoxDecoration(
                        color: black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FormField(builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          isEmpty: selectedGender == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              icon: Icon(
                                Icons.arrow_drop_down_outlined,
                                color: yellowColor,
                              ),
                              dropdownColor: Colors.black,
                              value: selectedGender,
                              isDense: true,
                              onChanged: (val) {
                                setState(() {
                                  selectedGender = val;
                                  state.didChange(val);
                                  gender = val.toString();
                                });
                              },
                              items: _gender.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      }),
                    ),

                    //Date of Birth
                    customHeightBox(20),
                    customText("Date Of Birth", 15, white),
                    customHeightBox(10),
                    InkWell(
                      onTap: () {
                        openDateBottomSheet(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 10, right: 10),
                        width: phoneWidth(context),
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            customText(
                                dateOfBirth.isEmpty
                                    ? "Date Of Birth"
                                    : dateOfBirth,
                                12,
                                dateOfBirth.isEmpty ? white24 : white),
                            Spacer(),
                            Icon(
                              Icons.arrow_drop_down_rounded,
                              color: yellowColor,
                            )
                          ],
                        ),
                      ),
                    ),

                    /////////////////////////////////////////////////////////////////////////////////////////////////////

                    //Instagram
                    customHeightBox(20),
                    customEdittext("Instagram", instagram, "", sInstagram),

                    //Twitter
                    customHeightBox(20),
                    customEdittext("Twitter", twitter, "", sTwitter),

                    //Facebook
                    customHeightBox(20),
                    customEdittext("Facebook", facebook, "", sFacebook),

                    //Linkdin
                    customHeightBox(20),
                    customEdittext("Linked In", linkdin, "", sLinkedIn),

                    //Website
                    customHeightBox(20),
                    customEdittext("Business Website", website, "", sWebsite),

                    customHeightBox(20),
                    customText("Bio", 12, white),
                    customHeightBox(10),
                    Container(
                      height: 120,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: userBio,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter your bio",
                            contentPadding: EdgeInsets.only(left: 10, top: 12),
                            hintStyle: TextStyle(color: Colors.white24)),
                      ),
                    ),

                    customHeightBox(20),
                    Container(
                      padding: const EdgeInsets.only(left: 50, right: 50),
                      margin: const EdgeInsets.only(bottom: 30),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: InkWell(
                          onTap: () {
                            updateProfileInfo();
                          },
                          child: Container(
                              padding: const EdgeInsets.only(
                                  left: 50, right: 50, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: commonButtonLinearGridient),
                              child: customText("Save", 15, white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  //City and Hometown inrformation
  Widget buildLocationInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Column(
          crossAxisAlignment: cStart,
          children: [
            customText("Current City", 15, white),
            customHeightBox(10),
            InkWell(
              onTap: () {
                if (stateId.isEmpty) {
                  customToastMsg("Please select the state!");
                  return;
                }
                showCitiessDialog(context);
              },
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                height: 50,
                width: 160,
                decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    customText(
                      city.isEmpty ? "Current City" : city,
                      15,
                      city.isEmpty ? white24 : white,
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_drop_down_outlined,
                      color: yellowColor,
                    )
                  ],
                ),
              ),
            )
          ],
        )),
        customWidthBox(20),
        Flexible(child: customEdittext("HomeTown", hometown, "", homeTown))
      ],
    );
  }

  //get all State with api
  getState(String id) {
    Future.delayed(Duration.zero, () {
      _getStatesList = getStatesList(context, countryId);
      setState(() {});
      _getStatesList!.whenComplete(() => () {});
    });
  }

  //get the all cities api
  getCities(String id) {
    Future.delayed(Duration.zero, () {
      _getCityList = getCitiessList(context, stateId);
    });
  }

  //Show the dob picker dialog box
  openDateBottomSheet(BuildContext context) {
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
                              dobTimeStamp =
                                  newDateTime.millisecondsSinceEpoch.toString();
                              print("TimeStamp :-" + dobTimeStamp);
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(newDateTime);
                              dateOfBirth = formattedDate;
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
    return dateOfBirth;
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
                              // searchCountry = value;
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
                        future: _getCountriesList,
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
                                          country = snapshot
                                              .data!.data![index].name
                                              .toString();

                                          countryId = snapshot
                                              .data!.data![index].id
                                              .toString();
                                          print(countryId);
                                          Navigator.pop(context);
                                          getState(countryId);
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
                              //searchState = value;
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
                        future: _getStatesList,
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
                                              city = "";
                                              stateId = snapshot
                                                  .data!.data![index].id
                                                  .toString();
                                              Navigator.pop(context);
                                              getCities(stateId);
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
                              //searchCity = value;
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
                        future: _getCityList,
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
                                              city = fullName;
                                              cityId = snapshot
                                                  .data!.data![index].sId
                                                  .toString();

                                              print(
                                                  "Country Id :-$countryId\nState Id:-$stateId\nCity Id :-$cityId");
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

  //Update the profile api
  Future updateProfileInfo() async {
    if (firstName.toString().isEmpty) {
      customToastMsg("Please enter first name!");
      return;
    }
    if (lastName.toString().isEmpty) {
      customToastMsg("Please enter first name!");
      return;
    }
    if (countryId.isEmpty) {
      customToastMsg("Please select the country!");
      return;
    }
    if (stateId.isEmpty) {
      customToastMsg("Please select the state!");
      return;
    }
    if (cityId.isEmpty) {
      customToastMsg("Please select the city!");
      return;
    }
    if (gender.isEmpty) {
      customToastMsg("Please select your gender!");
      return;
    }
    if (dateOfBirth.isEmpty) {
      customToastMsg("Please pick you date of birth!");
      return;
    }
    if (bio.isEmpty) {
      customToastMsg("Please write your short bio!");
      return;
    }
    if (homeTown.isEmpty) {
      customToastMsg("Please write your short bio!");
      return;
    }

    Map data = {
      "first_name": firstName.toString(),
      "last_name": lastName.toString(),
      "gender": gender.toString(),
      "country": countryId.toString(),
      "state": stateId.toString(),
      "city": cityId.toString(),
      "hometown": homeTown.toString(),
      "dob": dobStamp.toString(),
      "bio": bio.toString(),
      "facebook": sFacebook.toString(),
      "instagram": sInstagram.toString(),
      "twitter": sTwitter.toString(),
      "linkdin": sLinkedIn.toString(),
      "website": sWebsite.toString()
    };
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    print(token);

    var response = await http.post(Uri.parse(BASE_URL + "update_user"),
        headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);

    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);

      customToastMsg("user profile updated successfully!");
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }

  //Custom Edittext
  Widget customEdittext(String s, TextEditingController controller, String data,
      String changeValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        customText(s, 15, Colors.white),
        customHeightBox(10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Colors.black, offset: Offset(0, 2))
              ]),
          height: 50,
          child: TextField(
            onChanged: (value) {
              setState(() {
                changeValue = value;
              });
            },
            textInputAction: TextInputAction.next,
            controller: controller,
            keyboardType: TextInputType.text,
            style: const TextStyle(fontSize: 14, color: Colors.white),
            decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15),
                hintStyle: TextStyle(color: Colors.white24)),
          ),
        ),
      ],
    );
  }
}
