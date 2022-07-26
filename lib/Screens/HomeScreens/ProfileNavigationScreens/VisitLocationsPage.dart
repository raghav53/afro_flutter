import 'package:afro/Model/VisitModel.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/AddEducation.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/AddVisitLocationPage.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/AddWork.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LocationPageScreen extends StatefulWidget {
  const LocationPageScreen({Key? key}) : super(key: key);

  @override
  _Location createState() => _Location();
}

Future<VisitModel>? _getAllLocationPlace;
Map dataMap = {};

class _Location extends State<LocationPageScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getAllLocationPlace = getAllLivedPlace(context);
      setState(() {});
      _getAllLocationPlace!.whenComplete(() => setState(() {}));
    });
  }

  @override
  void updateAll() {
    Future.delayed(Duration.zero, () {
      _getAllLocationPlace = getAllLivedPlace(context);
      setState(() {});
      _getAllLocationPlace!.whenComplete(() => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: commonAppbar("Placed live in"),
      floatingActionButton: GestureDetector(
        onTap: () {
          dataMap.clear();
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) =>
                      AddTimelinePageScreen(dataMap: dataMap)))
              .then((value) => updateAll());
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
        height: phoneHeight(context),
        width: phoneWidth(context),
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              customHeightBox(80),
              //Search education university
              Container(
                child: Column(
                  children: [
                    //Search list
                    Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: 50,
                      child: const TextField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(top: 14, left: 15),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Color(0xFFDFB48C),
                            ),
                            hintText: "Email/ User Name",
                            hintStyle: TextStyle(color: Colors.white24)),
                      ),
                    ),

                    FutureBuilder<VisitModel>(builder: (context, snapshot) {
                      return Container();
                    })
                  ],
                ),
              ),
              customHeightBox(20),
              FutureBuilder<VisitModel>(
                  future: _getAllLocationPlace,
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.data!.length,
                            itemBuilder: (context, index) {
                              String cityName =
                                  snapshot.data!.data![index].city.toString();
                              String countryName = snapshot
                                  .data!.data![index].country
                                  .toString();

                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                    color: black,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.only(
                                    top: 5, bottom: 5, left: 10, right: 10),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      height: 30,
                                      width: 30,
                                      imageUrl: country_code_url +
                                          snapshot.data!.data![index].iso2
                                              .toString()
                                              .toLowerCase() +
                                          ".png",
                                      imageBuilder: (context, url) {
                                        return CircleAvatar(
                                          backgroundImage: url,
                                        );
                                      },
                                    ),
                                    customWidthBox(15),
                                    Column(
                                      crossAxisAlignment: cStart,
                                      children: [
                                        customText(cityName, 13, yellowColor),
                                        customHeightBox(5),
                                        customText(countryName, 10, white),
                                        customHeightBox(5),
                                        customText(
                                            convetDateFormat(snapshot
                                                    .data!.data![index].from
                                                    .toString()) +
                                                "  to  " +
                                                convetDateFormat(snapshot
                                                    .data!.data![index].to
                                                    .toString()),
                                            11,
                                            white)
                                      ],
                                    ),
                                    Spacer(),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            showDeleteDialog(snapshot
                                                .data!.data![index].sId
                                                .toString());
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                                color: red,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: const Icon(
                                              Icons.delete,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        customWidthBox(10),
                                        InkWell(
                                          onTap: () {
                                            dataMap = {
                                              "country": snapshot
                                                  .data!.data![index].country
                                                  .toString(),
                                              "state": snapshot
                                                  .data!.data![index].state
                                                  .toString(),
                                              "city": snapshot
                                                  .data!.data![index].city
                                                  .toString(),
                                              "id": snapshot
                                                  .data!.data![index].sId
                                                  .toString(),
                                              "fromText": snapshot
                                                  .data!.data![index].from
                                                  .toString(),
                                              "toText": snapshot
                                                  .data!.data![index].to
                                                  .toString(),
                                              "fromDateText": convetDateFormat(
                                                  snapshot
                                                      .data!.data![index].from
                                                      .toString()),
                                              "toDateText": convetDateFormat(
                                                  snapshot.data!.data![index].to
                                                      .toString()),
                                            };
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddTimelinePageScreen(
                                                            dataMap: dataMap)));
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                                gradient:
                                                    commonButtonLinearGridient,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                            child: const Icon(
                                              Icons.edit,
                                              size: 20,
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            })
                        : Center(
                            child: customText("No data available!", 15, white),
                          );
                  })
            ],
          ),
        ),
      ),
    ));
  }

  void showDeleteDialog(String itemId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                height: 130,
                width: 200,
                decoration: BoxDecoration(
                    color: gray1, borderRadius: BorderRadius.circular(10)),
                child: Column(crossAxisAlignment: cCenter, children: [
                  customHeightBox(15),
                  customText("Delete lcoation Item!", 15, white),
                  customDivider(10, white),
                  customHeightBox(5),
                  customText(
                      "Do you want to delete this location item?", 12, white24),
                  customHeightBox(30),
                  Row(
                    mainAxisAlignment: mCenter,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            deleteVisitPlaceItem(context, itemId);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => super.widget));
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 7, bottom: 7, left: 30, right: 30),
                          decoration: BoxDecoration(
                              gradient: commonButtonLinearGridient,
                              borderRadius: BorderRadius.circular(10)),
                          child: customText("Delete", 13, white),
                        ),
                      ),
                      customWidthBox(15),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 7, bottom: 7, left: 30, right: 30),
                          decoration: BoxDecoration(
                              gradient: commonButtonLinearGridient,
                              borderRadius: BorderRadius.circular(10)),
                          child: customText("Cancel", 13, white),
                        ),
                      )
                    ],
                  )
                ]),
              ));
        });
  }
}
