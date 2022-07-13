import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/ForumsNewThread.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/AddVisitLocationPage.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForumsScreenPage extends StatefulWidget {
  _ForumsPage createState() => _ForumsPage();
}

class _ForumsPage extends State<ForumsScreenPage> {
  bool _showFab = true;
  LinearGradient selectedColor = LinearGradient(
    colors: [Color(0xff7822A0), Color(0xff3E55AF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  Widget setCustomListTile = Tile();
  int clickPosition = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: commonAppbar("Forums"),
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
              // Fluttertoast.showToast(msg: "Hello", toastLength: Toast.LENGTH_SHORT);
            },
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                      colors: [Color(0xff7822A0), Color(0xff3E55AF)])),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: cStart,
            children: [
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 80),
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
              customDivider(5, Color(0x3dFFFFFF)),
              customHeightBox(10),
              Row(
                mainAxisAlignment: mCenter,
                children: [
                  Flexible(
                      flex: 4,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black, offset: Offset(0, 2))
                            ]),
                        child: TextField(
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Color(0xFFDFB48C),
                              ),
                              hintText: "Search for members",
                              contentPadding:
                                  const EdgeInsets.only(left: 15, top: 15),
                              hintStyle:
                                  const TextStyle(color: Colors.white24)),
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
                              setCustomListTile = Tile();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                gradient:
                                    (clickPosition == 0) ? selectedColor : null,
                                border: (clickPosition == 0)
                                    ? null
                                    : Border.all(color: Colors.white, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 5, bottom: 5),
                              child: customText("Home", 12, Colors.white),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _showFab = false;
                              setCustomListTile = MyThreadTile();
                              clickPosition = 1;
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                gradient:
                                    (clickPosition == 1) ? selectedColor : null,
                                border: (clickPosition == 1)
                                    ? null
                                    : Border.all(color: Colors.white, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: customText("My Threads", 12, Colors.white),
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
                              setCustomListTile = MyRepliesTile();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                                gradient:
                                    (clickPosition == 2) ? selectedColor : null,
                                border: (clickPosition == 2)
                                    ? null
                                    : Border.all(color: Colors.white, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 5, bottom: 5),
                              child: customText("My Replies", 12, Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  children: [
                    customText("Sngine News", 15, Color(0xFFDFB48C)),
                    Spacer(),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFFDFB48C),
                    )
                  ],
                ),
              ),
              customHeightBox(15),
              Container(
                height: 500,
                child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return setCustomListTile;
                    }),
              )
            ],
          ),
        ),
      ),
    ));
  }
}

class Tile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Color(0XFF121220)),
        margin: EdgeInsets.only(left: 30, right: 30, top: 10),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: mStart,
            crossAxisAlignment: cStart,
            children: [
              Column(
                crossAxisAlignment: cStart,
                mainAxisAlignment: mStart,
                children: [
                  customText("Best Quality Cheap Assignment Help in USA", 11,
                      Color(0xFFDFB48C)),
                  customHeightBox(2),
                  Row(
                    children: [
                      customText("By: ", 10, Colors.white),
                      customText("Alexander Narnes  ", 10, Color(0xFFDFB48C)),
                      customText("2 months ago", 10, Colors.white)
                    ],
                  ),
                  customHeightBox(2),
                  Row(
                    children: [
                      customText("Last Post : ", 10, Colors.white),
                      customText("4 hours ago", 10, Color(0xFFDFB48C)),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  customText("Replies/Views", 11, Color(0x3dFFFFFF)),
                  customHeightBox(5),
                  customText("3/5", 15, Color(0xFFDFB48C))
                ],
              )
            ],
          ),
        ));
  }
}

class MyThreadTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Color(0XFF121220)),
      margin: EdgeInsets.only(left: 30, right: 30, top: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: cStart,
          mainAxisAlignment: mStart,
          children: [
            customText("Best Quality Cheap Assignment Help in USA", 11,
                Color(0xFFDFB48C)),
            customHeightBox(2),
            Row(
              children: [
                customText("By: ", 10, Colors.white),
                customText("Alexander Narnes  ", 10, Color(0xFFDFB48C)),
                customText("19 minutes ago", 10, Colors.white)
              ],
            ),
            customHeightBox(2),
            customText(
                "Laram Lorem lpsum is simply dummy text of the printing and\ntypesetting industry.",
                11,
                Color(0x3dFFFFFF)),
            customHeightBox(3),
            Container(
              child: Row(
                children: [
                  customText("Last Post : ", 10, Color(0x3dFFFFFF)),
                  customText("27 hours ago", 10, Color(0xFFDFB48C))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyRepliesTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Color(0XFF121220)),
        margin: EdgeInsets.only(left: 30, right: 30, top: 10),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: cCenter,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage("tom_cruise.jpeg"),
              ),
              customWidthBox(10),
              customHeightBox(10),
              Column(
                crossAxisAlignment: cStart,
                children: [
                  customText(
                      "Loram Loren lpsum is simply dummy test of the printing\nand typesetting industry",
                      11,
                      Colors.white),
                  customHeightBox(5),
                  customText("24 hours ago", 10, Color(0x3dFFFFFF))
                ],
              )
            ],
          ),
        ));
  }
}
