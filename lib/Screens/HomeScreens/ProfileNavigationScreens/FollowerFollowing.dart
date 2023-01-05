import 'package:afro/Model/MyProfile/FollowingModel.dart';
import 'package:afro/Screens/HomeScreens/Home/MyProfile.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/Tabs/FollowingTab.dart';
import 'package:afro/Screens/Tabs/FollowerTab.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowerFollowingPage extends StatefulWidget {
  final int selectedIndex;
  const FollowerFollowingPage({Key? key,  this.selectedIndex=0,}) : super(key: key);
  @override
  _FollowerFollowing createState() => _FollowerFollowing();
}

Future<SharedPreferences> _pref = SharedPreferences.getInstance();
UserDataConstants _userDataConstants = UserDataConstants();

class _FollowerFollowing extends State<FollowerFollowingPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    //Set up the tab controller
    tabController = TabController(initialIndex: widget.selectedIndex,length: 2, vsync: this);

    //Get the user information
    getUserInfo();
  }

  getUserInfo() async {
    SharedPreferences userData = await _pref;
    fullName = userData.getString(_userDataConstants.fullName).toString();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: commonAppbar(fullName.toString()),
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 70),
          decoration: commonBoxDecoration(),
          height: phoneHeight(context),
          width: phoneWidth(context),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(top: 3,bottom: 3),
                margin: const EdgeInsets.only(left: 25, right: 25),
                width: phoneWidth(context),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFF707070),
                      width: 2.0,
                    ),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(45)),
                child: Column(
                  children: [
                    TabBar(
                      unselectedLabelColor: Colors.white,
                      labelColor: Colors.black,
                      indicatorWeight: 2,
                      indicator: BoxDecoration(
                        gradient: commonButtonLinearGridient,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(45),
                      ),
                      controller: tabController,

                      tabs: const [
                        Tab(
                          height: 30,
                          text: 'Following',
                        ),
                        Tab(
                          height: 30,
                          text: 'Followers',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              customWidthBox(20),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: const [
                    FollowingTab(),
                    FollowerTab(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
