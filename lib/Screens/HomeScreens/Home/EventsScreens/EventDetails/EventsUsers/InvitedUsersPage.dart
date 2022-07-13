import 'package:afro/Model/Events/EventDetails/InvitedUsers/InvitedUserModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class InvitedUsersPage extends StatefulWidget {
  String eventId = "";
  InvitedUsersPage({Key? key, required this.eventId}) : super(key: key);

  @override
  State<InvitedUsersPage> createState() => _InvitedUsersPageState();
}

Future<InvitedUserModel>? _getInvitesUsersList;

class _InvitedUsersPageState extends State<InvitedUsersPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getInvitesUsersList =
          getSentInvitesUsersList(context, widget.eventId.toString());
      setState(() {});
      _getInvitesUsersList!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<InvitedUserModel>(
        future: _getInvitesUsersList,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.data!.isNotEmpty
              ? Container(
                  height: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: black),
                  child: FutureBuilder<InvitedUserModel>(
                    future: _getInvitesUsersList,
                    builder: (context, snapshot) {
                      return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                          ? GridView.count(
                              scrollDirection: Axis.vertical,
                              padding: EdgeInsets.only(top: 20),
                              crossAxisCount: 3,
                              children: List.generate(
                                  snapshot.data!.data!.length, (index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OtherUserProfilePageScreen(
                                                  userID: snapshot
                                                      .data!
                                                      .data![index]
                                                      .receiver!
                                                      .sId
                                                      .toString(),
                                                  name: snapshot
                                                      .data!
                                                      .data![index]
                                                      .receiver!
                                                      .fullName
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Color(0xFF191831),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: customText(
                                                snapshot.data!.data![index]
                                                    .receiver!.fullName
                                                    .toString(),
                                                10,
                                                yellowColor),
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
                                                      snapshot
                                                          .data!
                                                          .data![index]
                                                          .receiver!
                                                          .profileImage
                                                          .toString(),
                                                  errorWidget:
                                                      (error, context, url) =>
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
                                            margin: EdgeInsets.only(
                                                right: 3, bottom: 3),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                gradient:
                                                    commonButtonLinearGridient),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }))
                          : Center(
                              child:
                                  customText("No users available!", 12, white));
                    },
                  ))
              : Center(
                  child: customText("No invites sent!", 12, white),
                );
        });
  }
}
