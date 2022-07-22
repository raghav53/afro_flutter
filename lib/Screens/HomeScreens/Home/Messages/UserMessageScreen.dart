import 'dart:convert';

import 'package:afro/Helper/ReportOperation.dart';
import 'package:afro/Model/ChatMessage.dart';
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
  String? userID = "", name = "";
  UserMessagePage({Key? key, this.name, this.userID}) : super(key: key);
  @override
  State<UserMessagePage> createState() => _UserMessagePageState();
}

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
List<ChatMessage> messages = [
  ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
  ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
  ChatMessage(
      messageContent: "Hey Kriss, I am doing fine dude. wbu?",
      messageType: "sender"),
  ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
  ChatMessage(
      messageContent: "Is there any thing wrong?", messageType: "sender"),
];
UserDataConstants _userDataConstants = UserDataConstants();

Future<UserProfile>? __getMessageUserProfile;

class _UserMessagePageState extends State<UserMessagePage> {
  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
        future: __getMessageUserProfile,
        builder: (context, snapshot) {
          return SafeArea(
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
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
                                      snapshot.data!.data!.isBlock == true
                                          ? "Unblock"
                                          : "Block",
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
                            snapshot.data!.data!.isBlock == true
                                ? blockAndUnblockUser("Unblock")
                                : blockAndUnblockUser("Block");
                          } else if (value == 1) {
                            showReportDialogBox("User",
                                snapshot.data!.data!.sId.toString(), context);
                          }
                        }),
                  )
                ],
              ),
              body: Container(
                height: phoneHeight(context),
                width: phoneHeight(context),
                decoration: commonBoxDecoration(),
                padding: const EdgeInsets.only(top: 60),
                child: Stack(
                  children: <Widget>[
                    //Enter text Edittext
                    Container(
                        child: snapshot.data!.data!.isBlock == false
                            ? Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10, top: 10),
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
                                            border: Border.all(
                                                color: white, width: 1),
                                            borderRadius:
                                                BorderRadius.circular(30),
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
                                      const Expanded(
                                        child: TextField(
                                          decoration: InputDecoration(
                                              hintText: "Write message...",
                                              hintStyle: TextStyle(
                                                  color: Colors.black54),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      FloatingActionButton(
                                        onPressed: () {},
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
                            : null),

                    //User Messages
                    SingleChildScrollView(
                      child: ListView.builder(
                        itemCount: messages.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 5, bottom: 5),
                            child: Align(
                              alignment:
                                  (messages[index].messageType == "receiver"
                                      ? Alignment.topLeft
                                      : Alignment.topRight),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      messages[index].messageType == "receiver"
                                          ? const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10))
                                          : const BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                  color:
                                      (messages[index].messageType == "receiver"
                                          ? gray1
                                          : black),
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  messages[index].messageContent,
                                  style: TextStyle(fontSize: 12, color: white),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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
}
