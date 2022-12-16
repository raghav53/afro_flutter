import 'package:afro/Screens/SignUpProcess/SelectInterest.dart';
import 'package:afro/Screens/UseableWidetcode.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buttonBackground(String title) {
  return Ink(
    decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff7822A0), Color(0xff3E55AF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30.0)),
    child: Container(
      constraints: BoxConstraints(maxWidth: 200.0, minHeight: 40.0),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 10,
          ),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
    ),
  );
}

Widget customWidthBox(double width) {
  return SizedBox(
    width: width,
  );
}

Widget customHeightBox(double height) {
  return SizedBox(
    height: height,
  );
}

Widget customText(String text, double size, Color color, {String bold = ""}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: size,
        color: color,
        fontStyle: FontStyle.normal,fontFamily: "Poppins",
        fontWeight: bold == "yes" ? FontWeight.bold : null),
  );
}

Decoration fixedButtonDesign() {
  return const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      gradient: LinearGradient(
        colors: [Color(0xff7822A0), Color(0xff3E55AF)],
      ));
}

Widget customDivider(double height, Color color) {
  return Divider(
    height: height,
    color: color,
  );
}

Widget customHeadingPart(String title) {
  return Row(
    children: [
      Expanded(
        child: BackButton(
          color: Colors.white,
        ),
      ),
      Spacer(),
      Center(
        child: Container(
          alignment: Alignment.center,
          child: customText(title, 18.0, Colors.white),
        ),
      ),
      const Spacer(flex: 2)
    ],
  );
}

BoxDecoration commonBoxDecoration() {
  return const BoxDecoration(
      image: DecorationImage(
          image: AssetImage("background.png"), fit: BoxFit.cover));
}

LinearGradient commonButtonLinearGridient =
    const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xff7822A0), Color(0xff3958B0)]);

var category = [
  "Health and Wellness",
  "Tourism/Travel",
  "Music/Entertainments",
  "Festival",
  "Sports",
  "Arts",
  "Conferences",
  "Vip Events",
  'Job fairs/Recruiting events',
  "Team Building",
  "Seminar/Talk",
  "TradeShows",
  "Netwroking event",
  "Gala/Ceremonies",
  "Course , Training , Workship",
  "Club or Social Gathering",
  "Literature / Book club",
  "Camp/Trip/Retreat",
  "Diaspora events",
  "History"
];

// Widget customButton(BuildContext context) {
//   return TextButton(
//       onPressed: () {
//         Navigator.of(context)
//             .push(MaterialPageRoute(builder: (context) => SelectIntrest()));
//       },
//       child: Text("Forword"));
// }

AppBar commonAppbar(String title) {
  return AppBar(
    leading: const BackButton(),
    centerTitle: true,
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    title: customText(title, 20, Colors.white),
  );
}

AppBar onlyTitleCommonAppbar(String title) {
  return AppBar(
    automaticallyImplyLeading: false,
    centerTitle: true,
    elevation: 0.0,
    backgroundColor: Colors.transparent,
    title: customText(title, 20, Colors.white),
  );
}

double phoneHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double phoneWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

Widget dottedDivider() {
  return DottedBorder(
    padding: EdgeInsets.zero,
    color: white,
    strokeWidth: 1,
    child: Container(),
  );
}

Widget commonAssetImage(String path, double height, double width) {
  return Image(
    image: AssetImage(path),
    height: height,
    width: width,
  );
}

EdgeInsets onlyCustomEdgetsset(
    {double top = 0, double bottom = 0, double left = 0, double right = 0}) {
  return EdgeInsets.only(top: top, right: right, left: left, bottom: bottom);
}

Future<String>? openCommonBottomSheet(BuildContext context) async {
  String timeStamp = "";
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
                          state(() {
                            String formattedDate =
                                DateFormat('dd-MM-yyyy').format(newDateTime);
                            timeStamp = formattedDate;
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
  return timeStamp;
}

void showInSnackBar(String value, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        value,
        style: const TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 3000),
    ),
  );
}
