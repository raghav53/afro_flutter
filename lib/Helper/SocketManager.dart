import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketManager {
  String CONNECT_SOCKET_METHOD = "connect_socket"; //done
  String CONNECT_USER_LISTENER = "notification"; //Done
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

  Future<void> init(
      String id, Function(String event, dynamic)? jsonObject) async {
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
        if (jsonObject != null) {
          jsonObject("notification", data);
        }
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
      print('SocketManager: inbox_messages => $messages');
      if (jsonArray != null) jsonArray(INDIVIDUAL_INBOX_LISTENER, messages);
    });
  }

  Future<void> getIndividiualchat(Map data) async {
    print(data);
    if (socket.connected) {
      socket.emit(INDIVIDUAL_CHAT_METHOD, data);
    } else {
      throw 400;
    }
  }

  Future<void> addIndividualChatListener(
      Function(String event, dynamic)? jsonArray) async {
    socket.on(INDIVIDUAL_CHAT_LISTENER, (messages) {
      print('SocketManager: Individual Chats => $messages');
      if (jsonArray != null) jsonArray(INDIVIDUAL_CHAT_LISTENER, messages);
    });
  }

  Future<void> sendMessgae(Map data) async {
    if (socket.connected) {
      socket.emit(SEND_METHOD, data);
    } else {
      throw 400;
    }
  }

  Future<void> getMessage(Function(String event, dynamic)? jsonArray) async {
    socket.on(GET_MESSAGE_LISTENER, (messages) {
      print(messages);
      if (jsonArray != null) jsonArray(GET_MESSAGE_LISTENER, messages);
    });
  }
}
