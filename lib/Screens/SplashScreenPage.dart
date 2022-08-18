import 'dart:async';

import 'package:afro/Screens/Authentication/SignInPage2.dart';
import 'package:afro/Screens/HomePageScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/NotificationScreen.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/SelectLanguage.dart';
import 'package:afro/Screens/OnBoardingScreen/FirstOnBoard.dart';
import 'package:afro/Screens/SignUpProcess/FillInformation.dart';
import 'package:afro/Screens/SignUpProcess/SelectInterest.dart';
import 'package:afro/Screens/SignUpProcess/UploadPhotoPage.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/SharedPreferencfes.dart';
import 'package:afro/Util/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DashboardScreenPage.dart';

class SplashScreenPage extends StatefulWidget {
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreenPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UserDataConstants data = UserDataConstants();
  @override
  void initState() {
    super.initState();
    init();
    checkUserExist(context);
  }

  init() async {
    await Firebase.initializeApp();
    LocalNotificationService.initialize(context);
    final fcmToken = await FirebaseMessaging.instance.getToken();

    print("FCM_TOKEN-MyApp-$fcmToken");
    SaveStringToSF(data.fcm_token, fcmToken!);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // 1. This method call when app in terminated state and you get a notification
    // when you click on notification app open from terminated state and you can get notification data in this method
    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging- Terminated State");
        if (message != null) {
          print("Terminated_Notification-${message.data['_id']}");
          if (message.data['section'] != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NotificationScreenPage(),
              ),
            );
          }
        }
      },
    );
    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging-Forground State-${message.data}");
        // if (message.notification != null) {
        // print(message.notification!.title);
        //  print(message.notification!.body);
        LocalNotificationService.createanddisplaynotification(message);
        //  }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging-Background State");
        if (message != null) {
          print("message.data11 ${message.data}");
          //LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
  }

  Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    LocalNotificationService.createanddisplaynotification(message);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      child: Image.asset(
        "splash_screen.png",
        fit: BoxFit.fitWidth,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    ));
  }

  Future<void> checkUserExist(BuildContext context) async {
    SharedPreferences sharedPreferences = await _prefs;
    String? checkLogin = sharedPreferences.getString("login");
    String? onBorading = sharedPreferences.getString("onBoarding");
    String? process = sharedPreferences.getString("newuser");
    String? token = sharedPreferences.getString("token");

    if (process.toString().isNotEmpty && process != null) {
      print(process.toString());

      if (process.toString() == "verified") {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => FillInformation(
                          token: token,
                        ))));
        return;
      }
      if (process.toString() == "infofilled") {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => UploadPhotoPage())));
        return;
      }
      if (process.toString() == "profileuploaded") {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SelectIntrest())));
        return;
      }
      if (process.toString() == "interestupdated") {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectLanguageScreenPage())));
        return;
      }
    }
    if (checkLogin == "yes") {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePagescreen())));
    } else {
      if (onBorading == "yes") {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen())));
      } else {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => FirstOnBoardScreen())));
      }
    }
  }
}
