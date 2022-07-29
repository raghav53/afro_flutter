import 'dart:convert';
import 'package:afro/Model/Friends/AllFriends/AllFriendsModel.dart';
import 'package:afro/Model/Friends/SendRequest/GetAllSendRequests.dart';
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
import 'package:afro/Util/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:afro/Model/Friends/ReceivedRequest/GetAllReceivedRequestModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Contacts/AllFriendsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Contacts/AllUserScreen.dart';

import 'package:afro/Screens/HomeScreens/Home/Contacts/SendFriendsRequest.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllContactsListScreen extends StatefulWidget {
  const AllContactsListScreen({Key? key}) : super(key: key);

  @override
  State<AllContactsListScreen> createState() => _AllContactsListScreenState();
}

class _AllContactsListScreenState extends State<AllContactsListScreen> {
  var selectedIndex = 0;
  var selectedText = "People You may Know";
  var user = UserDataConstants();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var searchFriend = "";
  List<String> titleList = [
    "People You May Know",
    "Contacts Requests",
    "Send Requests",
    "My Friends"
  ];

  List<String> filterList = [
    "Discover",
    "Contacts Requests",
    "Sent Requests",
    "My Friends"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: commonAppbar("Explore Contacts"),
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.only(top: 70),
          decoration: commonBoxDecoration(),
          height: phoneHeight(context),
          width: phoneWidth(context),
          child: Column(
            crossAxisAlignment: cStart,
            children: [
              customHeightBox(15),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: mCenter,
                  children: [
                    Flexible(
                        flex: 20,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black, offset: Offset(0, 2))
                              ]),
                          child: TextField(
                            onChanged: (value) => {
                              setState(() {
                                searchFriend = value.toString();
                              })
                            },
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Color(0xFFDFB48C),
                                ),
                                hintText: "Search",
                                contentPadding:
                                    EdgeInsets.only(left: 15, top: 15),
                                hintStyle: TextStyle(color: Colors.white24)),
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
                ),
              ),
              customHeightBox(15),
              //Fillters List
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: customText("Choose Fillters", 13, yellowColor),
              ),
              customHeightBox(10),
              Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                height: 25,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: filterList.length,
                    itemBuilder: (context, index) {
                      return filterItem(
                          filterList[index], index, titleList[index]);
                    }),
              ),
              customHeightBox(30),
              Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: customText(selectedText, 12, yellowColor),
              ),

              //Selected Listview(Discover by default)
              setTheListview(selectedIndex)
            ],
          ),
        ),
      ),
    );
  }

  //filterItem listview
  Widget filterItem(String filterList, int index, String title) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
          selectedText = title;
          setTheListview(index);
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        padding: EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
            gradient:
                (selectedIndex == index) ? commonButtonLinearGridient : null,
            border: (selectedIndex == index)
                ? null
                : Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
          child: customText(filterList, 10, Colors.white),
        ),
      ),
    );
  }

  //Selected  list
  setTheListview(int index) {
    print(index);
    if (index == 0) {
      return AllUsersPage();
    } else if (index == 1) {
      return FutureBuilder<ReceivedRequestModel>(
          future: getAllReceivedContactsRequests(context, search: searchFriend),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? AllReceivedFriendRequestsList(snapshot.data!)
                : Center(
                    child: CircularProgressIndicator(),
                  );
          });
    } else if (index == 3) {
      return FutureBuilder<UsersFriendsModel>(
          future: getAllFriends(context),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? ListAllFriendsOfUser(snapshot.data!)
                : Center(
                    child: CircularProgressIndicator(),
                  );
          });
    } else if (index == 2) {
      return FutureBuilder<SendRequestModel>(
          future: getAllSendRequests(context, search: searchFriend),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? AllSentFriendRequestList(snapshot.data!)
                : Center(
                    child: CircularProgressIndicator(),
                  );
          });
      ;
    }
  }

  ///Received friend requests List
  AllReceivedFriendRequestsList(ReceivedRequestModel snapshot) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Column(children: [
              Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        DottedBorder(
                          radius: const Radius.circular(2),
                          padding: const EdgeInsets.all(5),
                          borderType: BorderType.Circle,
                          color: const Color(0xFF3E55AF),
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            child: CachedNetworkImage(
                                imageUrl: IMAGE_URL +
                                    snapshot.data![index].friend!.profileImage
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
                          margin: const EdgeInsets.only(right: 3, bottom: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: commonButtonLinearGridient),
                        )
                      ],
                    ),
                    customWidthBox(10),
                    Column(
                      crossAxisAlignment: cStart,
                      children: [
                        customText(
                            snapshot.data![index].friend!.fullName.toString(),
                            15,
                            white),
                        customHeightBox(5),
                        Row(
                          children: [
                            Icon(
                              Icons.location_pin,
                              color: yellowColor,
                              size: 15,
                            ),
                            customText(
                                snapshot.data![index].friend!.city![0].name
                                    .toString(),
                                9.5,
                                white)
                          ],
                        )
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        InkWell(
                          onTap: () {
                            acceptAndRejectRequest(
                                snapshot.data![index].friend!.sId.toString(),
                                snapshot.data![index].friend!.fullName
                                    .toString(),
                                "0");
                          },
                          child: Image.asset(
                            "assets/icons/check_right_icon.png",
                            height: 18,
                            width: 18,
                            color: white,
                          ),
                        ),
                        customWidthBox(20),
                        InkWell(
                          onTap: () {
                            acceptAndRejectRequest(
                                snapshot.data![index].friend!.sId.toString(),
                                snapshot.data![index].friend!.fullName
                                    .toString(),
                                "1");
                          },
                          child: const Icon(
                            Icons.close,
                            size: 25,
                            color: Colors.red,
                          ),
                        )
                      ],
                    )
                  ]))
            ]);
          }),
    );
  }

  Future<void> acceptRejectFriendRequest(String type, String friendId) async {
    SharedPreferences userData = await _prefs;
    String? token = userData.getString(user.token).toString();
    print(token);
    Map data = {"friend_id": friendId, "status": type};

    var response = await http.post(Uri.parse(BASE_URL + "do_friend"),
        headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);

    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }

  acceptAndRejectRequest(String fId, String name, String type) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                padding: EdgeInsets.all(20),
                height: 165,
                decoration: BoxDecoration(
                    color: gray1, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    customText(
                        type == "0"
                            ? "Accept friend request!"
                            : "Reject friend request!",
                        15,
                        white),
                    customHeightBox(15),
                    Text(
                      type == "0"
                          ? "Accept friend request of $name?"
                          : "Are you sure want to delete friend request of  $name?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: white24),
                    ),
                    customHeightBox(30),
                    Row(mainAxisAlignment: mCenter, children: [
                      InkWell(
                        onTap: () {
                          type == "0"
                              ? acceptRejectFriendRequest("0", fId)
                              : acceptRejectFriendRequest("1", fId);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: commonButtonLinearGridient),
                          child: Center(
                            child: customText(
                                type == "0" ? "Accept" : "Reject", 15, white),
                          ),
                        ),
                      ),
                      customWidthBox(10),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: white, width: 1)),
                          child: Center(
                            child: customText("Cancel", 15, white),
                          ),
                        ),
                      )
                    ])
                  ],
                ),
              ));
        });
  }

  //Sent Friend requests list
  AllSentFriendRequestList(SendRequestModel snapshot) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OtherUserProfilePageScreen(
                              name: snapshot.data![index].friend!.fullName,
                              userID: snapshot.data![index].friend!.sId,
                            )));
              },
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            DottedBorder(
                              radius: const Radius.circular(2),
                              padding: const EdgeInsets.all(5),
                              borderType: BorderType.Circle,
                              color: const Color(0xFF3E55AF),
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                child: CachedNetworkImage(
                                    imageUrl: IMAGE_URL +
                                        snapshot
                                            .data![index].friend!.profileImage
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
                              margin:
                                  const EdgeInsets.only(right: 3, bottom: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: commonButtonLinearGridient),
                            )
                          ],
                        ),
                        customWidthBox(10),
                        Column(
                          crossAxisAlignment: cStart,
                          children: [
                            customText(
                                snapshot.data![index].friend!.fullName
                                    .toString(),
                                15,
                                white),
                            customHeightBox(5),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: yellowColor,
                                  size: 15,
                                ),
                                customText(
                                    snapshot.data![index].friend!.city![0].name
                                        .toString(),
                                    9.5,
                                    white)
                              ],
                            )
                          ],
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            showTheAlertBox(
                                context,
                                snapshot.data![index].friend!.fullName
                                    .toString(),
                                snapshot.data![index].friend!.sId.toString());
                          },
                          child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Image.asset(
                                "assets/icons/request_send.png",
                                height: 25,
                                width: 25,
                                color: circleColor,
                              )),
                        )
                      ],
                    ),
                  ),
                  customDivider(10, white)
                ],
              ),
            );
          }),
    );
  }

  //alert box accept and reject friend request
  showTheAlertBox(BuildContext context, String name, String friendId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                padding: EdgeInsets.all(20),
                height: 170,
                decoration: BoxDecoration(
                    color: gray1, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    customText("Cancel friend request!", 15, white),
                    customHeightBox(15),
                    const Text(
                      "Are you sure want to cancel friend request?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 13,
                          color: Color(0x3DFFFFFF),
                          fontWeight: FontWeight.bold),
                    ),
                    customHeightBox(30),
                    Row(mainAxisAlignment: mCenter, children: [
                      InkWell(
                        onTap: () {
                          cancelFriendRequest(context, friendId);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: commonButtonLinearGridient),
                          child: Center(
                            child: customText("Remove", 15, white),
                          ),
                        ),
                      ),
                      customWidthBox(10),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: white, width: 1)),
                          child: Center(
                            child: customText("Cancel", 15, white),
                          ),
                        ),
                      )
                    ])
                  ],
                ),
              ));
        });
  }

  //Cancel friend
  Future<void> cancelFriendRequest(
      BuildContext context, String friendId) async {
    print(friendId);
    showProgressDialogBox(context);
    SharedPreferences userData = await _prefs;
    String? token = userData.getString(user.token).toString();
    print(token);

    var response = await http.delete(
        Uri.parse(BASE_URL + "friend_request/$friendId"),
        headers: {'api-key': API_KEY, 'x-access-token': token});
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      print("Cancel friend request successfully......");
      Navigator.pop(context);
      Navigator.pop(context);
      setState(() {});
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      print(message);
      customToastMsg(message);
    }
  }

  //Users friends list
  ListAllFriendsOfUser(UsersFriendsModel snapshot) {
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Row(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          DottedBorder(
                            radius: const Radius.circular(2),
                            padding: const EdgeInsets.all(5),
                            borderType: BorderType.Circle,
                            color: const Color(0xFF3E55AF),
                            child: Container(
                              padding: const EdgeInsets.all(1),
                              child: CachedNetworkImage(
                                  imageUrl: IMAGE_URL +
                                      snapshot.data![index].friend!.profileImage
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
                            margin: const EdgeInsets.only(right: 3, bottom: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                gradient: commonButtonLinearGridient),
                          )
                        ],
                      ),
                      customWidthBox(10),
                      Column(
                        crossAxisAlignment: cStart,
                        children: [
                          customText(
                              snapshot.data![index].friend!.fullName.toString(),
                              15,
                              white),
                          customHeightBox(5),
                          Row(
                            children: [
                              Icon(
                                Icons.location_pin,
                                color: yellowColor,
                                size: 15,
                              ),
                              customText(
                                  snapshot.data![index].friend!.city!.isEmpty
                                      ? "Not available"
                                      : snapshot
                                          .data![index].friend!.city![0].title
                                          .toString(),
                                  9.5,
                                  white)
                            ],
                          )
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          showTheAlertBox(
                              context,
                              snapshot.data![index].friend!.fullName.toString(),
                              snapshot.data![index].friend!.sId.toString());
                        },
                        child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Image.asset(
                              "assets/icons/friends.png",
                              height: 25,
                              width: 25,
                              color: circleColor,
                            )),
                      )
                    ],
                  ),
                ),
                customDivider(10, white)
              ],
            );
          }),
    );
  }

  //Show the unfriend alertbox
  showTheUnFriendAlertBox(BuildContext context, String name, String friendId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                padding: EdgeInsets.all(20),
                height: 170,
                decoration: BoxDecoration(
                    color: gray1, borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    customText("Remove " + name + " as a friend", 15, white),
                    customHeightBox(15),
                    Text(
                      "Are you sure want to remove " +
                          name +
                          " as your friend?",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0x3DFFFFFF),
                          fontWeight: FontWeight.bold),
                    ),
                    customHeightBox(30),
                    Row(mainAxisAlignment: mCenter, children: [
                      InkWell(
                        onTap: () {
                          unfriendUser(context, friendId);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: commonButtonLinearGridient),
                          child: Center(
                            child: customText("Remove", 15, white),
                          ),
                        ),
                      ),
                      customWidthBox(10),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 20, right: 20),
                          height: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: white, width: 1)),
                          child: Center(
                            child: customText("Cancel", 15, white),
                          ),
                        ),
                      )
                    ])
                  ],
                ),
              ));
        });
  }

//Unfriend the user
  Future<void> unfriendUser(BuildContext context, String friendId) async {
    print(friendId);

    showProgressDialogBox(context);
    SharedPreferences userData = await _prefs;
    String? token = userData.getString(user.token).toString();
    print(token);
    Map data = {"friend_id": friendId};
    var response = await http.post(Uri.parse(BASE_URL + "unfriend"),
        headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      print("Unfriend successfully......");
      Navigator.pop(context);
      Navigator.pop(context);
      setState(() {});
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      print(message);
      customToastMsg(message);
    }
  }
}
