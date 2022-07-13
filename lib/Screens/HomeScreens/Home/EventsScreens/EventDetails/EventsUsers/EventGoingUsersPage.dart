import 'package:afro/Model/Events/InterestedGoing/InterstedGoingModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventGoingUsersPage extends StatefulWidget {
  String eventId = "";
  EventGoingUsersPage({Key? key, required this.eventId}) : super(key: key);
  @override
  State<EventGoingUsersPage> createState() => _EventGoingUsersPageState();
}

Future<GoingInterstedUserModel>? _getUsers;

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
var userData = UserDataConstants();

class _EventGoingUsersPageState extends State<EventGoingUsersPage> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      _getUsers = getGoingEventUsers("0", context, widget.eventId.toString());

      setState(() {});
      _getUsers!.whenComplete(() => () {});
    });
  }

  refreshData(String type) {
    Future.delayed(Duration.zero, () {
      _getUsers = getGoingEventUsers(type, context, widget.eventId.toString());
      setState(() {});
      _getUsers!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 300,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: black),
        child: FutureBuilder<GoingInterstedUserModel>(
          future: _getUsers,
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? GridView.count(
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.only(top: 20),
                    crossAxisCount: 3,
                    children:
                        List.generate(snapshot.data!.data!.length, (index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => OtherUserProfilePageScreen(
                                    userID: snapshot
                                        .data!.data![index].user!.sId
                                        .toString(),
                                    name: snapshot
                                        .data!.data![index].user!.fullName
                                        .toString(),
                                  )));
                        },
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: gray1,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Color(0xFF191831),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  margin: EdgeInsets.only(top: 30),
                                  child: Column(
                                    children: [
                                      customText(
                                          snapshot
                                              .data!.data![index].user!.fullName
                                              .toString(),
                                          10,
                                          yellowColor),
                                      customHeightBox(7),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 5,
                                              bottom: 5,
                                              left: 8,
                                              right: 8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            gradient:
                                                commonButtonLinearGridient,
                                          ),
                                          child: customText(
                                              snapshot.data!.data![index].user!
                                                          .isReqSent ==
                                                      1
                                                  ? "Cancel Friend"
                                                  : "Add Friend",
                                              9,
                                              white),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                DottedBorder(
                                  radius: Radius.circular(2),
                                  padding: EdgeInsets.all(5),
                                  borderType: BorderType.Circle,
                                  color: Color(0xFF3E55AF),
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    child: CachedNetworkImage(
                                        imageUrl: IMAGE_URL +
                                            snapshot.data!.data![index].user!
                                                .profileImage
                                                .toString(),
                                        errorWidget: (error, context, url) =>
                                            Icon(Icons.person),
                                        placeholder: (context, url) =>
                                            Icon(Icons.person),
                                        imageBuilder: (context, url) {
                                          return CircleAvatar(
                                            backgroundImage: url,
                                          );
                                        }),
                                  ),
                                ),
                                Container(
                                  height: 9,
                                  width: 9,
                                  margin: EdgeInsets.only(right: 3, bottom: 3),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: commonButtonLinearGridient),
                                )
                              ],
                            ),
                          ],
                        ),
                      );
                    }))
                : Center(child: customText("No users available!", 12, white));
          },
        ));
  }
}
