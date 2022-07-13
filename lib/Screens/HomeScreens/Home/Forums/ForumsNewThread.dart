import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ForumsNewThreadPage extends StatefulWidget {
  @override
  _ForumsNewThreadPage createState() => _ForumsNewThreadPage();
}

class _ForumsNewThreadPage extends State<ForumsNewThreadPage> {
  String? visible;
  String? selectedItem = "Item 1";
  int _groupValue = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: mStart,
              crossAxisAlignment: cStart,
              children: [
                customHeadingPart("Create New Thread"),
                customDivider(10, Colors.white),
                customHeightBox(30),
                Container(
                  margin: EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    mainAxisAlignment: mStart,
                    crossAxisAlignment: cStart,
                    children: [
                      customText("SELECT CATEGORY", 14, Colors.white),
                      customHeightBox(10),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black),
                        child: Row(
                          children: [
                            customWidthBox(10),
                            customText("Select Category", 14, Colors.white),
                            Spacer(),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
                      customHeightBox(20),
                      customText("TITLE", 14, Colors.white),
                      customHeightBox(10),
                      forumsEditext("Title"),
                      customHeightBox(20),
                      customText("LINK", 14, Colors.white),
                      customHeightBox(10),
                      forumsEditext("Link"),
                      customHeightBox(20),
                      customText("Visible to:", 14, Colors.white),
                      customWidthBox(10),
                      customRadiosButton(),
                      customHeightBox(20),
                      customText("Content", 14, Colors.white),
                      customHeightBox(10),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black),
                        height: 200,
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            crossAxisAlignment: cEnd,
                            mainAxisAlignment: mEnd,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.video_call,
                                    color: Colors.white,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.photo,
                                    color: Colors.white,
                                  ))
                            ],
                          ),
                        ),
                      ),
                      customHeightBox(50),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          margin: const EdgeInsets.only(left: 80, right: 80),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          decoration: fixedButtonDesign(),
                          child: Row(
                            mainAxisAlignment: mCenter,
                            children: [customText("SAVE", 17, Colors.white)],
                          ),
                        ),
                      ),
                      customHeightBox(50)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customRadiosButton() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Radio(value: 1, groupValue: 'null', onChanged: (index) {}),
                Expanded(
                  child: customText("Global", 14, Colors.white),
                )
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Radio(value: 1, groupValue: 'null', onChanged: (index) {}),
                Expanded(child: customText("Select Country", 14, Colors.white))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget forumsEditext(String title) {
  return Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(0, 2))
        ]),
    child: TextFormField(
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: title,
          contentPadding: const EdgeInsets.only(left: 15),
          hintStyle: const TextStyle(color: Colors.white24)),
    ),
  );
}
