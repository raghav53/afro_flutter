import 'package:afro/Screens/HomeScreens/Home/Groups/GroupsScreen/DiscoverGroupScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupsScreen/JoinedGroupsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupsScreen/MyGroupsScreen.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/CreateNewGroupScreen.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/material.dart';

class GroupsAllListScreen extends StatefulWidget {
  const GroupsAllListScreen({Key? key}) : super(key: key);

  @override
  State<GroupsAllListScreen> createState() => _GroupsAllListScreenState();
}

class _GroupsAllListScreenState extends State<GroupsAllListScreen> {
  int clickPosition = 0;
  bool _showFab = true;
  LinearGradient selectedColor = commonButtonLinearGridient;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: onlyTitleCommonAppbar("Groups"),
        extendBodyBehindAppBar: true,
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
                gradient: commonButtonLinearGridient),
            child: Icon(
              Icons.add,
              color: white,
            ),
          ),
        ),
        body: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(children: [
              customHeightBox(80),
              custom(),
              customHeightBox(25),
              selectCategory(),
              customHeightBox(10),
              setFillterLayout(clickPosition)
            ]),
          ),
        ),
      ),
    );
  }

  Widget selectCategory() {
    return Container(
        height: 50,
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

                    clickPosition = 1;
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

  //Search bar
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

  //set the custom fillter view
  setFillterLayout(int postion) {
    if (postion == 0) {
      return DiscoverGroupsScreen();
    } else if (postion == 1) {
      return JoinedGroupsScreen();
    } else if (postion == 2) {
      return MyGroupsScreen();
    }
  }
}
