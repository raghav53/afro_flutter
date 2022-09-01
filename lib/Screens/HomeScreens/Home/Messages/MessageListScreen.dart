import 'dart:async';

import 'package:afro/Helper/SocketManager.dart';
import 'package:afro/Model/Messages/Inbox/IndividualInboxModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Messages/UserMessageScreen.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/material.dart';

class MessageListScreen extends StatefulWidget {
  const MessageListScreen({Key? key}) : super(key: key);

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

List<String> messagesUserNameList = [
  'Rozy Jospeh',
  'Mitchell Marsh',
  'Anne Marie',
  'Josepeh Stalin'
];
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
UserDataConstants _userData = UserDataConstants();

class _MessageListScreenState extends State<MessageListScreen> {
  SocketManager _socketManager = SocketManager();
  var _userID = "";
  List<IndividualInboxs> chatInboxes = [];
  @override
  void initState() {
    super.initState();
    getUserID();

    Future.delayed(Duration(seconds: 1), () {
      initSocket();
    });
  }

  getUserID() async {
    SharedPreferences _getDataSherdPreferecens = await _prefs;
    _userID = _getDataSherdPreferecens.getString(_userData.id).toString();
    print(_userID);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              customHeightBox(10),
              customText("Message", 20, Colors.white),
              customHeightBox(30),
              search(),
              customHeightBox(20),
              Container(
                child: chatInboxes.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        itemCount: chatInboxes[0].list!.length,
                        itemBuilder: (context, index) {
                          MessagesList model = chatInboxes[0].list![index];
                          var image = model.receiverId!.id.toString() == _userID
                              ? model.senderId!.profileImage.toString()
                              : model.receiverId!.profileImage.toString();
                          return Container(
                            decoration: BoxDecoration(
                                color: gray1,
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (builder) => UserMessagePage(
                                              userID: model.receiverId!.id
                                                          .toString() ==
                                                      _userID
                                                  ? model.senderId!.id
                                                      .toString()
                                                  : "",
                                              name: model.receiverId!.id
                                                          .toString() ==
                                                      _userID
                                                  ? model.senderId!.fullName
                                                      .toString()
                                                  : model.receiverId!.fullName
                                                      .toString(),
                                              senderId: _userID,
                                            ))).then((value) => initSocket());
                              },
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl: IMAGE_URL + image,
                                  imageBuilder: (context, imageProvider) {
                                    return Image(
                                      image: imageProvider,
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              title: Text(
                                model.receiverId!.id.toString() == _userID
                                    ? model.senderId!.fullName.toString()
                                    : model.receiverId!.fullName.toString(),
                                style: TextStyle(
                                    color: white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                model.messageId!.message.toString(),
                                style: const TextStyle(
                                    color: Color(0xff656567), fontSize: 13),
                              ),
                              trailing: Text(
                                getTimeFormat(
                                    model.messageId!.createdAt.toString()),
                                style: TextStyle(color: Color(0xff656567)),
                              ),
                            ),
                          );
                        })
                    : SizedBox(),
              )
            ],
          ),
        ),
      ),
    ));
  }

  // //Message List Item
  // Widget messageListItem(MessagesList model) {
  //   return InkWell(
  //     onTap: () {},
  //     child: Container(
  //       margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
  //       padding:
  //           const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 10),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         color: gray1,
  //       ),
  //       child: Row(children: [
  //         const CircleAvatar(
  //           backgroundImage: AssetImage("tom_cruise.jpeg"),
  //         ),
  //         customWidthBox(10),
  //         Column(
  //           crossAxisAlignment: cStart,
  //           children: [
  //             customText(name, 15, white),
  //             customHeightBox(5),
  //             customText("Hello , how are you?", 13, const Color(0x3DFFFFFF))
  //           ],
  //         ),
  //         const Spacer(),
  //         Column(
  //           children: [
  //             customText("11:45 AM", 14, Color(0x3DFFFFFF)),
  //             customHeightBox(5),
  //             Container(
  //               padding:
  //                   const EdgeInsets.only(top: 3, bottom: 3, right: 7, left: 7),
  //               decoration: BoxDecoration(
  //                   gradient: commonButtonLinearGridient,
  //                   borderRadius: BorderRadius.circular(50)),
  //               child: Center(child: customText("5", 15, white)),
  //             )
  //           ],
  //         )
  //       ]),
  //     ),
  //   );
  // }

  //Custom search options
  Widget search() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      height: 43,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.black),
      child: const TextField(
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 14, color: Colors.white),
        decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              Icons.search,
              color: Color(0xFFDFB48C),
            ),
            hintText: "Search messages",
            contentPadding: EdgeInsets.only(left: 15, top: 10),
            hintStyle: TextStyle(color: Colors.white24)),
      ),
    );
  }

  @override
  void dispose() {
    _socketManager.socket.dispose();
    super.dispose();
  }

  initSocket() async {
    await _socketManager.init(_userID, (event, jsonObject) {
      print('SocketManager: inbox => $event');
      if (event == "notification") {
        try {
          var map = {"user_id": _userID};
          _socketManager.getInbox(map);
        } catch (error) {
          if (error == 400) {
            initSocket();
          }
        }
      }
    });
    _socketManager.addInboxListener((event, p1) {
      setState(() {
        chatInboxes.add(IndividualInboxs.fromJson(p1));
      });
    });
  }
}
