import 'dart:convert';

import 'package:afro/Helper/ReportOperation.dart';
import 'package:afro/Helper/SocketManager.dart';
import 'package:afro/Model/Messages/Chat/IndividualChatModel.dart';
import 'package:afro/Model/UserProfileModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserMessagePage extends StatefulWidget {
  String? userID = "", name = "", senderId = "";

  UserMessagePage({Key? key, this.name, this.userID, required this.senderId})
      : super(key: key);
  @override
  State<UserMessagePage> createState() => _UserMessagePageState();
}

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

UserDataConstants _userDataConstants = UserDataConstants();

Future<UserProfile>? __getMessageUserProfile;

class _UserMessagePageState extends State<UserMessagePage> {
  SocketManager _socketManager = SocketManager();
  FocusNode focusNode = FocusNode();
  List<IndividualChatMessage> chatMessages = [];
  TextEditingController msgController = TextEditingController();
  String msg = "";
  ScrollController _scrollController = new ScrollController();
  @override
  void initState() {
    super.initState();
    initSocket();
    Future.delayed(Duration(seconds: 1), () {
      if (_socketManager.socket.connected) {
        getUsersChat();
      } else {
        initSocket();
      }
    });
    Future.delayed(Duration.zero, () {
      __getMessageUserProfile =
          getOtherUserProfileinfo(context, widget.userID.toString());
      setState(() {});
      __getMessageUserProfile!.whenComplete(() => () {});
    });
  }

  //Update User data
  updateUserDataInformation() {
    Future.delayed(Duration.zero, () {
      __getMessageUserProfile =
          getOtherUserProfileinfo(context, widget.userID.toString());
      setState(() {});
      __getMessageUserProfile!.whenComplete(() => () {});
    });
  }

  @override
  void dispose() {
    _socketManager.socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: FutureBuilder<UserProfile>(
            future: __getMessageUserProfile,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          children: [
                            customAppbar(snapshot.data!),
                            Container(
                                child: chatMessages.isNotEmpty
                                    ? Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                chatMessages[0].list!.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: EdgeInsets.only(
                                                    bottom: chatMessages[0]
                                                                    .list!
                                                                    .length -
                                                                1 ==
                                                            index
                                                        ? 70
                                                        : 0),
                                                child: chatMessageItem(
                                                    chatMessages[0]
                                                        .list![index]
                                                        .message
                                                        .toString(),
                                                    chatMessages[0]
                                                        .list![index]
                                                        .senderId
                                                        .toString(),
                                                    chatMessages[0]
                                                        .list![index]
                                                        .receiverId
                                                        .toString(),
                                                    chatMessages[0]
                                                        .list![index]
                                                        .createdAt
                                                        .toString()),
                                              );
                                            }),
                                      )
                                    : SizedBox())
                          ],
                        ),
                        Align(child: userBlockOrNot(snapshot.data!)),
                      ],
                    )
                  : simpleAppbar();
            }),
      )),
    );
  }

  //Block and Unblock the User
  Future<void> blockAndUnblockUser(String type) async {
    print(type);
    showProgressDialogBox(context);
    SharedPreferences userData = await _prefs;
    String? token = userData.getString(_userDataConstants.token).toString();
    print(token);
    Map data = {"user_id": widget.userID, "type": type};

    var response = await http.post(Uri.parse(BASE_URL + "block_chat"),
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

  //Simple Appbar
  Widget simpleAppbar() {
    return AppBar(
      centerTitle: true,
      elevation: 0.0,
      title: customText(widget.name.toString(), 20, white),
      backgroundColor: Colors.transparent,
    );
  }

  //Appbar with options
  Widget customAppbar(UserProfile model) {
    return AppBar(
      centerTitle: true,
      elevation: 0.0,
      title: customText(widget.name.toString(), 20, white),
      backgroundColor: Colors.transparent,
      actions: [
        InkWell(
          child: PopupMenuButton(
              elevation: 0.0,
              color: Colors.transparent,
              // add icon, by default "3 dot" icon
              // icon: Icon(Icons.book)
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                    height: 12,
                    padding: EdgeInsets.all(10),
                    value: 0,
                    child: Row(
                      children: [
                        Icon(
                          Icons.block,
                          color: white,
                          size: 20,
                        ),
                        customWidthBox(5),
                        customText(
                            model.data!.isBlock == true ? "Unblock" : "Block",
                            12,
                            white)
                      ],
                    ),
                  ),
                  PopupMenuItem<int>(
                    height: 12,
                    value: 1,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        customWidthBox(2),
                        Image.asset(
                          "assets/icons/mail_star.png",
                          color: white,
                          height: 17,
                          width: 17,
                        ),
                        customWidthBox(5),
                        customText("Report", 12, white)
                      ],
                    ),
                  ),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  model.data!.isBlock == true
                      ? blockAndUnblockUser("Unblock")
                      : blockAndUnblockUser("Block");
                } else if (value == 1) {
                  showReportDialogBox(
                      "User", model.data!.sId.toString(), context);
                }
              }),
        )
      ],
    );
  }

  //Check user is block or not
  Widget userBlockOrNot(UserProfile model) {
    return model.data!.isBlock != true
        ? Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Color(0xFF37364D),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        border: Border.all(color: white, width: 1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      focusNode: focusNode,
                      controller: msgController,
                      onChanged: (v) {
                        setState(() {
                          msg = v.toString();
                        });
                      },
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      if (msg.isEmpty) {
                        showInSnackBar("Write your msg..", context);
                        return;
                      }
                      sendMessage();
                    },
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          )
        : SizedBox();
  }

  initSocket() async {
    await _socketManager.init(widget.senderId.toString(), (event, jsonObject) {
      print('SocketManager: inbox => $event');
      if (event == "notification") {
        try {} catch (error) {
          if (error == 400) {
            initSocket();
          }
        }
      }
    });
  }

  getUsersChat() {
    var map = {"user_id": widget.userID, "page": "1", "limit": "100"};
    _socketManager.getIndividiualchat(map);
    _socketManager.addIndividualChatListener(
      (event, p1) {
        setState(() {
          chatMessages.add(IndividualChatMessage.fromJson(p1));
        });
      },
    );
  }

  sendMessage() {
    var msgData = {
      "receiver_id": widget.userID.toString(),
      "message": msg.toString(),
      "media": "0",
      "media_type": "0",
      "type": "0"
    };
    print(msgData);
    _socketManager.sendMessgae(msgData);
    _socketManager.getMessage(
      (event, p1) => {
        
      },
    );

    getUsersChat();
    msgController.clear();
    focusNode.unfocus();
    focusNode.canRequestFocus = false;
  }

  chatMessageItem(String msg, String senderId, String recevierId, String time) {
    return Align(
      alignment: widget.senderId == senderId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Column(
          crossAxisAlignment: widget.senderId == senderId
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5), color: gray1),
              child: customText(msg, 15, white),
            ),
            customHeightBox(5),
            customText(
                getTimeFormat(time), 13, Color.fromARGB(255, 49, 49, 49)),
            customHeightBox(5)
          ],
        ),
      ),
    );
  }
}
