import 'dart:convert';
import 'dart:io';
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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
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
  var mediaFile = null;
  var mime = "";
  FocusNode focusNode = FocusNode();
  List<IndividualChatMessage> chatMessages = [];
  List<ChatList> _singleChatItem = [];
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
                                child: _singleChatItem.isNotEmpty
                                    ? Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: _singleChatItem.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                margin: EdgeInsets.only(
                                                    bottom:
                                                        _singleChatItem.length -
                                                                    1 ==
                                                                index
                                                            ? 70
                                                            : 0),
                                                child: chatMessageItem(
                                                    _singleChatItem[index]),
                                              );
                                            }),
                                      )
                                    : const SizedBox())
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Visibility(
                    visible: mediaFile != null ? true : false,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: phoneWidth(context) / 2,
                            child: mime.split("/")[0] == "image"
                                ? Image.file(
                                    mediaFile,
                                    height: 150,
                                    fit: BoxFit.fill,
                                  )
                                : const Icon(Icons.play_arrow),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          InkWell(
                            onTap: () {
                              sendMediaMessage();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 11, 128, 223),
                                  borderRadius: BorderRadius.circular(50)),
                              child: const Icon(Icons.send),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    )),
                Visibility(
                  visible: mediaFile != null ? false : true,
                  child: Container(
                    padding:
                        const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Color(0xFF37364D),
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            showImageVideoBox();
                          },
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
                            style: const TextStyle(color: Colors.white),
                            focusNode: focusNode,
                            controller: msgController,
                            onChanged: (v) {
                              setState(() {
                                msg = v.toString();
                              });
                            },
                            decoration: const InputDecoration(
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            if (msg.isEmpty && mediaFile == null) {
                              showInSnackBar("Write your msg..", context);
                              return;
                            }
                            sendTextMessage();
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
                ),
              ],
            ),
          )
        : const SizedBox();
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
    var readMessage = {"user_id": widget.userID};
    _socketManager.getIndividiualchat(map);
    _socketManager.readAllMessages(readMessage);
    _socketManager.addIndividualChatListener(
      (event, p1) {
        chatMessages.add(IndividualChatMessage.fromJson(p1));
        for (var i = 0; i < chatMessages[0].list!.length; i++) {
          if (mounted) {
            setState(() {
              _singleChatItem.add(chatMessages[0].list![i]);
            });
          }
        }
      },
    );
    _socketManager.getMessage((event, p1) => {
          if (mounted)
            {
              setState(() {
                _singleChatItem.add(ChatList.fromJson(p1));
              })
            }
        });
  }

  sendTextMessage() {
    var msgData = {
      "receiver_id": widget.userID.toString(),
      "message": msg.toString(),
      "media": "",
      "media_type": "0",
      "type": "0"
    };
    _socketManager.sendMessgae(msgData);
    msgController.clear();
    focusNode.unfocus();
    focusNode.canRequestFocus = false;
  }

  sendMediaMessage() {
    var mediaType = mime.split("/");
    print(mediaType[0]);
    var msgData = {
      "receiver_id": widget.userID.toString(),
      "message": "",
      "media": mediaFile,
      "media_type": mediaType[0],
      "type": "1"
    };
    _socketManager.sendMessgae(msgData);
    print(msgData);
    setState(() {
      mime = "";
      mediaFile = null;
    });
  }

  chatMessageItem(ChatList model) {
    return Align(
        alignment: widget.senderId == model.senderId
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: model.media.toString() != "0"
              ? Column(
                  crossAxisAlignment: widget.senderId == model.senderId
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: gray1),
                        child: customText(model.message.toString(), 15, white),
                      ),
                    ),
                    customHeightBox(5),
                    customText(getTimeFormat(model.createdAt.toString()), 13,
                        Colors.white54),
                    customHeightBox(5)
                  ],
                )
              : Container(
                  height: 100,
                  width: phoneWidth(context) / 2.2,
                  child: CachedNetworkImage(
                    imageUrl: IMAGE_URL + model.media.toString(),
                    placeholder: (context, url) => const CircleAvatar(
                        backgroundImage: AssetImage("tom_cruise.jpeg")),
                    errorWidget: (context, url, jgf) {
                      return Image.asset("tom_cruise.jpeg");
                    },
                    imageBuilder: (context, image) => CircleAvatar(
                      backgroundImage: image,
                    ),
                  ),
                ),
        ));
  }

  //Show Send Image And Video dialog box
  showImageVideoBox() {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (builder, state) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 235, 235, 235),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showSourTypeBox("1");
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text("Pick Image"),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showSourTypeBox("2");
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text("Pick Video"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  showSourTypeBox(String type) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (builder, state) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 235, 235, 235),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () {
                        if (type == "1") {
                          Navigator.pop(context);
                          pickImage(ImageSource.camera);
                        } else if (type == "2") {
                          Navigator.pop(context);
                          pickVideo(ImageSource.camera);
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text("Camera"),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () {
                        if (type == "1") {
                          Navigator.pop(context);
                          pickImage(ImageSource.gallery);
                        } else if (type == "2") {
                          Navigator.pop(context);
                          pickVideo(ImageSource.gallery);
                        }
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text("Gallery"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        mediaFile = File(image.path);
        mime = lookupMimeType(image.name).toString();
        print(mime);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickVideo(ImageSource source) async {
    try {
      final video = await ImagePicker().pickVideo(source: source);
      if (video == null) return;
      final videoTemp = File(video.path);

      print(videoTemp);
      setState(() {
        mediaFile = File(video.path);
        mime = lookupMimeType(video.name).toString();
        print(mime);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  open(String type, String subType) {
    if (type.contains("photo")) {
      if (subType.contains("camera")) {
        pickImage(ImageSource.camera);
      } else if (subType.contains("gallery")) {
        pickImage(ImageSource.gallery);
      }
    } else if (type.contains("video")) {
      if (subType.contains("camera")) {
        pickVideo(ImageSource.camera);
      } else if (subType.contains("gallery")) {
        pickVideo(ImageSource.camera);
      }
    }
  }
}
