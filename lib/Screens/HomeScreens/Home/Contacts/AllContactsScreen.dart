import 'dart:convert';
import 'package:afro/Model/AllInterestsModel.dart';
import 'package:afro/Model/CountryModel.dart';
import 'package:afro/Model/Friends/AllFriends/AllFriendsModel.dart';

import 'package:afro/Model/Friends/AllUsers/GetAllUsers.dart';
import 'package:afro/Model/Friends/SendRequest/GetAllSendRequests.dart';
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
import 'package:afro/Util/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:afro/Model/Friends/ReceivedRequest/GetAllReceivedRequestModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Model/Friends/AllUsers/AllUsersDataModel.dart'
    as AllFriendsDataModel;
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
  Future<CountryModel>? _getCountries;
  Future<AllInterestModel>? _getAllInterests;
  int _startInterestedRange = 0;
  int _endIntetestedRange = 100;
  var selectedInterestedRange = const RangeValues(0, 100);
  String countriesIds = "";
  List<String> tempCountriesIds = [];
  String interestsIds = "";
  List<String> tempInterestsIds = [];
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
  void initState() {
    // TODO: implement initState
    super.initState();
    getInterestsList();
    getCountries();
  }

  defaultValues() {
    setState(() {
      _endIntetestedRange = 0;
      _startInterestedRange = 100;
      selectedInterestedRange = const RangeValues(0, 100);
      tempCountriesIds.clear();
      tempInterestsIds.clear();
      countriesIds = "";
      interestsIds = "";
      searchFriend = "";
    });
  }

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
                            openFillterbottomSheet();
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
      return FutureBuilder<GetAllFriendsModel>(
          future: getAllUsers(context,
              search: searchFriend,
              country: countriesIds,
              interests: interestsIds,
              min_age: _startInterestedRange.toString(),
              max_age: _endIntetestedRange.toString()),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? ListAllDiscoverUsers(snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          });
    } else if (index == 1) {
      return FutureBuilder<ReceivedRequestModel>(
          future: getAllReceivedContactsRequests(context, search: searchFriend),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? AllReceivedFriendRequestsList(snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          });
    } else if (index == 3) {
      return FutureBuilder<UsersFriendsModel>(
          future: getAllFriends(context),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? ListAllFriendsOfUser(snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          });
    } else if (index == 2) {
      return FutureBuilder<SendRequestModel>(
          future: getAllSendRequests(context, search: searchFriend),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data != null
                ? AllSentFriendRequestList(snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          });
      ;
    }
  }

  //ListView
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
                            showCancelFriendRequestAlertBox(
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
                          showTheUnFriendAlertBox(
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

  //Discover Contacts/Friends
  ListAllDiscoverUsers(GetAllFriendsModel snapshot) {
    return Flexible(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data!.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OtherUserProfilePageScreen(
                                name: snapshot.data![index].fullName,
                                userID: snapshot.data![index].sId,
                              )));
                },
                child: ListTile(
                  leading: Stack(
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
                                  snapshot.data![index].profileImage.toString(),
                              errorWidget: (error, context, url) =>
                                  const Icon(Icons.person),
                              placeholder: (context, url) =>
                                  const Icon(Icons.person),
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
                  title: customText(
                      snapshot.data![index].fullName.toString(), 15, white),
                  subtitle: Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        color: yellowColor,
                        size: 15,
                      ),
                      customText(
                          snapshot.data![index].city!.isEmpty
                              ? "Not available!"
                              : snapshot.data![index].city![0].title.toString(),
                          9.5,
                          white)
                    ],
                  ),
                  trailing: checkStatus(context, snapshot.data![index])!,
                ));
          }),
    );
  }

  Widget? checkStatus(
      BuildContext context, AllFriendsDataModel.AllUserDataModel user) {
    return user.isFriend == 0 && user.isReqReceived == 0 && user.isReqSent == 0
        ? InkWell(
            onTap: () {
              FriendRequest(context, 0, user.sId.toString());
            },
            child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Image.asset(
                  "assets/icons/add_user.png",
                  height: 25,
                  width: 25,
                  color: circleColor,
                )),
          )
        : user.isReqSent == 1
            ? InkWell(
                onTap: () {
                  showCancelFriendRequestAlertBox(
                      context, user.fullName.toString(), user.sId.toString());
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
            : user.isFriend == 1
                ? InkWell(
                    onTap: () {
                      showTheUnFriendAlertBox(context, user.fullName.toString(),
                          user.sId.toString());
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
                : user.isReqReceived == 1
                    ? Row(
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Image.asset(
                              "assets/icons/check_right_icon.png",
                              height: 18,
                              width: 18,
                              color: white,
                            ),
                          ),
                          customWidthBox(10),
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.close,
                              size: 25,
                              color: Colors.red,
                            ),
                          )
                        ],
                      )
                    : null;
  }

  //Alert Boxes
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

  //alert box accept and reject friend request
  showCancelFriendRequestAlertBox(
      BuildContext context, String name, String friendId) {
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

  //Alert box of Accept and Reject Request
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

  //Friends Apis
  //Unfriend the user api
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

  //Accept and Reject Friend REquest api
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

  //Cancel friend api
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

  //Send Friend request
  Future<void> FriendRequest(
      BuildContext context, int type, String friendId) async {
    print(friendId);
    print(type);
    showProgressDialogBox(context);
    SharedPreferences userData = await _prefs;
    String? token = userData.getString(user.token).toString();
    print(token);
    Map data = {"friend_id": friendId};
    var response = await http.post(Uri.parse(BASE_URL + "send_friend_request"),
        headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);
    var jsonResponse = json.decode(response.body);
    print(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      setState(() {});
      print("Friend request send successfully...");
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

  //Bottomsheet Fillters--------------------------
  openFillterbottomSheet() {
    var selectedBottomIndex = 0;
    var indexTitle = "Country";
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
                decoration: commonBoxDecoration(),
                child: Column(children: [
                  customHeightBox(15),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: mBetween,
                      children: [
                        customText(
                            "Filter & Sort", 12, const Color(0xFFDFB48C)),
                        customText(indexTitle, 12, const Color(0xFFDFB48C)),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                  ),
                  customDivider(5, Colors.white),
                  Row(crossAxisAlignment: cStart, children: [
                    Container(
                        padding: const EdgeInsets.only(top: 15, left: 10),
                        child: Column(
                            mainAxisAlignment: mStart,
                            crossAxisAlignment: cStart,
                            children: [
                              InkWell(
                                onTap: () {
                                  state(() {
                                    selectedBottomIndex = 0;
                                    indexTitle = "Country";
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: (selectedBottomIndex == 0)
                                          ? commonButtonLinearGridient
                                          : null,
                                      border: selectedBottomIndex != 0
                                          ? Border.all(
                                              color: Colors.white,
                                              width: 1,
                                              style: BorderStyle.solid)
                                          : null,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child:
                                        customText("Country", 12, Colors.white),
                                  )),
                                ),
                              ),
                              customHeightBox(15),
                              InkWell(
                                onTap: () {
                                  state(() {
                                    selectedBottomIndex = 1;
                                    indexTitle = "Interests";
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: (selectedBottomIndex == 1)
                                          ? commonButtonLinearGridient
                                          : null,
                                      border: selectedBottomIndex != 1
                                          ? Border.all(
                                              color: Colors.white,
                                              width: 1,
                                              style: BorderStyle.solid)
                                          : null,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: customText(
                                        "Interests", 12, Colors.white),
                                  )),
                                ),
                              ),
                              customHeightBox(15),
                              InkWell(
                                onTap: () {
                                  state(() {
                                    selectedBottomIndex = 2;
                                    indexTitle = "Age";
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: (selectedBottomIndex == 2)
                                          ? commonButtonLinearGridient
                                          : null,
                                      border: selectedBottomIndex != 2
                                          ? Border.all(
                                              color: Colors.white,
                                              width: 1,
                                              style: BorderStyle.solid)
                                          : null,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: customText("Age", 12, Colors.white),
                                  )),
                                ),
                              ),
                              customHeightBox(15),
                              InkWell(
                                onTap: () {
                                  state(() {});
                                  defaultValues();
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 80,
                                  decoration: BoxDecoration(
                                      gradient: (selectedBottomIndex == 3)
                                          ? commonButtonLinearGridient
                                          : null,
                                      border: selectedBottomIndex != 3
                                          ? Border.all(
                                              color: Colors.white,
                                              width: 1,
                                              style: BorderStyle.solid)
                                          : null,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Center(
                                      child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: customText(
                                        "Clear All", 12, Colors.white),
                                  )),
                                ),
                              ),
                            ])),
                    Container(
                        margin: const EdgeInsets.only(left: 15),
                        height: phoneHeight(context) / 2.07,
                        decoration: const BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    color: Colors.grey, width: 0.8))),
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                                width: phoneWidth(context) / 1.5,
                                child: selectedBottomIndex == 0
                                    ? Column(
                                        children: [
                                          Container(
                                            height: 40,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Colors.black),
                                            margin: const EdgeInsets.only(
                                                top: 15, left: 10),
                                            child: const TextField(
                                                keyboardType:
                                                    TextInputType.text,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          top: 8, left: 15),
                                                  prefixIcon: Icon(
                                                    Icons.search,
                                                    color: Color(0xFFDFB48C),
                                                  ),
                                                )),
                                          ),
                                          customHeightBox(10),
                                          Flexible(
                                              child:
                                                  FutureBuilder<CountryModel>(
                                            future: _getCountries,
                                            builder: (context, snapshot) {
                                              return snapshot.hasData &&
                                                      snapshot.data != null
                                                  ? ListView.builder(
                                                      itemCount: snapshot
                                                          .data!.data!.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return ListTile(
                                                          leading:
                                                              CachedNetworkImage(
                                                            height: 35,
                                                            width: 35,
                                                            imageUrl: flagImageUrl
                                                                    .toString() +
                                                                snapshot
                                                                    .data!
                                                                    .data![
                                                                        index]
                                                                    .iso2
                                                                    .toString()
                                                                    .toLowerCase() +
                                                                ".png",
                                                            placeholder: (context,
                                                                    url) =>
                                                                const Icon(
                                                                    Icons.flag),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
                                                                const Icon(Icons
                                                                    .error),
                                                          ),
                                                          title: customText(
                                                              snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .title
                                                                  .toString(),
                                                              15,
                                                              white),
                                                          trailing: Checkbox(
                                                              value: snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .isSelected,
                                                              onChanged: (val) {
                                                                state(() {
                                                                  snapshot
                                                                          .data!
                                                                          .data![
                                                                              index]
                                                                          .isSelected =
                                                                      !snapshot
                                                                          .data!
                                                                          .data![
                                                                              index]
                                                                          .isSelected;
                                                                  addRemoveCountriesIds(
                                                                      snapshot
                                                                          .data!
                                                                          .data![
                                                                              index]
                                                                          .sId
                                                                          .toString(),
                                                                      snapshot
                                                                          .data!
                                                                          .data![
                                                                              index]
                                                                          .isSelected);
                                                                });
                                                              }),
                                                        );
                                                      })
                                                  : Center(
                                                      child: customText(
                                                          "No countries found!",
                                                          15,
                                                          white),
                                                    );
                                            },
                                          ))
                                        ],
                                      )
                                    : selectedBottomIndex == 2
                                        ? Flexible(
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    top: 15,
                                                    left: 10,
                                                    right: 10),
                                                width: 270,
                                                child: Column(
                                                    crossAxisAlignment: cCenter,
                                                    children: [
                                                      RangeSlider(
                                                        activeColor:
                                                            yellowColor,
                                                        inactiveColor: white,
                                                        min: 0,
                                                        max: 100,
                                                        values:
                                                            selectedInterestedRange,
                                                        onChanged: (RangeValues
                                                            newValue) {
                                                          state(() {
                                                            selectedInterestedRange =
                                                                newValue;
                                                            _startInterestedRange =
                                                                newValue.start
                                                                    .toInt();
                                                            _endIntetestedRange =
                                                                newValue.end
                                                                    .toInt();
                                                          });
                                                        },
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 20,
                                                                right: 11),
                                                        child: Row(
                                                          children: [
                                                            customText(
                                                                "min " +
                                                                    _startInterestedRange
                                                                        .toString(),
                                                                15,
                                                                white),
                                                            Spacer(),
                                                            customText(
                                                                "max " +
                                                                    _endIntetestedRange
                                                                        .toString(),
                                                                15,
                                                                white)
                                                          ],
                                                        ),
                                                      )
                                                    ])),
                                          )
                                        : selectedBottomIndex == 1
                                            ? Flexible(
                                                child:
                                                    FutureBuilder<
                                                            AllInterestModel>(
                                                        future:
                                                            _getAllInterests,
                                                        builder: (context,
                                                            snapshot) {
                                                          return snapshot
                                                                      .hasData &&
                                                                  snapshot.data !=
                                                                      null
                                                              ? ListView
                                                                  .builder(
                                                                      itemCount: snapshot
                                                                          .data!
                                                                          .data!
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return ListTile(
                                                                          title: customText(
                                                                              snapshot.data!.data![index].title.toString(),
                                                                              15,
                                                                              white),
                                                                          trailing: Checkbox(
                                                                              value: snapshot.data!.data![index].isSelected,
                                                                              onChanged: (val) {
                                                                                state(() {
                                                                                  snapshot.data!.data![index].isSelected = !snapshot.data!.data![index].isSelected;
                                                                                  addRemoveInterestsIds(snapshot.data!.data![index].sId.toString(), snapshot.data!.data![index].isSelected);
                                                                                });
                                                                              }),
                                                                        );
                                                                      })
                                                              : Center(
                                                                  child: customText(
                                                                      "No categories found!",
                                                                      15,
                                                                      white),
                                                                );
                                                        }))
                                            : Container()),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: InkWell(
                                onTap: () {
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                child: Container(
                                    margin: EdgeInsets.only(bottom: 15),
                                    padding: const EdgeInsets.only(
                                        top: 7, bottom: 7, left: 20, right: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      gradient: commonButtonLinearGridient,
                                    ),
                                    child:
                                        customText("Apply", 16, Colors.white)),
                              ),
                            )
                          ],
                        ))
                  ])
                ]));
          });
        });
  }

  //Get countries
  getCountries() {
    Future.delayed(Duration.zero, () {
      _getCountries = getCountriesList(context, isShow: false);
      setState(() {});
      _getCountries!.whenComplete(() => {});
    });
  }

  //Get All Interests list
  getInterestsList() {
    Future.delayed(Duration.zero, () {
      _getAllInterests = getInterestssList(context, isShow: false);
      setState(() {});
      _getAllInterests!.whenComplete(() => () {});
    });
  }

  //Remove and add items into list
  addRemoveCountriesIds(String id, bool value) {
    if (value) {
      tempCountriesIds.add(id.toString());
    } else {
      tempCountriesIds.remove(id.toString());
    }
    countriesIds = tempCountriesIds.join(",");
  }

  addRemoveInterestsIds(String id, bool value) {
    if (value) {
      tempInterestsIds.add(id.toString());
    } else {
      tempInterestsIds.remove(id.toString());
    }
    interestsIds = tempInterestsIds.join(",");
  }
}
