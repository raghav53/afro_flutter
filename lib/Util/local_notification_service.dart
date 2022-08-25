import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:afro/Model/NotificationPojo.dart';
import 'package:afro/Screens/HomeScreens/Home/Contacts/AllContactsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsDetailsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/FourmDetailsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupDetailsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupsAllListScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/Messages/MessageListScreen.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/FollowerFollowing.dart';
import 'package:afro/main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:afro/Screens/HomeScreens/Home/NotificationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalNotificationService {
  BuildContext? context;
  LocalNotificationService({required this.context});
///////////////////////////////// init firebase ////////////////////////////////

  ///Receive message when app is in background solution for on message
  Future<void> backgroundHandler(RemoteMessage message) async {
    debugPrint(
        "LocalNotificationService_backgroundHandler: ${jsonEncode(message.data)}");
    if (Platform.isAndroid) {
      display(message);
    }
  }

  initMainFCM() async {
    if (Platform.isAndroid || Platform.isIOS) {
      Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);
      await Firebase.initializeApp().catchError((e) {
        log(e.toString());
        return e;
      });
    }
  }

///////////////////////////////// close firebase ///////////////////////////////

//////////////////////// init Local Notification Service ///////////////////////

  void initNotification() async {
    initialize();

    ///gives you the message on which user taps and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      debugPrint("notification_getInitialMessage: $message");
      if (message != null) {
        debugPrint("notification_getInitialMessage: ${message.data}");
      }
    });

    ///foreground work
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
          "LocalNotificationService_onMessage_foreground: ${jsonEncode(message.data)}");
      if (Platform.isAndroid) {
        display(message);
      }
    });

    ///When the app is in background but opened and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("notification_onMessageOpenedApp: ${message.data.toString()}");

      //onSelectNotification(message.data.toString());
    });
  }

/////////////////////// close Local Notification Service ///////////////////////

//////////////////////// init Notification Code ///////////////////////

  String channelId = 'AfroUnitd_channelId';
  String channelName = 'AfroUnitd_channelName';

  FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {
              debugPrint(
                  "LocalNotificationService_IOSInitializationSettings: $payload");
            });

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: const AndroidInitializationSettings("@mipmap/app_icon"),
      iOS: initializationSettingsIOS,
    );

    _notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      debugPrint("LocalNotificationService_onSelectNotification: $payload");
      if (payload != null) {
        redirectScreen(payload);
      }
    });
  }

  void display(RemoteMessage message) async {
    print(message.data["body"]);
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

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

      NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: "This is a AfroUnitd channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _notificationsPlugin.show(
        id,
        result["title"].toString(),
        result["message"].toString(),
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } on Exception catch (e) {
      debugPrint("notification_show_error: $e");
    }
  }

  void redirectScreen(String data) {
    debugPrint("LocalNotificationService_data: $data");
    Map<String, dynamic> map = Map();
    map.addAll(jsonDecode(data.toString()));

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
    print(result["title"]);
    var notificationType = result["type"];
    print(notificationType);
    switch (notificationType) {
      case "friend_request":
        Navigator.push(navigatorKey!.currentContext!,
            MaterialPageRoute(builder: (builder) => AllContactsListScreen()));
        break;
      case "event_invite":
        Navigator.push(
            navigatorKey!.currentContext!,
            MaterialPageRoute(
                builder: (builder) => AllEventsScreen(
                      type: "back",
                    )));
        break;
      case "join_group":
        Navigator.push(
            navigatorKey!.currentContext!,
            MaterialPageRoute(
                builder: (context) => GroupDetailsPage(
                      groupAdmin: "",
                      groupId: result["table_id"],
                    )));
        break;
      case "event_interested":
        Navigator.push(
            navigatorKey!.currentContext!,
            MaterialPageRoute(
                builder: (builder) => EventDetailsScreenPage(
                    eventId: result["table_id"], userId: userId)));
        break;
      case "form_reply":
        Navigator.push(
            navigatorKey!.currentContext!,
            MaterialPageRoute(
                builder: (context) => FourmDetailsPage(
                      fourmId: result["table_id"],
                    )));
        break;
      case "Chat":
        Navigator.push(navigatorKey!.currentContext!,
            MaterialPageRoute(builder: (context) => MessageListScreen()));
        break;
      case "follow":
        Navigator.push(navigatorKey!.currentContext!,
            MaterialPageRoute(builder: (builder) => FollowerFollowingPage()));
        break;
      default:
        Navigator.push(navigatorKey!.currentContext!,
            MaterialPageRoute(builder: (builder) => NotificationScreenPage()));
        break;
    }
  }
}
