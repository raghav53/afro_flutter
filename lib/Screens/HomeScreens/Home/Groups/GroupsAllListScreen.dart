import 'dart:convert';
import 'package:afro/Model/AllInterestsModel.dart';
import 'package:afro/Model/CountryModel.dart';
import 'package:afro/Model/Group/AllGroupModel.dart';
import 'package:afro/Model/Group/JoinedGroup/JoinedGroupmodel.dart';
import 'package:afro/Model/Group/UserGroups/UserGroupsModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupDetailsPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/CreateNewGroupScreen.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GroupsAllListScreen extends StatefulWidget {
  const GroupsAllListScreen({Key? key}) : super(key: key);

  @override
  State<GroupsAllListScreen> createState() => _GroupsAllListScreenState();
}

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
String? userID, countryId;
var searchGroup = "";
String countriesIds = "";
List<String> tempCountriesIds = [];
String interestsIds = "";

List<String> tempInterestsIds = [];
Future<CountryModel>? _getCountries;
Future<AllInterestModel>? _getAllInterests;
int _startInterestedRange = 0;
int _endIntetestedRange = 500;
var selectedInterestedRange = const RangeValues(0, 500);

var selectedCategoryIndex = -1;
String? searchCategory = "";

class _GroupsAllListScreenState extends State<GroupsAllListScreen> {
  int clickPosition = 0;
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
    getUserData();
    getCountries();
    getInterestsList();
  }

  defaultValues() {
    setState(() {
      countriesIds = "";
      interestsIds = "";
      tempCountriesIds.clear();
      tempInterestsIds.clear();
      _startInterestedRange = 0;
      _endIntetestedRange = 500;
      selectedInterestedRange = const RangeValues(0, 500);
      searchCategory = "";
      getInterestsList();
      getCountries();
    });
  }

  getUserData() async {
    SharedPreferences sharedPreferences = await _prefs;
    userID = sharedPreferences.getString(user.id).toString();
    countryId = sharedPreferences.getString(user.countryId);
  }

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
                  defaultValues();
                  setState(() {
                    _showFab = false;

                    clickPosition = 0;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      gradient: (clickPosition == 0)
                          ? commonButtonLinearGridient
                          : null,
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
                  defaultValues();
                  setState(() {
                    _showFab = false;

                    clickPosition = 1;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      gradient: (clickPosition == 1)
                          ? commonButtonLinearGridient
                          : null,
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
                  defaultValues();
                  setState(() {
                    _showFab = true;
                    clickPosition = 2;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  decoration: BoxDecoration(
                      gradient: (clickPosition == 2)
                          ? commonButtonLinearGridient
                          : null,
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
                onChanged: (value) {
                  setState(() {
                    searchGroup = value.toString();
                  });
                },
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration: const InputDecoration(
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
                clickPosition == 0 ? openFillterbottomSheet() : null;
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
      return FutureBuilder<AllGroupsModel>(
          future: getAllGroups(
              search: searchGroup,
              members_min: _startInterestedRange.toString(),
              members_max: _endIntetestedRange.toString(),
              interests: interestsIds,
              country: countriesIds),
          builder: (context, snapshot) {
            print("kjvgkvcyvctkucdkghfm: $snapshot");
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? DiscoverGroupsList(snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          });
    } else if (postion == 1) {
      return FutureBuilder<JoinedGroupModel>(
          future: getAllJoinedGroups(search: searchGroup),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? JoinedGroupsList(snapshot.data!)
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          });
    } else if (postion == 2) {
      return FutureBuilder<UserGroupsModel>(
          future: getAllUsersGroups(search: searchGroup),
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                ? MyGroupsListScreen(context, snapshot.data!)
                : const CircularProgressIndicator();
          });
    }
  }

//Discover groups List
  DiscoverGroupsList(AllGroupsModel snapshot) {
    return Container(
      width: phoneWidth(context),
      height: 400,
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroupDetailsPage(
                          groupId: snapshot.data![index].sId.toString(),
                          groupAdmin: snapshot.data![index].userId.toString(),
                        )));
              },
              child: Container(
                margin: EdgeInsets.only(
                    top: 10,
                    left: 20,
                    right: 5,
                    bottom: snapshot.data!.length - 1 == index ? 20 : 0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
                child: Row(children: [
                  CachedNetworkImage(
                      imageUrl: IMAGE_URL +
                          snapshot.data![index].coverImage!.toString(),
                      errorWidget: (error, context, url) =>
                          const Icon(Icons.person),
                      placeholder: (context, url) => const Icon(Icons.person),
                      imageBuilder: (context, url) {
                        return CircleAvatar(
                          backgroundImage: url,
                        );
                      }),
                  customWidthBox(10),
                  Column(
                    crossAxisAlignment: cStart,
                    children: [
                      SizedBox(
                          width: 120,
                          child: Text(
                            snapshot.data![index].title.toString(),
                            overflow: TextOverflow.fade,
                            maxLines: null,
                            softWrap: false,
                            style: TextStyle(color: white, fontSize: 11),
                          )),
                      customHeightBox(5),
                      Row(
                        children: [
                          customText(
                              snapshot.data![index].totalMembers.toString() +
                                  " Members",
                              11,
                              yellowColor)
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      if (userID.toString() ==
                          snapshot.data![index].userId.toString()) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GroupDetailsPage(
                                groupId: snapshot.data![index].sId.toString(),
                                groupAdmin:
                                    snapshot.data![index].userId.toString())));
                      }
                      if (snapshot.data![index].isMember == 1 &&
                          userID.toString() !=
                              snapshot.data![index].userId.toString()) {
                        showLeaveDialogBox(
                            context, snapshot.data![index].sId.toString());
                      }
                      if (snapshot.data![index].isMember == 0 &&
                          snapshot.data![index].isMember == 0) {
                        leaveJoinTheGroup(
                            context, snapshot.data![index].sId.toString(), 2);
                      }
                    },
                    child: Container(
                      width: 110,
                      margin: const EdgeInsets.only(right: 20),
                      padding: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: commonButtonLinearGridient),
                      child: Center(
                          child: customText(
                              snapshot.data![index].userId.toString() ==
                                      userID.toString()
                                  ? "View Details"
                                  : snapshot.data![index].isMember == 1
                                      ? "Leave"
                                      : snapshot.data![index].isJoinSent == 1
                                          ? "Cancel Request"
                                          : snapshot.data![index]
                                                      .isInviteRecieved ==
                                                  1
                                              ? "Accept Request"
                                              : "Join Group",
                              11,
                              white)),
                    ),
                  )
                ]),
              ),
            );
          }),
    );
  }

//Show leave group Dialog Box
  void showLeaveDialogBox(BuildContext context, String groupId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                  height: 120,
                  width: 200,
                  decoration: BoxDecoration(
                      color: gray1, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                      crossAxisAlignment: cCenter,
                      mainAxisAlignment: mCenter,
                      children: [
                        customText("Afro United", 16, white),
                        customHeightBox(5),
                        customText(
                            "Are you sure to want leave into this group?",
                            13,
                            white),
                        customHeightBox(15),
                        Row(
                          crossAxisAlignment: cCenter,
                          mainAxisAlignment: mCenter,
                          children: [
                            InkWell(
                              onTap: () {
                                leaveJoinTheGroup(context, groupId, 1);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                width: 80,
                                decoration: BoxDecoration(
                                    gradient: commonButtonLinearGridient,
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                    child: customText("Leave", 13, white)),
                              ),
                            ),
                            customWidthBox(30),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.only(top: 8, bottom: 8),
                                width: 80,
                                decoration: BoxDecoration(
                                    border: Border.all(color: white, width: 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: Center(
                                    child: customText("Cancel", 13, white)),
                              ),
                            ),
                          ],
                        )
                      ])));
        });
  }

//Leave/Join the group api
  Future<void> leaveJoinTheGroup(
      BuildContext context, String groupId, int type) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    var user = UserDataConstants();
    String token = sharedPreferences.getString(user.token).toString();
    var jsonResponse = null;
    var apiName = type == 1
        ? "leave_group"
        : type == 2
            ? "join_group"
            : "";
    var response = await http.post(Uri.parse(BASE_URL + apiName), headers: {
      'api-key': API_KEY,
      'x-access-token': token,
    }, body: {
      "group_id": groupId
    });
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      if (type == 1) {
        Navigator.pop(context);
      }
      setState(() {});
      print("leave group  api success");
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
      throw Exception("Failed to load the work experience!");
    }
  }

  //Joined Groups List
  JoinedGroupsList(JoinedGroupModel snapshot) {
    return Container(
        height: 400,
        width: phoneWidth(context),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(top: 10, left: 10, right: 5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
                child: Column(
                  children: [
                    Row(children: [
                      CachedNetworkImage(
                          imageUrl: IMAGE_URL +
                              snapshot.data![index].group!.coverImage!
                                  .toString(),
                          errorWidget: (error, context, url) =>
                              const Icon(Icons.person),
                          placeholder: (context, url) =>
                              const Icon(Icons.person),
                          imageBuilder: (context, url) {
                            return CircleAvatar(
                              backgroundImage: url,
                            );
                          }),
                      customWidthBox(10),
                      Column(
                        crossAxisAlignment: cStart,
                        children: [
                          SizedBox(
                              width: 120,
                              child: Text(
                                snapshot.data![index].group!.title.toString(),
                                overflow: TextOverflow.fade,
                                maxLines: null,
                                softWrap: false,
                                style: TextStyle(color: white, fontSize: 11),
                              )),
                          customHeightBox(5),
                          Row(
                            children: [
                              customText(
                                  snapshot.data![index].group!.totalMembers
                                          .toString() +
                                      " Members",
                                  11,
                                  yellowColor)
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          userID ==
                                  snapshot.data![index].group!.userId!
                                      .toString()
                              ? Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => GroupDetailsPage(
                                        groupId: snapshot.data![index].groupId
                                            .toString(),
                                        groupAdmin: snapshot
                                            .data![index].group!.userId
                                            .toString(),
                                      )))
                              : showLeaveDialogBox(context,
                                  snapshot.data![index].groupId.toString());
                        },
                        child: Container(
                          width: 110,
                          margin: const EdgeInsets.only(right: 20),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: commonButtonLinearGridient),
                          child: Center(
                              child: customText(
                                  userID ==
                                          snapshot.data![index].group!.userId!
                                              .toString()
                                      ? "View Details"
                                      : "Leave",
                                  11,
                                  white)),
                        ),
                      )
                    ]),
                  ],
                ),
              );
            }));
  }

  //User Groups List
  MyGroupsListScreen(BuildContext context, UserGroupsModel snapshot) {
    return Container(
        width: phoneWidth(context),
        height: 400,
        child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(top: 10, left: 15, right: 5),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
                child: Column(
                  children: [
                    Row(children: [
                      CachedNetworkImage(
                          imageUrl: IMAGE_URL +
                              snapshot.data![index].coverImage!.toString(),
                          errorWidget: (error, context, url) =>
                              const Icon(Icons.person),
                          placeholder: (context, url) =>
                              const Icon(Icons.person),
                          imageBuilder: (context, url) {
                            return CircleAvatar(
                              backgroundImage: url,
                            );
                          }),
                      customWidthBox(10),
                      Column(
                        crossAxisAlignment: cStart,
                        children: [
                          SizedBox(
                              width: 120,
                              child: Text(
                                snapshot.data![index].title.toString(),
                                overflow: TextOverflow.fade,
                                maxLines: null,
                                softWrap: false,
                                style: TextStyle(color: white, fontSize: 11),
                              )),
                          customHeightBox(5),
                          Row(
                            children: [
                              customText(
                                  snapshot.data![index].totalMembers
                                          .toString() +
                                      " Members",
                                  11,
                                  yellowColor)
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => GroupDetailsPage(
                                    groupId:
                                        snapshot.data![index].id.toString(),
                                    groupAdmin: snapshot.data![index].userId!.id
                                        .toString(),
                                  )));
                        },
                        child: Container(
                          width: 110,
                          margin: const EdgeInsets.only(right: 20),
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: commonButtonLinearGridient),
                          child: Center(
                              child: customText("View Details", 11, white)),
                        ),
                      )
                    ]),
                  ],
                ),
              );
            }));
  }

  //Get all user groups
  Future<UserGroupsModel> getAllUsersGroups({
    String search = "",
    bool showProgress = true,
    String page = "1",
    String limit = "500",
  }) async {
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    String userId = sharedPreferences.getString(user.id).toString();
    print(token);

    var jsonResponse = null;

    var response = await http.get(
        Uri.parse(
            BASE_URL + "user_groups?page=$page&limit=$limit&search=$search"),
        headers: {
          'api-key': API_KEY,
          'x-access-token': token,
        });
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      print("Get All Users groups api success");
      print(jsonResponse["metadata"]["totalDocs"]);
      return UserGroupsModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      customToastMsg(message);
      throw Exception("Failed to load the work experience!");
    }
  }

  //BottomSheet
  openFillterbottomSheet() {
    var selectedBottomIndex = 1;
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
                              // InkWell(
                              //   onTap: () {
                              //     state(() {
                              //       selectedBottomIndex = 0;
                              //       indexTitle = "Country";
                              //     });
                              //   },
                              //   child: Container(
                              //     width: 80,
                              //     decoration: BoxDecoration(
                              //         gradient: (selectedBottomIndex == 0)
                              //             ? commonButtonLinearGridient
                              //             : null,
                              //         border: selectedBottomIndex != 0
                              //             ? Border.all(
                              //                 color: Colors.white,
                              //                 width: 1,
                              //                 style: BorderStyle.solid)
                              //             : null,
                              //         borderRadius: BorderRadius.circular(20)),
                              //     child: Center(
                              //         child: Padding(
                              //       padding: const EdgeInsets.only(
                              //           top: 8, bottom: 8),
                              //       child:
                              //           customText("Country", 12, Colors.white),
                              //     )),
                              //   ),
                              // ),
                              // customHeightBox(15),
                              InkWell(
                                onTap: () {
                                  state(() {
                                    selectedBottomIndex = 1;
                                    indexTitle = "Members";
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
                                    child:
                                        customText("Members", 12, Colors.white),
                                  )),
                                ),
                              ),
                              customHeightBox(15),
                              InkWell(
                                onTap: () {
                                  state(() {
                                    selectedBottomIndex = 2;
                                    indexTitle = "Interests";
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
                                    child: customText(
                                        "Interests", 12, Colors.white),
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
                        margin: EdgeInsets.only(left: 15),
                        height: phoneHeight(context) / 2.07,
                        decoration: BoxDecoration(
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
                                                top: 15, left: 10, right: 10),
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
                                          Container(
                                              height:
                                                  phoneHeight(context) / 2.7,
                                              child:
                                                  FutureBuilder<CountryModel>(
                                                future: _getCountries,
                                                builder: (context, snapshot) {
                                                  return snapshot.hasData &&
                                                          snapshot.data != null
                                                      ? ListView.builder(
                                                          itemCount: snapshot
                                                              .data!
                                                              .data!
                                                              .length,
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
                                                                        Icons
                                                                            .flag),
                                                                errorWidget: (context,
                                                                        url,
                                                                        error) =>
                                                                    const Icon(Icons
                                                                        .error),
                                                              ),
                                                              title: customText(
                                                                  snapshot
                                                                      .data!
                                                                      .data![
                                                                          index]
                                                                      .title
                                                                      .toString(),
                                                                  15,
                                                                  white),
                                                              trailing:
                                                                  Checkbox(
                                                                      value: snapshot
                                                                          .data!
                                                                          .data![
                                                                              index]
                                                                          .isSelected,
                                                                      onChanged:
                                                                          (val) {
                                                                        state(
                                                                            () {
                                                                          snapshot
                                                                              .data!
                                                                              .data![index]
                                                                              .isSelected = !snapshot.data!.data![index].isSelected;
                                                                          addRemoveCountriesIds(
                                                                              snapshot.data!.data![index].sId.toString(),
                                                                              snapshot.data!.data![index].isSelected);
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
                                    : selectedBottomIndex == 1
                                        ? Container(
                                            margin: const EdgeInsets.only(
                                                top: 15, left: 10, right: 10),
                                            width: 270,
                                            child: Column(
                                                crossAxisAlignment: cCenter,
                                                children: [
                                                  RangeSlider(
                                                    activeColor: yellowColor,
                                                    inactiveColor: white,
                                                    min: 0,
                                                    max: 500,
                                                    values:
                                                        selectedInterestedRange,
                                                    onChanged:
                                                        (RangeValues newValue) {
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
                                                        const EdgeInsets.only(
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
                                                ]))
                                        : selectedBottomIndex == 2
                                            ? Container(
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
}
