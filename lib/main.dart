import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:afro/Screens/Authentication/SignInPage2.dart';
import 'package:afro/Screens/HomePageScreen.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/SelectLanguage.dart';
import 'package:afro/Screens/OnBoardingScreen/FirstOnBoard.dart';
import 'package:afro/Screens/OnBoardingScreen/SecondOnBoard.dart';
import 'package:afro/Screens/SignUpProcess/FillInformation.dart';
import 'package:afro/Screens/SignUpProcess/SelectInterest.dart';
import 'package:afro/Screens/SignUpProcess/UploadPhotoPage.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/local_notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'firebase_options.dart';

get getContext => navigatorKey!.currentState?.overlay?.context;

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationService.initMainFCM();
  runApp( const MyApp());
}
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
class MyApp extends StatelessWidget {
   const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: ((context, orientation, deviceType) {
      return MaterialApp(
        title: 'Afro-unitd',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreenPage(),
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
    LocalNotificationService.initNotification();
    init();
    checkUserExist(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Image.asset(
          "splash_screen.png",
          fit: BoxFit.fitWidth,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
        ));
  }

  init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AFRO_2022-HJAKD-56464-V1-34512-SADFA_02",
          appId: "1:4357235401:android:94f0453178d8a615462318",
          messagingSenderId: "4357235401",
          projectId: "afro-united-23c8e"),
    );

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft]);

  }

  Future<void> checkUserExist(BuildContext context) async {
    SharedPreferences sharedPreferences = await _prefs;
    String?checkSocialLogin = sharedPreferences.getString("social login");
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
    }else if (checkSocialLogin=="yes"){
      Timer(
          const Duration(seconds: 3),
              () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePagescreen())));
    }
    else {
      if (onBorading == "yes") {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen())));
      } else {
        Timer(
            const Duration(seconds: 3),
            () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SecondOnBoardScreen())));
      }
    }
  }
}
