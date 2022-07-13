import 'dart:convert';

import 'package:afro/Model/Friends/ReceivedRequest/GetAllReceivedRequest.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReceivedFriendRequest extends StatefulWidget {
  const ReceivedFriendRequest({Key? key}) : super(key: key);

  @override
  State<ReceivedFriendRequest> createState() => _ReceivedFriendRequestState();
}

String searchUser = "";
Future<ReceivedRequestModel>? _getAllContactsRequests;
var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class _ReceivedFriendRequestState extends State<ReceivedFriendRequest> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getAllContactsRequests = getAllContactsRequests(context);
      setState(() {});
      _getAllContactsRequests!.whenComplete(() => () {});
    });
  }

  //Search Friend request list

  Future<ReceivedRequestModel> _getSearchCountriesList(String search) async {
    ReceivedRequestModel mm = await _getAllContactsRequests!;
    var ss = mm.toJson();
    ReceivedRequestModel model = ReceivedRequestModel.fromJson(ss);

    if (search.isEmpty) {
      return model;
    }

    int i = 0;
    while (i < model.data!.length) {
      if (!model.data![i].friend!.fullName
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase())) {
        model.data!.removeAt(i);
      } else {
        i++;
      }
    }
    return model;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReceivedRequestModel>(
        future: _getSearchCountriesList(searchUser),
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.data!.isNotEmpty
              ? Column(
                  children: [
                    customHeightBox(20),
                    //Search box of the friends
                    Row(
                      mainAxisAlignment: mCenter,
                      children: [
                        Flexible(
                            flex: 12,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(0, 2))
                                  ]),
                              child: TextField(
                                onChanged: (value) => {
                                  setState(() {
                                    searchUser = value.toString();
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
                                    hintStyle:
                                        TextStyle(color: Colors.white24)),
                              ),
                            )),
                      ],
                    ),
                    customHeightBox(20),

                    RefreshIndicator(
                      onRefresh: _refreshList,
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: snapshot.data!.data!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(children: [
                              Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
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
                                                    snapshot.data!.data![index]
                                                        .friend!.profileImage
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
                                          margin: const EdgeInsets.only(
                                              right: 3, bottom: 3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient:
                                                  commonButtonLinearGridient),
                                        )
                                      ],
                                    ),
                                    customWidthBox(10),
                                    Column(
                                      crossAxisAlignment: cStart,
                                      children: [
                                        customText(
                                            snapshot.data!.data![index].friend!
                                                .fullName
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
                                                snapshot.data!.data![index]
                                                    .friend!.city![0].name
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
                                                snapshot.data!.data![index]
                                                    .friend!.sId
                                                    .toString(),
                                                snapshot.data!.data![index]
                                                    .friend!.fullName
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
                                                snapshot.data!.data![index]
                                                    .friend!.sId
                                                    .toString(),
                                                snapshot.data!.data![index]
                                                    .friend!.fullName
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
                    ),
                  ],
                )
              : Center(
                  child: customText("Not Data found", 15, white),
                );
        });
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
                              ? acceptRejectFriendRequest(context, "0", fId)
                              : acceptRejectFriendRequest(context, "1", fId);
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

  Future<void> _refreshList() async {
    getListOfReceivedFriendRequest();
  }

  getListOfReceivedFriendRequest() {
    Future.delayed(Duration.zero, () {
      _getAllContactsRequests = getAllContactsRequests(context);
      setState(() {});
      _getAllContactsRequests!.whenComplete(() => () {});
    });
  }

  Future<void> acceptRejectFriendRequest(
      BuildContext context, String type, String friendId) async {
    showProgressDialogBox(context);
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
      getListOfReceivedFriendRequest();
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }
}
