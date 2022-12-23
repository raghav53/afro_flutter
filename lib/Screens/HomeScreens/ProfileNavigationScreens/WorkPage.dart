import 'dart:convert';

import 'package:afro/Model/WorkExperience.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/AddWork.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class WorkPageScreen extends StatefulWidget {
  _Work createState() => _Work();
}

TextEditingController search = TextEditingController();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<WorkExperience>? futureWork;
Map dataMap = {};

class _Work extends State<WorkPageScreen> {
  @override
  void refreshData() {
    Future.delayed(Duration.zero, () {
      futureWork = getAllWorkExpireince(context);
      setState(() {});
      futureWork!.whenComplete(() => {setState(() {})});
    });
    //log("onResume / viewWillAppear / onFocusGained");
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      futureWork = getAllWorkExpireince(context);
      futureWork!.whenComplete(() => {setState(() {})});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: commonAppbar("Work"),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                  builder: (context) => AddWorkPage(
                        dataMap: dataMap,
                      )))
              .then((value) => refreshData());
        },
        child: Container(
          alignment: Alignment.center,
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: commonButtonLinearGridient),
            child:  Image.asset("assets/icons/add.png",height: 25,width: 25,color: Colors.white,)
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 70),
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Search Work Experience
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
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
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.white24)),
                ),
              ),

              FutureBuilder<WorkExperience>(
                  future: futureWork,
                  builder: (context, snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                margin: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                color:Colors.black,
                                elevation: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      //Image
                                      Image(
                                        image: const AssetImage(
                                            "assets/icons/briefcase.png"),
                                        color: circleColor,
                                        height: 45,
                                        width: 45,
                                      ),
                                      //Information of Work
                                      customWidthBox(20),
                                      Column(
                                        crossAxisAlignment: cStart,
                                        children: [
                                          customText(
                                              snapshot.data!.data![index]
                                                  .position!
                                                  .toString(),
                                              15,
                                              white),
                                          customHeightBox(5),
                                          customText(
                                              snapshot.data!.data![index]
                                                  .company!
                                                  .toString(),
                                              12,
                                              white),
                                          customHeightBox(5),
                                          customText(
                                              convetDateFormat(snapshot
                                                      .data!
                                                      .data![index]
                                                      .from
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
                                              padding:
                                                  const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  color: red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
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
                                                "id": snapshot
                                                    .data!.data![index].sId
                                                    .toString(),
                                                "position": snapshot.data!
                                                    .data![index].position
                                                    .toString(),
                                                "company": snapshot.data!
                                                    .data![index].company,
                                                "fromText": snapshot.data!
                                                    .data![index].from,
                                                "toText": snapshot
                                                    .data!.data![index].to,
                                                "fromDateText":
                                                    convetDateFormat(
                                                        snapshot
                                                            .data!
                                                            .data![index]
                                                            .from
                                                            .toString()),
                                                "toDateText":
                                                    convetDateFormat(
                                                        snapshot.data!
                                                            .data![index].to
                                                            .toString()),
                                              };
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AddWorkPage(
                                                              dataMap:
                                                                  dataMap)));
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(3),
                                              decoration: BoxDecoration(
                                                  gradient:
                                                      commonButtonLinearGridient,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
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
                                ),
                              );
                            })
                        : Center(
                            child: customText(
                                "Failed to load the data", 15, white),
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
                  customText("Delete Work History Item!", 15, white),
                  customDivider(10, white),
                  customHeightBox(5),
                  customText(
                      "Do you want to delete this work item?", 12, white24),
                  customHeightBox(30),
                  Row(
                    mainAxisAlignment: mCenter,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            deleteWorkItem(context, itemId);
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => super.widget));
                            // getAllWorkExpireince(context);
                            setState(() {});
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
