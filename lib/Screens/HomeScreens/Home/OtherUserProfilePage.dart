import 'dart:convert';

import 'package:afro/Model/UserProfile.dart' as Experiences;
import 'package:afro/Model/UserProfile.dart' as Educations;
import 'package:afro/Model/UserProfileModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Messages/UserMessageScreen.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class OtherUserProfilePageScreen extends StatefulWidget {
  String? userID = "", name = "", loginUserId = "";

  OtherUserProfilePageScreen(
      {Key? key, this.name, this.userID, this.loginUserId})
      : super(key: key);
  @override
  State<OtherUserProfilePageScreen> createState() =>
      _OtherUserProfilePageScreenState();
}

Future<UserProfile>? _getUserProfileData;
UserProfile? _profile;
Future<SharedPreferences> _pref = SharedPreferences.getInstance();
UserDataConstants _userDataConstants = UserDataConstants();

class _OtherUserProfilePageScreenState extends State<OtherUserProfilePageScreen>
    with WidgetsBindingObserver {
  List<String> languages = ["English", "Hindi", "Spanish", "French"];
  List<String> events = ["Crew Event", "Crew Event"];
  List<String> interests = [
    "Health ans Wellness",
    "Festival",
    "Arts",
    "VIP events",
    "Sports",
    "Music",
    "Travelling"
  ];

  //Get the user data from api in initState
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getUserProfileData =
          getOtherUserProfileinfo(context, widget.userID.toString());
      setState(() {});

      _getUserProfileData!.whenComplete(() => () {
            setState(() {});
          });
      print("User Profile Api");
    });
  }

  //Update the userData
  updateUserDataInformation() {
    Future.delayed(Duration.zero, () {
      _getUserProfileData =
          getOtherUserProfileinfo(context, widget.userID.toString());
      setState(() {});

      _getUserProfileData!.whenComplete(() => () {
            setState(() {});
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          appBar: commonAppbar(widget.name.toString()),
          body: Container(
              padding: const EdgeInsets.only(
                  top: 70, left: 20, right: 20, bottom: 10),
              height: phoneHeight(context),
              width: phoneWidth(context),
              decoration: commonBoxDecoration(),
              //Set the data of user profile
              child: FutureBuilder<UserProfile>(
                future: _getUserProfileData,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: cStart,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: gray1,
                                    borderRadius: BorderRadius.circular(10)),
                                child:
                                 Row(
                                  crossAxisAlignment: cStart,
                                  children: [
                                    //Profile Image
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1, color: yellowColor),
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: CachedNetworkImage(
                                            imageUrl: IMAGE_URL +
                                                snapshot
                                                    .data!.data!.profileImage
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
                                    customWidthBox(7),
                                    //Basic Info,
                                    Column(
                                      crossAxisAlignment: cStart,
                                      children: [
                                        customText(
                                            widget.name.toString(), 15, white),
                                        customHeightBox(2),
                                        customText(
                                            "Newcorner Buddy", 11, white),
                                        customHeightBox(2),
                                        customText("Member since April 2022",
                                            11, white),
                                        customHeightBox(13),
                                        customText('Bio', 15, white),
                                        customHeightBox(3),
                                        Container(
                                          width: phoneWidth(context) / 1.5,
                                          child: Text(
                                            snapshot.data!.data!.bio.toString(),
                                            style: TextStyle(
                                                fontSize: 11, color: white),
                                          ),
                                        ),
                                        customHeightBox(15),
                                        customHeightBox(15),
                                        //Following , Follower , Friends/Contacts
                                        Row(
                                          children: [
                                            InkWell(
                                              child: customText(
                                                  "Following: " +
                                                      snapshot.data!.data!
                                                          .totalFollowings
                                                          .toString(),
                                                  12,
                                                  white),
                                            ),
                                            customWidthBox(30),
                                            InkWell(
                                              child: customText(
                                                  "Follower: " +
                                                      snapshot.data!.data!
                                                          .totalFollowers
                                                          .toString(),
                                                  12,
                                                  white),
                                            ),
                                            customWidthBox(30),
                                            InkWell(
                                              child: customText(
                                                  "Contacts: " +
                                                      snapshot.data!.data!
                                                          .totalFirends
                                                          .toString(),
                                                  12,
                                                  white),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              //Message , Follow ,  Add button
                              customHeightBox(10),
                              Container(
                                child: widget.loginUserId ==
                                        snapshot.data!.data!.id
                                    ? null
                                    : Row(
                                        mainAxisAlignment: mCenter,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            UserMessagePage(
                                                              name: snapshot
                                                                  .data!
                                                                  .data!
                                                                  .fullName
                                                                  .toString(),
                                                              userID: snapshot
                                                                  .data!
                                                                  .data!
                                                                  .sId,
                                                            )));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(5),
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 1,
                                                        color: circleColor),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Image.asset(
                                                  "assets/icons/message.png",
                                                  color: circleColor,
                                                  height: 10,
                                                  width: 10,
                                                ),
                                              )),
                                          customWidthBox(15),
                                          InkWell(
                                            onTap: () {
                                              if (snapshot.data!.data!
                                                      .isFollowing ==
                                                  1) {
                                                showFollowUnFollowUser(
                                                    widget.userID.toString(),
                                                    "0");
                                              } else {
                                                unfollow(
                                                    widget.userID.toString(),
                                                    "1");
                                              }
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                  gradient:
                                                      commonButtonLinearGridient,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Center(
                                                child: snapshot.data!.data!
                                                            .isFollowing ==
                                                        1
                                                    ? customText(
                                                        "Following", 12, white)
                                                    : customText(
                                                        "Follow", 12, white),
                                              ),
                                            ),
                                          ),
                                          customWidthBox(15),
                                          InkWell(
                                              onTap: () {
                                                int? recRequest = snapshot
                                                    .data!.data!.isReqReceived;
                                                int? sentRequest = snapshot
                                                    .data!.data!.isReqSent;
                                                int? isFriend = snapshot
                                                    .data!.data!.isFriend;
                                                if (recRequest == 1) {
                                                  showlogoutdialog(
                                                      context,
                                                      recRequest!,
                                                      snapshot.data!.data!.sId!
                                                          .toString());
                                                } else if (recRequest != 1) {
                                                  if (sentRequest == 0) {
                                                    sendAndCancelFriendRequest(
                                                        0,
                                                        snapshot
                                                            .data!.data!.sId!
                                                            .toString());
                                                  } else {
                                                    sendAndCancelFriendRequest(
                                                        1,
                                                        snapshot
                                                            .data!.data!.sId!
                                                            .toString());
                                                  }
                                                }
                                              },
                                              child: (snapshot.data!.data!
                                                              .isReqReceived ==
                                                          1 ||
                                                      snapshot.data!.data!
                                                              .isReqSent ==
                                                          1)
                                                  ? Image.asset(
                                                      "assets/icons/delete_friend.png",
                                                      height: 20,
                                                      width: 20,
                                                    )
                                                  : snapshot.data!.data!
                                                              .isFriend ==
                                                          1
                                                      ? Image.asset(
                                                          "assets/icons/friends.png",
                                                          height: 20,
                                                          width: 20,
                                                        )
                                                      : Image.asset(
                                                          "assets/icons/add_user.png",
                                                          height: 20,
                                                          width: 20,
                                                        ))
                                        ],
                                      ),
                              ),
                              customHeightBox(35),
                              //Languages
                              customText("Languages", 15, yellowColor),
                              customHeightBox(10),
                              Container(
                                height: 25,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: languages.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20),
                                        margin:
                                            const EdgeInsets.only(right: 10),
                                        height: 30,
                                        decoration: BoxDecoration(
                                            gradient:
                                                commonButtonLinearGridient,
                                            borderRadius:
                                                BorderRadius.circular(30)),
                                        child: Center(
                                          child: customText(
                                              languages[index], 12, white),
                                        ),
                                      );
                                    }),
                              ),

                              customHeightBox(25),
                              //Interests(done)
                              customText("Interests", 15, yellowColor),
                              customHeightBox(10),
                              Container(
                                child: snapshot
                                        .data!.data!.interests!.isNotEmpty
                                    ? Container(
                                        height: 25,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: snapshot
                                                .data!.data!.interests!.length,
                                            itemBuilder: (context, index1) {
                                              String? interestName = snapshot
                                                  .data!
                                                  .data!
                                                  .interests![index1]
                                                  .interest!
                                                  .title
                                                  .toString();
                                              return Container(
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 20),
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    gradient:
                                                        commonButtonLinearGridient,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Center(
                                                  child: customText(
                                                      interestName, 12, white),
                                                ),
                                              );
                                            }),
                                      )
                                    : null,
                              ),

                              //Work Experience(done)
                              customHeightBox(20),
                              customText("Employment", 15, yellowColor),
                              customHeightBox(10),
                              Container(
                                child:
                                    snapshot.data!.data!.experiences!.isNotEmpty
                                        ? ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: snapshot.data!.data!
                                                .experiences!.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, exIndex) {
                                              return historyItemView(snapshot
                                                  .data!
                                                  .data!
                                                  .experiences![exIndex]);
                                            })
                                        : null,
                              ),

                              //Education history(done)
                              customHeightBox(20),
                              customText("Education History", 15, yellowColor),
                              customHeightBox(10),

                              Container(
                                child:
                                    snapshot.data!.data!.educations!.isNotEmpty
                                        ? ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: snapshot
                                                .data!.data!.educations!.length,
                                            shrinkWrap: true,
                                            itemBuilder: (context, edIndex) {
                                              return eHistoryItemView(snapshot
                                                  .data!
                                                  .data!
                                                  .educations![edIndex]);
                                            })
                                        : null,
                              ),

                              customHeightBox(20),
                              customText("Member of", 15, yellowColor),
                              customHeightBox(10),
                              Container(
                                height: 20,
                                child: Center(
                                  child: customText(
                                      "Haven't created or joined any group",
                                      12,
                                      white),
                                ),
                              ),
                              customHeightBox(20),

                              //Events
                              customText("Events", 15, yellowColor),
                              customHeightBox(10),
                              Container(
                                  height: 25,
                                  child: snapshot.data!.data!.events!.isNotEmpty
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: snapshot
                                              .data!.data!.events!.length,
                                          itemBuilder: (context, eventsIndex) {
                                            return eventItemWidget(snapshot
                                                .data!
                                                .data!
                                                .events![eventsIndex]);
                                          })
                                      : null),
                              customHeightBox(30),
                              customText(
                                  "International Experience", 15, yellowColor),
                              customHeightBox(15),
                              Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: customText("Place lived in", 12, white),
                              ),
                              customHeightBox(25),
                              Center(
                                child: Container(
                                  width: 200,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: gray1),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          "assets/language/spain.png",
                                          height: 20,
                                          width: 20,
                                        ),
                                        customWidthBox(10),
                                        customText("Spain", 15, white)
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      : Center(
                          child: customText("No data available", 15, white),
                        );
                },
              ))),
    );
  }

  //Send and Cancel Friend request
  Future<void> sendAndCancelFriendRequest(int type, String friendId) async {
    print(friendId);
    print(type);
    showProgressDialogBox(context);
    SharedPreferences userData = await _pref;
    String? token = userData.getString(_userDataConstants.token).toString();
    print(token);
    Map data = {"friend_id": friendId};
    var response = type == 1
        ? await http.delete(Uri.parse(BASE_URL + "friend_request/$friendId"),
            headers: {'api-key': API_KEY, 'x-access-token': token})
        : await http.post(Uri.parse(BASE_URL + "send_friend_request"),
            headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      await updateUserDataInformation();
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }

  //Accept and Reject Friend request
  Future<void> acceptRejectRequest(String type, String friendId) async {
    print(friendId);
    print(type);
    showProgressDialogBox(context);
    SharedPreferences userData = await _pref;
    String? token = userData.getString(_userDataConstants.token).toString();
    print(token);
    Map data = {"friend_id": friendId, "status": type};

    var response = await http.post(Uri.parse(BASE_URL + "do_friend"),
        headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);

    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      await updateUserDataInformation();
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }

  //Work Experiance data(done)
  Widget historyItemView(Experiences.Experiences expData) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: gray1),
      child: Row(
        children: [
          Image.asset(
            "assets/icons/briefcase.png",
            color: circleColor,
            height: 50,
            width: 50,
          ),
          customWidthBox(10),
          Column(
            crossAxisAlignment: cStart,
            children: [
              customText(expData.position.toString(), 13, white),
              customHeightBox(2),
              customText(expData.company.toString(), 10, white),
              customHeightBox(3),
              Row(
                children: [
                  Icon(
                    Icons.location_pin,
                    color: yellowColor,
                    size: 10,
                  ),
                  customWidthBox(5),
                  customText(expData.location.toString(), 9.5, white)
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  //Education History data(done)
  Widget eHistoryItemView(Educations.Educations education) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: gray1),
      child: Row(
        children: [
          Image.asset(
            "assets/icons/scholar.png",
            color: circleColor,
            height: 50,
            width: 50,
          ),
          customWidthBox(10),
          Column(
            crossAxisAlignment: cStart,
            children: [
              customText(education.subject.toString(), 13, white),
              customHeightBox(2),
              customText(education.institution.toString(), 10, white),
              customHeightBox(3),
              Row(
                children: [
                  Image.asset(
                    "assets/icons/scholar.png",
                    height: 10,
                    width: 10,
                    color: yellowColor,
                  ),
                  customText(" Chandigarh", 9.5, white)
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  //Follow and Unfollow user Alertbox
  void showFollowUnFollowUser(String userID, String type) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                height: 130,
                width: 200,
                decoration: BoxDecoration(
                    color: gray1, borderRadius: BorderRadius.circular(10)),
                child: Column(crossAxisAlignment: cCenter, children: [
                  customHeightBox(15),
                  customText("Unfollow Alert!", 15, white),
                  customDivider(10, white),
                  customHeightBox(5),
                  customText("Do you want to Unfollow this user?", 12, white24),
                  customHeightBox(30),
                  Row(
                    mainAxisAlignment: mCenter,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            Navigator.pop(context);
                            unfollow(userID, type);
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 7, bottom: 7, left: 30, right: 30),
                          decoration: BoxDecoration(
                              gradient: commonButtonLinearGridient,
                              borderRadius: BorderRadius.circular(10)),
                          child: customText("Unfollow", 13, white),
                        ),
                      ),
                      customWidthBox(15),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 7, bottom: 7, left: 30, right: 30),
                          decoration: BoxDecoration(
                              gradient: commonButtonLinearGridient,
                              borderRadius: BorderRadius.circular(10)),
                          child: customText("Cancel", 13, white),
                        ),
                      )
                    ],
                  )
                ]),
              ));
        });
  }

  //Event Items
  Widget eventItemWidget(Experiences.Events event) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      margin: EdgeInsets.only(right: 10),
      height: 30,
      decoration: BoxDecoration(
          gradient: commonButtonLinearGridient,
          borderRadius: BorderRadius.circular(30)),
      child: Center(
        child: customText(event.title.toString(), 12, white),
      ),
    );
  }

  //Follow unfollow user api
  Future<void> unfollow(String userId, String type) async {
    showProgressDialogBox(context);
    SharedPreferences userData = await _pref;
    String? token = userData.getString(_userDataConstants.token).toString();

    Map data = {"user_id": userId, "type": type};
    var response = await http.post(Uri.parse(BASE_URL + "follow"),
        headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      await updateUserDataInformation();
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }

  //Show the alert box when accept and reject the friend request
  void showlogoutdialog(BuildContext context, int type, String friendId) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                height: phoneHeight(context) / 5,
                decoration: BoxDecoration(
                    color: gray1, borderRadius: BorderRadius.circular(10)),
                child: Column(
                    crossAxisAlignment: cCenter,
                    mainAxisAlignment: mCenter,
                    children: [
                      Row(
                        children: [
                          Spacer(),
                          InkWell(
                            child: Icon(
                              Icons.close,
                              color: white,
                            ),
                          )
                        ],
                      ),
                      customHeightBox(15),
                      customText("Afro United", 15, white),
                      customHeightBox(15),
                      Center(
                        child: customText(
                            "Do you want to Accept and Reject the Friend Request?",
                            12,
                            white),
                      ),
                      customHeightBox(20),
                      Row(
                        mainAxisAlignment: mCenter,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              acceptRejectRequest("0", friendId);
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 25, right: 25),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: commonButtonLinearGridient),
                              child: Center(
                                  child: customText("Accept", 13, white)),
                            ),
                          ),
                          customWidthBox(10),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              acceptRejectRequest("1", friendId);
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 25, right: 25),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient: commonButtonLinearGridient),
                              child: Center(
                                  child: customText("Reject", 13, white)),
                            ),
                          )
                        ],
                      )
                    ]),
              ));
        });
  }
}
