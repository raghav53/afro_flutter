import 'dart:async';
import 'dart:convert';

import 'package:afro/Model/CitiesModel.dart';
import 'package:afro/Model/CountryModel.dart';
import 'package:afro/Model/StatesModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/SearchLocationScreen.dart';
import 'package:afro/Util/SharedPreferencfes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/SignUpProcess/UploadPhotoPage.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FillInformation extends StatefulWidget {
  String? token;
  FillInformation({required this.token});

  @override
  _Information createState() => _Information();
}

TextEditingController homeTown = TextEditingController();
TextEditingController bio = TextEditingController();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

String CountryName = "";
String StateName = "";
String CityName = "";
String Gender = "";
String userBio = "";
String homeAdd = "";

//Country Api
CountryModel? countryModel;
CountryModel searchModel = CountryModel();

//State Api
String cId = "";
StatesModel? statesModel;

//City Api
String sID = "";
String cityId = "";
CitiesModel? citiesModel;

//Database ids
String country = "";
String state = "";
String city = "";

class _Information extends State<FillInformation> {
  String? selectedCountry;
  String? selectedGender;
  final _countries = ["India", "Australia", "Newzland", "England"];
  final _gender = ["Male", "Female", "Others"];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: onlyTitleCommonAppbar("Tell Us More About You"),
        body: Container(
          padding: EdgeInsets.only(top: 70, left: 20, right: 20),
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customText("Update your info", 15, white),
                customHeightBox(10),
                customText(
                    "Share your information with our community", 12, white),
                customHeightBox(10),
                customDivider(10, gray4D),
                customHeightBox(15),
                customText("LOCATION", 15, white),
                customHeightBox(20),

                //For Country selection
                customText("COUNTRY", 12, white),
                customHeightBox(10),
                InkWell(
                  onTap: () {
                    showProgressDialogBox(context);
                    getAlllCountries();
                  },
                  child: Container(
                    width: 500,
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 15, right: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: black),
                    child: Row(
                      children: [
                        customText(
                          CountryName.isEmpty ? "Country" : CountryName,
                          15,
                          CountryName.isEmpty ? white24 : white,
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_drop_down_outlined,
                          color: gray1,
                        )
                      ],
                    ),
                  ),
                ),
                customHeightBox(20),

                //For State selection
                customText("STATE", 12, white),
                customHeightBox(10),
                InkWell(
                  onTap: () {
                    if (cId.isEmpty) {
                      customToastMsg("Please select the state!");
                      return;
                    }
                    showProgressDialogBox(context);
                    getAllStates(cId);
                  },
                  child: Container(
                    width: 500,
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 15, right: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), color: black),
                    child: Row(
                      children: [
                        customText(
                          StateName.isEmpty ? "State" : StateName,
                          15,
                          StateName.isEmpty ? white24 : white,
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_drop_down_outlined,
                          color: gray1,
                        )
                      ],
                    ),
                  ),
                ),
                customHeightBox(20),
                buildLocationInfo(),
                customHeightBox(10),
                customText("I AM", 12, white),
                customHeightBox(10),
                Container(
                  padding: EdgeInsets.only(left: 16),
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
                          dropdownColor: Colors.black,
                          value: selectedGender,
                          isDense: true,
                          onChanged: (val) {
                            setState(() {
                              selectedGender = val;
                              state.didChange(val);
                              Gender = val.toString();
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
                customHeightBox(20),
                customText("Bio", 12, white),
                customHeightBox(10),
                Container(
                  height: 120,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextField(
                    controller: bio,
                    keyboardType: TextInputType.multiline,
                    maxLines: 10,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter your bio",
                        contentPadding: EdgeInsets.only(left: 10, top: 12),
                        hintStyle: TextStyle(color: Colors.white24)),
                  ),
                ),
                //Save Button
                Center(
                  child: InkWell(
                    onTap: () {
                      SaveInformation();
                    },
                    child: Container(
                        width: 200,
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 50, right: 50),
                        margin: const EdgeInsets.only(top: 50, bottom: 30),
                        decoration: BoxDecoration(
                            gradient: commonButtonLinearGridient,
                            borderRadius: BorderRadius.circular(30)),
                        child: Center(
                          child: customText("Save", 15, white),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Get all countries
  Future<void> getAlllCountries() async {
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var jsonResponse = null;
    var response = await http.get(
      Uri.parse(BASE_URL + "countries"),
      headers: {'api-key': API_KEY, 'x-access-token': widget.token!},
    );
    jsonResponse = json.decode(response.body);
    countryModel = CountryModel.fromJson(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      showCountryDialog(context);
      searchModel = CountryModel.fromJson(jsonResponse);
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }

  //Get all States
  Future<void> getAllStates(String countryId) async {
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var jsonResponse = null;
    var response = await http.get(
      Uri.parse(BASE_URL + "states?country_id=${countryId}"),
      headers: {'api-key': API_KEY, 'x-access-token': widget.token!},
    );
    print("Response code ${response.statusCode}");
    jsonResponse = json.decode(response.body);

    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      showStateDialog(context);
      statesModel = StatesModel.fromJson(jsonResponse);
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }

  //Get all cities
  Future<void> getAllCitiess(String stateID) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var jsonResponse = null;
    var response = await http.get(
      Uri.parse(BASE_URL + "cities?state_id=${stateID}"),
      headers: {'api-key': API_KEY, 'x-access-token': widget.token!},
    );
    jsonResponse = json.decode(response.body);

    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      citiesModel = CitiesModel.fromJson(jsonResponse);
      showCityDialog(context);
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }

  //Location Information
  Widget buildLocationInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: Column(
          crossAxisAlignment: cStart,
          children: [
            customText("Current City", 12, white),
            customHeightBox(10),
            InkWell(
              onTap: () {
                if (sID.isEmpty) {
                  customToastMsg("Please select the state!");
                  return;
                }
                getAllCitiess(sID);
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
                      CityName.isEmpty ? "Current City" : CityName,
                      15,
                      CityName.isEmpty ? white24 : white,
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_drop_down_outlined,
                      color: gray1,
                    )
                  ],
                ),
              ),
            )
          ],
        )),
        customWidthBox(20),
        Flexible(
            child: buildCustomEdittext(
          "HomeTown",
        ))
      ],
    );
  }

  Widget emptyDatalist() {
    return Container(
      child: Center(child: customText("No data found", 15, white)),
    );
  }

  Widget buildCustomEdittext(String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        customText(text, 12, white),
        customHeightBox(10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]),
          height: 50,
          child: TextField(
            controller: homeTown,
            keyboardType: TextInputType.text,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: const EdgeInsets.only(left: 15),
                hintText: text,
                hintStyle: const TextStyle(color: Colors.white24)),
          ),
        )
      ],
    );
  }

  //Country Selection dialogbox
  void showCountryDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
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
                        customText("Select Country", 15, white),
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
                          setState(() {
                            getSearchCountry(value);
                          });
                        }),
                        controller: bio,
                        keyboardType: TextInputType.multiline,
                        maxLines: 1,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter country name!",
                            contentPadding: EdgeInsets.only(left: 10),
                            hintStyle: TextStyle(color: Colors.white24)),
                      ),
                    ),
                    customHeightBox(10),
                    Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: searchModel.data?.length,
                          itemBuilder: (context, index) {
                            String code = searchModel.data == null
                                ? ""
                                : searchModel.data![index].iso2!.toLowerCase();
                            String? flagCode = code + ".png";
                            String? name = searchModel.data == null
                                ? ""
                                : searchModel.data![index].name.toString();
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  StateName = "";
                                  CityName = "";
                                  country =
                                      searchModel.data![index].sId.toString();
                                  cId = searchModel.data![index].id.toString();
                                  CountryName =
                                      searchModel.data![index].name.toString();
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: gray4D)),
                                height: 40,
                                child: Row(children: [
                                  CachedNetworkImage(
                                    height: 35,
                                    width: 35,
                                    imageUrl: flagImageUrl! + flagCode,
                                    placeholder: (context, url) =>
                                        Icon(Icons.flag),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                  customWidthBox(10),
                                  customText(name, 15, white),
                                ]),
                              ),
                            );
                          }),
                    )
                  ],
                ),
              ));
        });
  }

  //State Selection dialogbox
  void showStateDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                padding: EdgeInsets.all(10),
                height: phoneHeight(context),
                decoration: BoxDecoration(
                    color: gray1, borderRadius: BorderRadius.circular(10)),
                child: Column(crossAxisAlignment: cCenter, children: [
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
                  Container(
                    decoration: BoxDecoration(
                        color: black, borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                    child: TextField(
                      onChanged: ((value) {
                        setState(() {
                          getSearchCountry(value);
                        });
                      }),
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter state name!",
                          contentPadding: EdgeInsets.only(left: 10),
                          hintStyle: TextStyle(color: Colors.white24)),
                    ),
                  ),
                  customHeightBox(10),
                  Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: statesModel!.data!.length,
                          itemBuilder: (context, index) {
                            String sName =
                                statesModel!.data![index].title.toString();
                            return statesModel!.data == null
                                ? emptyDatalist()
                                : Container(
                                    padding: EdgeInsets.only(
                                        left: 10, top: 10, bottom: 10),
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: gray4D)),
                                    child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            CityName = "";
                                            StateName = sName;
                                            state = statesModel!
                                                .data![index].sId
                                                .toString();
                                            sID = statesModel!.data![index].id
                                                .toString();
                                            Navigator.pop(context);
                                          });
                                        },
                                        child: customText(sName, 15, white)),
                                  );
                          }))
                ]),
              ));
        });
  }

  //City Selection dialogbox
  void showCityDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                padding: EdgeInsets.all(10),
                height: phoneHeight(context),
                decoration: BoxDecoration(
                    color: gray1, borderRadius: BorderRadius.circular(10)),
                child: Column(crossAxisAlignment: cCenter, children: [
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
                  Container(
                    decoration: BoxDecoration(
                        color: black, borderRadius: BorderRadius.circular(10)),
                    margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                    child: TextField(
                      onChanged: ((value) {
                        setState(() {});
                      }),
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter City name!",
                          contentPadding: EdgeInsets.only(left: 10),
                          hintStyle: TextStyle(color: Colors.white24)),
                    ),
                  ),
                  customHeightBox(10),
                  Expanded(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: citiesModel!.data!.length,
                          itemBuilder: (context, index) {
                            String cName =
                                citiesModel!.data![index].name.toString();
                            return Container(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, bottom: 10),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: gray4D)),
                              child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      CityName = cName;
                                      city = citiesModel!.data![index].sId
                                          .toString();
                                      Navigator.pop(context);
                                    });
                                  },
                                  child: customText(cName, 15, white)),
                            );
                          }))
                ]),
              ));
        });
  }

  getSearchCountry(String search) {
    setState(() {
      if (countryModel != null) {
        if (countryModel!.data != null) {
          searchModel.data = [];
          for (var element in countryModel!.data!) {
            if (element.title
                .toString()
                .toLowerCase()
                .contains(search.toLowerCase())) {
              searchModel.data!.add(element);
            }
          }
        }
      }
    });
  }

  void SaveInformation() {
    homeAdd = homeTown.text.toString();
    userBio = bio.text.toString();
    if (country.isEmpty) {
      customToastMsg("Please select the country!");
      return;
    }
    if (state.isEmpty) {
      customToastMsg("Please select the state!");
      return;
    }
    if (city.isEmpty) {
      customToastMsg("Please select city!");
      return;
    }

    if (homeAdd.isEmpty) {
      customToastMsg("Please enter the hometown address");
      return;
    }
    if (Gender.isEmpty) {
      customToastMsg("Please select the gender!");
      return;
    }
    if (userBio.isEmpty) {
      customToastMsg("Please enter the bio!");
      return;
    }
    UpdateTheUserInfo(homeAdd, userBio);
  }

  Future<void> UpdateTheUserInfo(String hommTownAdd, String uBio) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    Map data = {
      'gender': Gender,
      'country': country,
      'state': state,
      'city': city,
      'hometown': hommTownAdd,
      'bio': uBio
    };
    print(cId);
    print(sID);
    print(cityId);
    var jsonResponse = null;
    var response = await http.post(Uri.parse(BASE_URL + "update_user"),
        headers: {'api-key': API_KEY, 'x-access-token': widget.token!},
        body: data);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      SaveStringToSF("newuser", "infofilled");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UploadPhotoPage()));
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }
}
