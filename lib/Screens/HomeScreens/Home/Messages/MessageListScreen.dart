import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class _MessageListScreenState extends State<MessageListScreen> {
  late final IO.Socket _socket;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _socket = IO.io(
      "http://3.230.218.97:5001",
      IO.OptionBuilder().setTransports(['websocket']).setQuery({
        "transports": ["websocket"],
        "autoConnect": true,
      }).build(),
    );
    _connectSocket();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              customHeightBox(10),
              customText("Message", 20, Colors.white),
              customHeightBox(30),
              search(),
              customHeightBox(20),
              customDivider(5, Colors.white),
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: messagesUserNameList.length,
                  itemBuilder: (context, index) {
                    return messageListItem(messagesUserNameList[index]);
                  })
            ],
          ),
        ),
      ),
    ));
  }

  //Message List Item
  Widget messageListItem(String name) {
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        padding:
            const EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: gray1,
        ),
        child: Row(children: [
          const CircleAvatar(
            backgroundImage: AssetImage("tom_cruise.jpeg"),
          ),
          customWidthBox(10),
          Column(
            crossAxisAlignment: cStart,
            children: [
              customText(name, 15, white),
              customHeightBox(5),
              customText("Hello , how are you?", 13, const Color(0x3DFFFFFF))
            ],
          ),
          const Spacer(),
          Column(
            children: [
              customText("11:45 AM", 14, Color(0x3DFFFFFF)),
              customHeightBox(5),
              Container(
                padding:
                    const EdgeInsets.only(top: 3, bottom: 3, right: 7, left: 7),
                decoration: BoxDecoration(
                    gradient: commonButtonLinearGridient,
                    borderRadius: BorderRadius.circular(50)),
                child: Center(child: customText("5", 15, white)),
              )
            ],
          )
        ]),
      ),
    );
  }

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

  _connectSocket() {
    _socket.onConnect((data) => print('Connection established'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
    _socket.onDisconnect((data) => print('Socket.IO server disconnected'));
  }
}
