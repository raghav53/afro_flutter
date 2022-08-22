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

      String map2 = map["body"];

      List<String> str = map2
          .replaceAll("{", "")
          .replaceAll("}", "")
          .replaceAll("\"", "")
          .replaceAll("'", "")
          .split(",");
      Map<String, dynamic> result = {};
      for (int i = 0; i < str.length; i++) {
        List<String> s = str[i].split(":");
        result.putIfAbsent(s[0].trim(), () => s[1].trim());
      }

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
        result["title"].toString(),
        result["message"].toString(),
        notificationDetails,
        payload: message.data['section'],
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
