import 'package:afro/Model/Education.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/AddEducation.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';

class EducationPageScreen extends StatefulWidget {
  const EducationPageScreen({Key? key}) : super(key: key);

  @override
  _Education createState() => _Education();
}

Future<Education>? getEducationLists;
Map dataMap = {};

class _Education extends State<EducationPageScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getEducationLists = getEducationList(context);
      getEducationLists!.whenComplete(() => {setState(() {})});
    });
  }

  void onViewWillAppear() {
    Future.delayed(Duration.zero, () {
      getEducationLists = getEducationList(context);
      getEducationLists!.whenComplete(() => {setState(() {})});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
        onFocusGained: onViewWillAppear,
        child: SafeArea(
            child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: commonAppbar("Education"),
          floatingActionButton: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddEducationPage(
                        dataMap: dataMap,
                      )));
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
            decoration: commonBoxDecoration(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  customHeightBox(80),
                  //Search education university
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
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
                                contentPadding:
                                    EdgeInsets.only(top: 14, left: 15),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFFDFB48C),
                                ),
                                hintText: "Email/ User Name",
                                hintStyle: TextStyle(color: Colors.white24)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //All Education history
                  FutureBuilder<Education>(
                      future: getEducationLists,
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: onlyCustomEdgetsset(
                                    top: 50, left: 20, right: 20),
                                child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: snapshot.data!.data!.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Container(
                                          margin: EdgeInsets.only(bottom: 10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: black,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            children: [
                                              commonAssetImage(
                                                  "assets/icons/scholar.png",
                                                  45,
                                                  45),
                                              customWidthBox(20),
                                              Column(
                                                crossAxisAlignment: cStart,
                                                children: [
                                                  customText(
                                                      snapshot
                                                          .data!
                                                          .data![index]
                                                          .institution
                                                          .toString(),
                                                      14,
                                                      white),
                                                  customHeightBox(5),
                                                  customText(
                                                      snapshot.data!
                                                          .data![index].degree
                                                          .toString(),
                                                      11,
                                                      white24),
                                                  customHeightBox(5),
                                                  customText(
                                                      convetYearFormat(snapshot
                                                              .data!
                                                              .data![index]
                                                              .from
                                                              .toString()) +
                                                          " - " +
                                                          convetYearFormat(
                                                              snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .to
                                                                  .toString()),
                                                      11,
                                                      white24),
                                                ],
                                              ),
                                              Spacer(),
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        showDeleteDialog(
                                                            snapshot
                                                                .data!
                                                                .data![index]
                                                                .sId
                                                                .toString());
                                                      });
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      decoration: BoxDecoration(
                                                          color: red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                                        "id": snapshot.data!
                                                            .data![index].sId
                                                            .toString(),
                                                        "school": snapshot
                                                            .data!
                                                            .data![index]
                                                            .institution,
                                                        "degree": snapshot
                                                            .data!
                                                            .data![index]
                                                            .degree,
                                                        "area": snapshot
                                                            .data!
                                                            .data![index]
                                                            .subject,
                                                        "description": snapshot
                                                            .data!
                                                            .data![index]
                                                            .description,
                                                        "fromText": snapshot
                                                            .data!
                                                            .data![index]
                                                            .from,
                                                        "toText": snapshot.data!
                                                            .data![index].to,
                                                        "fromTextStartDate":
                                                            convetDateFormat(
                                                                snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .from
                                                                    .toString()),
                                                        "toTextEndDate":
                                                            convetDateFormat(
                                                                snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .to
                                                                    .toString()),
                                                        "": "",
                                                      };

                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  AddEducationPage(
                                                                      dataMap:
                                                                          dataMap)));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3),
                                                      decoration: BoxDecoration(
                                                          gradient:
                                                              commonButtonLinearGridient,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
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
                                          ));
                                    }))
                            : Center(
                                child: customText(
                                    "Failed to load data!", 15, white),
                              );
                      })
                ],
              ),
            ),
          ),
        )));
  }

  //Show delete alert dialog box
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
                  customText("Delete Education History Item!", 15, white),
                  customDivider(10, white),
                  customHeightBox(5),
                  customText("Do you want to delete this education item?", 12,
                      white24),
                  customHeightBox(30),
                  Row(
                    mainAxisAlignment: mCenter,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            deleteEducationItem(context, itemId.toString());
                            Navigator.pop(context);
                            getEducationList(context);
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
