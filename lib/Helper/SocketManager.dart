import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  String CONNECT_SOCKET_METHOD = "connect_socket";
  String CONNECT_USER_LISTENER = "notification";
  String ONLINE_STATUS = "online_status";

  String SEND_METHOD = "send_message";
  String GET_MESSAGE_LISTENER = "get_message";

  String INDIVIDUAL_INBOX_METHOD = "individual_inboxs";
  String INDIVIDUAL_INBOX_LISTENER = "get_individual_inboxs";

  String INDIVIDUAL_CHAT_METHOD = "individual_chat";
  String INDIVIDUAL_CHAT_LISTENER = "get_individual_chat";

  String READ_MESSAGE = "read_messages";

  IO.Socket? _socket;

  late IO.Socket socket;

  Future<void> init(String id, var jsonObject) async {
    socket = IO.io(
        "http://3.230.218.97:5001",
        IO.OptionBuilder()
            .setTransports(['websocket']) // for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            .build());
    socket.connect();

    socket.onConnect((_) {
      if (socket.connected) {
        print("Connected");
      }
      var map = {'user_id': id};
      //connect user connection
      socket.emit("$CONNECT_SOCKET_METHOD", map);
    });

    //connect listener user
    socket.on(
      "notification",
      (data) {
        if (jsonObject != null) print(data);
        //jsonObject("connect_listener", data);
      },
    );

    socket.onConnecting((data) {
      debugPrint('SocketManager: Connecting,   $data');
    });

    socket.onDisconnect((_) {
      debugPrint('SocketManager: Disconnected');
    });
  }

  Future<void> getInbox(Map inbox) async {
    print(inbox);
    if (socket.connected) {
      print('SocketManager: inbox => $inbox');
      socket.emit(INDIVIDUAL_INBOX_METHOD, inbox);
    } else {
      throw 400;
    }
  }

  Future<void> addInboxListener(
      Function(String event, dynamic)? jsonArray) async {
    socket.on(INDIVIDUAL_INBOX_LISTENER, (messages) {
      if (jsonArray != null) jsonArray(INDIVIDUAL_INBOX_LISTENER, jsonArray);
    });
  }
}
