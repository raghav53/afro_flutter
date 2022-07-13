import 'dart:convert';
import 'package:afro/Model/CountryModel.dart';
import 'package:afro/Model/Dashboard/ChangeCommunityModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SearchLocationScreen extends StatefulWidget {
  const SearchLocationScreen({Key? key}) : super(key: key);
  @override
  State<SearchLocationScreen> createState() => _SearchLocationScreenState();
}

TextEditingController countryName = TextEditingController();
String? searchCountry = "";
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
CountryModel? countryModel;

CountryModel searchModel = CountryModel();
bool isLoaded = false;
Future<CountryModel>? _getCountries;

class _SearchLocationScreenState extends State<SearchLocationScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getCountries = getCountriesList(context);
      setState(() {});
      _getCountries!.whenComplete(() => () {});
    });
  }

  getSearchCountry(String search) {
    setState(() {
      if (countryModel != null) {
        if (countryModel!.data != null) {
          searchModel.data = <Data>[];
          for (var element in countryModel!.data!) {
            if (element.name
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: commonAppbar("Search Location"),
        body: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          padding: const EdgeInsets.only(left: 15, right: 15),
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                customHeightBox(80),
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
                      getSearchCountry(value);
                    },
                    controller: countryName,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFFDFB48C),
                        ),
                        border: InputBorder.none,
                        hintText: "Search",
                        contentPadding: EdgeInsets.only(left: 15, top: 15),
                        hintStyle: TextStyle(color: Colors.white24)),
                  ),
                ),
                customHeightBox(25),
                FutureBuilder<CountryModel>(
                    future: _getCountries,
                    builder: (context, snapshot) {
                      return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                          ? Container(
                              height: phoneHeight(context) / 1.25,
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.data!.length,
                                  physics: const ClampingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    String code = snapshot
                                        .data!.data![index].iso2!
                                        .toLowerCase();
                                    String? flagCode = code + ".png";
                                    String countryId = snapshot
                                        .data!.data![index].sId
                                        .toString();
                                    String? name = snapshot
                                        .data!.data![index].name
                                        .toString();
                                    return InkWell(
                                      onTap: () {
                                        changeTheCommunity(context, countryId);
                                      },
                                      child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        padding: const EdgeInsets.only(
                                            top: 5,
                                            bottom: 5,
                                            left: 10,
                                            right: 10),
                                        decoration: BoxDecoration(
                                            color: gray1,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Row(children: [
                                          CachedNetworkImage(
                                            height: 35,
                                            width: 35,
                                            imageUrl: flagImageUrl! + flagCode,
                                            placeholder: (context, url) =>
                                                const Icon(Icons.flag),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          customWidthBox(10),
                                          customText(name, 15, white),
                                        ]),
                                      ),
                                    );
                                  }),
                            )
                          : Center(
                              child: customText("No data found!", 15, white),
                            );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
