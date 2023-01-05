import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:afro/Model/NotificationPojo.dart';
import 'package:afro/Model/push_notification_model.dart';
import 'package:afro/Screens/HomePageScreen.dart';
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
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:afro/Screens/HomeScreens/Home/NotificationScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/NotificationModel.dart';
import '../Screens/Tabs/FollowerTab.dart';
import '../Screens/Tabs/FollowingTab.dart';
class LocalNotificationService {
///////////////////////////////// init firebase ////////////////////////////////

  ///Receive message when app is in background solution for on message
  static Future<void> backgroundHandler(RemoteMessage message) async {
    debugPrint(
        "LocalNotificationService_backgroundHandler: ${jsonEncode(message.data)}");
    if (Platform.isAndroid) {
      // LocalNotificationService.display(message);
    }
  }

  static initMainFCM() async {
    if (Platform.isAndroid || Platform.isIOS) {
      Firebase.initializeApp().then((value) {
        // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
      });
      FirebaseMessaging.onBackgroundMessage(backgroundHandler);
      await Firebase.initializeApp().catchError((e) {
        log(e.toString());
        return e;
      });
    }
  }

///////////////////////////////// close firebase ///////////////////////////////

//////////////////////// init Local Notification Service ///////////////////////

  static void initNotification() async {
    LocalNotificationService.initialize();

    ///gives you the message on which user taps and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        debugPrint("notification_getInitialMessage: ${message.data}");
        redirectScreen(message.data);
      }
    });

    ///foreground work
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
          "LocalNotificationService_onMessage_foreground: ${jsonEncode(message.data)}");
      if (Platform.isAndroid) {
        LocalNotificationService.display(message);
      }
    });

    ///When the app is in background but opened and user taps on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("notification_onMessageOpenedApp: ${message.data}");

      LocalNotificationService.redirectScreen(message.data);;
    });
  }

/////////////////////// close Local Notification Service ///////////////////////

//////////////////////// init Notification Code ///////////////////////

  static const channelId = 'AfroUnitd_channelId';
  static const channelName = 'AfroUnitd_channelName';

  static final FlutterLocalNotificationsPlugin notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    notificationsPlugin
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
      android: const AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: initializationSettingsIOS,
    );

    notificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
          debugPrint("LocalNotificationService_onSelectNotification: $payload");
          if (payload != null) {
            redirectScreen(jsonDecode(payload));
          }
        });
  }

  static void display(RemoteMessage message) async {
    PushNotificationModel notificationModel = PushNotificationModel.fromJson(jsonDecode(message.data["body"]));
    debugPrint('Message__ff${(notificationModel.data!.message==null)?notificationModel.message:notificationModel.data!.message}');
    try {
      int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: "this is Afro united channel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await notificationsPlugin.show(
        id,
        notificationModel.title,
        (notificationModel.data!.message==null)?notificationModel.message:notificationModel.data!.message,
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } on Exception catch (e) {
      debugPrint("notification_show_error: $e");
    }
  }

  static void redirectScreen(Map<String, dynamic> data) async {
    PushNotificationModel notificationModel = PushNotificationModel.fromJson(jsonDecode(data["body"]));
    debugPrint("LocalNotificationService_data: $data.");
    String? type = notificationModel.data!.type;
    debugPrint("LocalNotificationService_data_type: $type");
    if(type=="Chat"){
      Navigator.pushReplacement(
          getContext,
          MaterialPageRoute(
              builder: (context) => const MessageListScreen()));
    } else if(type=="follow"){
      navigatorKey!.currentState!.push(MaterialPageRoute(builder: (context) => const FollowerFollowingPage(selectedIndex: 1,)));


    } else if (type == "friend_request"){
      Navigator.pushReplacement(getContext, MaterialPageRoute(builder: (context)=> AllContactsListScreen(selectedIndex: 1 ,)));
    }else if (type == "join_group"){
      Navigator.pushReplacement(getContext, MaterialPageRoute(builder: (context)=>
          GroupDetailsPage(groupId: notificationModel.data!.tableId.toString(), groupAdmin: '',)));

    }else if (type == "event_invite"){
      Navigator.pushReplacement(getContext, MaterialPageRoute(builder: (context)=> AllEventsScreen(selectedIndex:  3,)));
    }else if (type == "event_interested"){
      Navigator.pushReplacement(getContext, MaterialPageRoute(builder: (context)=> AllEventsScreen(selectedIndex:  2,)));
    }else if (type == "form_reply"){
      Navigator.pushReplacement(getContext, MaterialPageRoute(builder: (context)=> FourmDetailsPage(fourmId: notificationModel.data!.tableId.toString(),)));
    }else{
      Navigator.pushReplacement(getContext, MaterialPageRoute(builder: (context)=>const NotificationScreenPage()));
    }


    }
/*  static redirectScreen(String data) {
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
            MaterialPageRoute(builder: (context) => const MessageListScreen()));
        break;
      case "follow":
        Navigator.push(navigatorKey!.currentContext!,
            MaterialPageRoute(builder: (builder) => const FollowerFollowingPage()));
        break;
      default:
        Navigator.push(navigatorKey!.currentContext!,
            MaterialPageRoute(builder: (builder) => const NotificationScreenPage()));
        break;
    }
  }*/

  /*static void redirectScreen(Map<String, dynamic> data) async {
    debugPrint("LocalNotificationService_data: $data");
    String section = data['section'];
    debugPrint("SECTION: $section");
    if (section == "1") {
      Navigator.pushReplacement(
          getContext,
          MaterialPageRoute(
              builder: (context) => const ApprovedRequestScreen()));
    }
  }*/
}

/*class LocalNotificationService {
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
      android: const AndroidInitializationSettings("@drawable/ic_launcher"),
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
    print('display_RemoteMessage'+message.data["body"]);
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
}*/
