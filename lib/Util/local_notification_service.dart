import 'dart:convert';

import 'package:afro/Model/NotificationPojo.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize(BuildContext context) async {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/app_icon"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String? id) async {
        print("onSelectNotification-$id");
      },
    );
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    
    try {
      print(message.data["body"]);

      Map<String, dynamic> map = Map();
      map.addAll(message.data);

      print("__________________________________________Encode    " + map["body"].toString());


 String map2 = map["body"];

      print("__________________________________________Encode@@@@@@@@    " + map2.toString());
      // var result = jsonEncode(message.data);
      // String data = result.toString();
      // print("__________________________________________Encode    " + data);
      // var decodeData = jsonDecode(result);
      // print(
      //     "-----------------------------Decode       " + decodeData.toString());
      // NotificationPojo pojo = NotificationPojo.fromJson(decodeData);
      // // print("-----------------------------2  " +pojo.title.toString());
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "afro",
          "pushnotificationappchannel",
          icon: "@mipmap/app_icon",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        "AfroUnitd",
        message.data['message'],
        notificationDetails,
        payload: message.data['section'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
