import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:afro/Screens/Authentication/SignInPage2.dart';
import 'package:afro/Screens/HomePageScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/NotificationScreen.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/SelectLanguage.dart';
import 'package:afro/Screens/OnBoardingScreen/FirstOnBoard.dart';
import 'package:afro/Screens/SignUpProcess/FillInformation.dart';
import 'package:afro/Screens/SignUpProcess/SelectInterest.dart';
import 'package:afro/Screens/SignUpProcess/UploadPhotoPage.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreenPage(),
      );
    }));
  }
}
final GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({Key? key}) : super(key: key);

  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreenPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  UserDataConstants data = UserDataConstants();
  late LocalNotificationService _local;
  @override
  void initState() {
    super.initState();
    _local = LocalNotificationService(context: context);
    init();
    checkUserExist(context);
  }

  @override
  Widget build(BuildContext context) {
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

  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    _local.initialize();
    _local.initNotification();
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
                    builder: (context) => SelectIntrest(
                          type: "",
                        ))));
        return;
      }
      if (process.toString() == "interestupdated") {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectLanguageScreenPage(type: ""))));
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
