import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/CreateNewGroupScreen.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GroupsListScreen extends StatefulWidget {
  const GroupsListScreen({Key? key}) : super(key: key);

  @override
  State<GroupsListScreen> createState() => _GroupsListScreenState();
}

List<bool> isJoinedList1 = [false, false, false, false, false];
List<bool> isJoinedList2 = [true, true, true, true, true];

List<bool> selectedList = isJoinedList1;

class _GroupsListScreenState extends State<GroupsListScreen> {
  int clickPosition = 0;
  bool _showFab = true;
  LinearGradient selectedColor = commonButtonLinearGridient;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreateNewGroup()));
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
        body: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                customHeightBox(20),
                customText("Groups", 20, Colors.white),
                customHeightBox(30),
                custom(),
                customHeightBox(25),
                selectCategory(),
                customHeightBox(10),
                Container(
                  margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: black),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedList.length,
                      itemBuilder: ((context, index) {
                        return groupListItem(selectedList[index]);
                      })),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget groupListItem(bool isJoined) {
    return Container(
      margin: EdgeInsets.all(7),
      padding: EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Color(0xFF191831)),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("tom_cruise.jpeg"),
          ),
          customWidthBox(10),
          RichText(
            text: TextSpan(
              text: "Tom Cruise packs are available",
              style: TextStyle(color: white, fontSize: 13),
              children: <TextSpan>[
                TextSpan(
                    text: '\n4 Members', style: TextStyle(color: yellowColor)),
              ],
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            height: 30,
            decoration: BoxDecoration(
                gradient: commonButtonLinearGridient,
                borderRadius: BorderRadius.circular(30)),
            child: Center(
                child: Row(
              mainAxisAlignment: mBetween,
              children: [
                isJoined
                    ? Image.asset(
                        "assets/icons/check_right_icon.png",
                        height: 10,
                        width: 10,
                      )
                    : customWidthBox(1),
                customWidthBox(5),
                customText(isJoined ? "Joined" : "Join Group", 10, white),
              ],
            )),
          )
        ],
      ),
    );
  }

  Widget selectCategory() {
    return Container(
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
                    selectedList = isJoinedList1;
                    //setCustomListTile = Tile();
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      gradient: (clickPosition == 0) ? selectedColor : null,
                      border: (clickPosition == 0)
                          ? null
                          : Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 5, bottom: 5),
                    child: customText("Discover", 12, Colors.white),
                  ),
                ),
              ),
            ),
            Flexible(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _showFab = false;
                    //setCustomListTile = MyThreadTile();
                    clickPosition = 1;
                    selectedList = isJoinedList2;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      gradient: (clickPosition == 1) ? selectedColor : null,
                      border: (clickPosition == 1)
                          ? null
                          : Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: customText("Joined Group", 12, Colors.white),
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
                    //setCustomListTile = MyRepliesTile();
                    selectedList = isJoinedList2;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      gradient: (clickPosition == 2) ? selectedColor : null,
                      border: (clickPosition == 2)
                          ? null
                          : Border.all(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 5, bottom: 5),
                    child: customText("My Group", 12, Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Widget custom() {
    return Row(
      mainAxisAlignment: mCenter,
      children: [
        Flexible(
            flex: 5,
            child: Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(0, 2))
                  ]),
              child: TextField(
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Color(0xFFDFB48C),
                    ),
                    hintText: "Search",
                    contentPadding: const EdgeInsets.only(left: 15, top: 15),
                    hintStyle: const TextStyle(color: Colors.white24)),
              ),
            )),
        customWidthBox(20),
        Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                //openBottomSheet();
              },
              child: Image.asset(
                "assets/icons/fillter.png",
                height: 20,
                width: 20,
              ),
            )),
      ],
    );
  }
}
