import 'package:afro/Model/Group/GroupDetails/GroupContacts/JoinedContacts/JoinedContactsModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
import 'package:afro/Util/Colors.dart';

import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Model/Group/GroupDetails/GroupContacts/RequestsContacts/RequestsContactsModel.dart';

class GroupDisscussionContactsPage extends StatefulWidget {
  String groupId = "";
  int privacy = 0;
  String userId = "";
  GroupDisscussionContactsPage(
      {Key? key,
      required this.groupId,
      required this.userId,
      required this.privacy})
      : super(key: key);

  @override
  State<GroupDisscussionContactsPage> createState() =>
      _GroupDisscussionContactsPageState();
}

var selectedPeopleListItem = 0;
String? loginUserID = "";
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
var loginUserData = UserDataConstants();

Future<JoinedContactsModel>? _getJoinedGroupscontacts;
Future<RequestsContactsModel>? _getRequestsGroupscontacts;

class _GroupDisscussionContactsPageState
    extends State<GroupDisscussionContactsPage> {
  @override
  void initState() {
    super.initState();
    getUserDetails();
    Future.delayed(Duration.zero, () {
      _getJoinedGroupscontacts =
          getJoinedGroupscontacts(context, widget.groupId);
      setState(() {});
      _getJoinedGroupscontacts!.whenComplete(() => () {});
    });
  }

  getUserDetails() async {
    SharedPreferences sharedData = await _prefs;
    loginUserID = sharedData.getString(loginUserData.id);
  }

  getRequestsContacts() {
    Future.delayed(Duration.zero, () {
      _getRequestsGroupscontacts =
          getRequestsGroupscontacts(context, widget.groupId);
      setState(() {});
      _getJoinedGroupscontacts!.whenComplete(() => () {});
    });
  }

  getJoinedContacts() {
    Future.delayed(Duration.zero, () {
      _getRequestsGroupscontacts =
          getRequestsGroupscontacts(context, widget.groupId);
      setState(() {});
      _getJoinedGroupscontacts!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: cStart,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedPeopleListItem = 0;
                    getJoinedContacts();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      gradient: selectedPeopleListItem == 0
                          ? commonButtonLinearGridient
                          : null,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: black),
                  child: Center(child: customText("Contacts", 13, white)),
                ),
              ),
              customWidthBox(10),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedPeopleListItem = 1;
                    getRequestsContacts();
                  });
                },
                child: Container(
                  child: widget.privacy == 2
                      ? loginUserID == widget.userId
                          ? Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  gradient: selectedPeopleListItem == 1
                                      ? commonButtonLinearGridient
                                      : null,
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  color: black),
                              child: Center(
                                  child: customText("Requests", 13, white)),
                            )
                          : null
                      : null,
                ),
              )
            ],
          ),
          selectedUsersListView(selectedPeopleListItem)
        ],
      ),
    );
  }

  selectedUsersListView(int itemID) {
    if (itemID == 0) {
      return joinedGroupMembers();
    } else if (itemID == 1) {
      return requestsGroupsMembers();
    }
  }

  //Set the layout of joined users list
  Widget joinedGroupMembers() {
    return Container(
      decoration: BoxDecoration(
          color: black,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
      child: FutureBuilder<JoinedContactsModel>(
        future: _getJoinedGroupscontacts,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.data!.isNotEmpty
              ? GridView.count(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  crossAxisCount: 3,
                  children: List.generate(snapshot.data!.data!.length, (index) {
                    var id = snapshot.data!.data![index].member!.sId.toString();
                    print("User Id :- $id");
                    print("Login id :- $loginUserID");
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OtherUserProfilePageScreen(
                                  userID: snapshot
                                      .data!.data![index].member!.sId
                                      .toString(),
                                  name: snapshot
                                      .data!.data![index].member!.fullName
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
                                            .data!.data![index].member!.fullName
                                            .toString(),
                                        10,
                                        yellowColor),
                                    customHeightBox(7),
                                    Container(
                                      child: loginUserID !=
                                              snapshot.data!.data![index]
                                                  .member!.sId
                                          ? InkWell(
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
                                                    snapshot
                                                                .data!
                                                                .data![index]
                                                                .member!
                                                                .isReqSent ==
                                                            1
                                                        ? "Cancel Friend"
                                                        : "Add Friend",
                                                    9,
                                                    white),
                                              ),
                                            )
                                          : null,
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
                                          snapshot.data!.data![index].member!
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
      ),
    );
  }

  // //Set the layout of request list
  // Widget requestsGroupMembers() {
  //   return Container(
  //     child: FutureBuilder<GoingInterstedUserModel>(
  //       future: _getUsers,
  //       builder: (context, snapshot) {
  //         return snapshot.hasData && snapshot.data!.data!.isNotEmpty
  //             ? GridView.count(
  //                 scrollDirection: Axis.vertical,
  //                 padding: EdgeInsets.only(top: 20),
  //                 crossAxisCount: 3,
  //                 children: List.generate(snapshot.data!.data!.length, (index) {
  //                   return InkWell(
  //                     onTap: () {
  //                       Navigator.of(context).push(MaterialPageRoute(
  //                           builder: (context) => OtherUserProfilePageScreen(
  //                                 userID: snapshot.data!.data![index].user!.sId
  //                                     .toString(),
  //                                 name: snapshot
  //                                     .data!.data![index].user!.fullName
  //                                     .toString(),
  //                               )));
  //                     },
  //                     child: Stack(
  //                       alignment: Alignment.topCenter,
  //                       children: [
  //                         Container(
  //                           margin: EdgeInsets.only(top: 20),
  //                           height: 100,
  //                           width: 100,
  //                           decoration: BoxDecoration(
  //                               color: gray1,
  //                               borderRadius: BorderRadius.circular(10)),
  //                           child: Container(
  //                             margin: EdgeInsets.all(10),
  //                             decoration: BoxDecoration(
  //                                 color: Color(0xFF191831),
  //                                 borderRadius: BorderRadius.circular(10)),
  //                             child: Container(
  //                               margin: EdgeInsets.only(top: 30),
  //                               child: Column(
  //                                 children: [
  //                                   customText(
  //                                       snapshot
  //                                           .data!.data![index].user!.fullName
  //                                           .toString(),
  //                                       10,
  //                                       yellowColor),
  //                                   customHeightBox(7),
  //                                   InkWell(
  //                                     onTap: () {},
  //                                     child: Container(
  //                                       padding: const EdgeInsets.only(
  //                                           top: 5,
  //                                           bottom: 5,
  //                                           left: 8,
  //                                           right: 8),
  //                                       decoration: BoxDecoration(
  //                                         borderRadius:
  //                                             BorderRadius.circular(20),
  //                                         gradient: commonButtonLinearGridient,
  //                                       ),
  //                                       child: customText(
  //                                           snapshot.data!.data![index].user!
  //                                                       .isReqSent ==
  //                                                   1
  //                                               ? "Cancel Friend"
  //                                               : "Add Friend",
  //                                           9,
  //                                           white),
  //                                     ),
  //                                   )
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                         Stack(
  //                           alignment: Alignment.bottomRight,
  //                           children: [
  //                             DottedBorder(
  //                               radius: Radius.circular(2),
  //                               padding: EdgeInsets.all(5),
  //                               borderType: BorderType.Circle,
  //                               color: Color(0xFF3E55AF),
  //                               child: Container(
  //                                 padding: EdgeInsets.all(1),
  //                                 child: CachedNetworkImage(
  //                                     imageUrl: IMAGE_URL +
  //                                         snapshot.data!.data![index].user!
  //                                             .profileImage
  //                                             .toString(),
  //                                     errorWidget: (error, context, url) =>
  //                                         Icon(Icons.person),
  //                                     placeholder: (context, url) =>
  //                                         Icon(Icons.person),
  //                                     imageBuilder: (context, url) {
  //                                       return CircleAvatar(
  //                                         backgroundImage: url,
  //                                       );
  //                                     }),
  //                               ),
  //                             ),
  //                             Container(
  //                               height: 9,
  //                               width: 9,
  //                               margin: EdgeInsets.only(right: 3, bottom: 3),
  //                               decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(10),
  //                                   gradient: commonButtonLinearGridient),
  //                             )
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                   );
  //                 }))
  //             : Center(child: customText("No users available!", 12, white));
  //       },
  //     ),
  //   );
  // }
  Widget requestsGroupsMembers() {
    return Container(
      decoration: BoxDecoration(
          color: black,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          )),
      child: FutureBuilder<RequestsContactsModel>(
        future: _getRequestsGroupscontacts,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.data!.isNotEmpty
              ? GridView.count(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(top: 20, bottom: 20),
                  crossAxisCount: 3,
                  children: List.generate(snapshot.data!.data!.length, (index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => OtherUserProfilePageScreen(
                                  userID: snapshot.data!.data![index].user!.sId
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
                                margin: EdgeInsets.only(top: 25),
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
                                            top: 2,
                                            bottom: 2,
                                            left: 8,
                                            right: 8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: commonButtonLinearGridient,
                                        ),
                                        child: customText("Accept ", 9, white),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            top: 2,
                                            bottom: 2,
                                            left: 8,
                                            right: 8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: commonButtonLinearGridient,
                                        ),
                                        child: customText("Cancel", 9, white),
                                      ),
                                    ),
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
                            ],
                          ),
                        ],
                      ),
                    );
                  }))
              : Center(child: customText("No users available!", 12, white));
        },
      ),
    );
  }
}
