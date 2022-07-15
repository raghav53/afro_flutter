import 'package:afro/Screens/HomeScreens/Home/Forums/ForumsAllScreens/AllTheradsScreenPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/ForumsAllScreens/MyRepliesPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/ForumsAllScreens/MyThreadsPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/ForumsNewThread.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForumsScreenPage extends StatefulWidget {
  _ForumsPage createState() => _ForumsPage();
}

TextEditingController _search = TextEditingController();

class _ForumsPage extends State<ForumsScreenPage> {
  bool _showFab = true;
  int clickPosition = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: onlyTitleCommonAppbar("Forums"),
      floatingActionButton: AnimatedSlide(
        duration: Duration(seconds: 1),
        offset: _showFab ? Offset.zero : Offset(0, 2),
        child: AnimatedOpacity(
          duration: Duration(seconds: 1),
          opacity: _showFab ? 1 : 0,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ForumsNewThreadPage()));
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: commonButtonLinearGridient),
              child: Icon(
                Icons.add,
                color: white,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: cStart,
            children: [
              Container(
                padding: EdgeInsets.only(top: 80, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: cStart,
                  children: [
                    customText("Forums", 20, Colors.white),
                    customHeightBox(5),
                    customText(
                        "The great place to discuss topics with other users",
                        15,
                        Colors.white),
                  ],
                ),
              ),
              customHeightBox(15),
              customDivider(6, Color(0x3dFFFFFF)),
              customHeightBox(10),
              // Search bar and fillter button
              Row(
                crossAxisAlignment: cCenter,
                mainAxisAlignment: mCenter,
                children: [
                  Flexible(
                      flex: 6,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black, offset: Offset(0, 2))
                            ]),
                        child: TextField(
                          controller: _search,
                          keyboardType: TextInputType.text,
                          style: TextStyle(fontSize: 14, color: white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: yellowColor,
                              ),
                              hintText: "Search",
                              contentPadding:
                                  const EdgeInsets.only(left: 15, top: 15),
                              hintStyle: TextStyle(color: white24)),
                        ),
                      )),
                  customWidthBox(20),
                  Flexible(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          Fluttertoast.showToast(
                              msg: "Hello World",
                              toastLength: Toast.LENGTH_SHORT);
                        },
                        child: Image.asset(
                          "assets/icons/fillter.png",
                          height: 20,
                          width: 20,
                        ),
                      )),
                ],
              ),
              customHeightBox(20),
              Container(
                  height: 50,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    mainAxisAlignment: mEvenly,
                    crossAxisAlignment: cStart,
                    children: [
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _showFab = false;
                              clickPosition = 0;
                            });
                          },
                          child: Container(
                            width: 110,
                            padding: EdgeInsets.only(top: 4, bottom: 4),
                            decoration: BoxDecoration(
                                gradient: (clickPosition == 0)
                                    ? commonButtonLinearGridient
                                    : null,
                                border: (clickPosition == 0)
                                    ? null
                                    : Border.all(color: Colors.white, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: mCenter,
                              children: [
                                Image.asset(
                                  "assets/icons/all_thread_icn.png",
                                  color: white,
                                  height: 15,
                                  width: 15,
                                ),
                                customWidthBox(5),
                                customText("All Thread", 12, Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _showFab = false;

                              clickPosition = 1;
                            });
                          },
                          child: Container(
                            width: 110,
                            padding: EdgeInsets.only(top: 4, bottom: 4),
                            decoration: BoxDecoration(
                                gradient: (clickPosition == 1)
                                    ? commonButtonLinearGridient
                                    : null,
                                border: (clickPosition == 1)
                                    ? null
                                    : Border.all(color: Colors.white, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: mCenter,
                              children: [
                                Image.asset(
                                  "assets/icons/my_threads.png",
                                  color: white,
                                  height: 15,
                                  width: 15,
                                ),
                                customText("My Threads", 12, Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _showFab = true;
                              clickPosition = 2;
                            });
                          },
                          child: Container(
                            width: 110,
                            padding: EdgeInsets.only(top: 4, bottom: 4),
                            decoration: BoxDecoration(
                                gradient: (clickPosition == 2)
                                    ? commonButtonLinearGridient
                                    : null,
                                border: (clickPosition == 2)
                                    ? null
                                    : Border.all(color: Colors.white, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Row(
                              mainAxisAlignment: mCenter,
                              children: [
                                Image.asset(
                                  "assets/icons/my_reply_icon.png",
                                  color: white,
                                  height: 15,
                                  width: 15,
                                ),
                                customWidthBox(5),
                                customText("My Replies", 12, Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),

              Container(height: 500, child: selectedViewFillter(clickPosition))
            ],
          ),
        ),
      ),
    ));
  }

  selectedViewFillter(int index) {
    if (index == 0) {
      return AllThreadsPageScreen();
    } else if (index == 1) {
      return MyThreadsPage();
    } else if (index == 2) {
      return MyRepliesPage();
    }
  }
}
