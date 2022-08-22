import 'dart:convert';

import 'dart:math';

import 'package:afro/Model/LoginModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/Authentication/ChooseLanguage.dart';
import 'package:afro/Screens/Authentication/ForgetPasswordPage.dart';

import 'package:afro/Screens/HomePageScreen.dart';

import 'package:afro/Screens/SignUpProcess/SignUpPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:afro/Util/SharedPreferencfes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../../Util/CommonUI.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var user = UserDataConstants();
  TextEditingController Emailcontroller = new TextEditingController();
  TextEditingController PasswordController = new TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  LoginModel? loginModel;

  bool _checkbox = false;
  var fcmToken = "";
  UserDataConstants userDataConstants = UserDataConstants();
  @override
  void initState() {
    super.initState();
    init();
  }

  late bool _isLoading;
  bool? _isConnected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          // height: height,
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  color: Colors.white,
                                  fontFamily: "Sans",
                                  // fontWeight: FontWeight.w600,
                                  fontSize: 18.0),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Image.asset(
                        'screen_logo.png',
                        height: 100,
                        width: 300,
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      const Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Enter your email",
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  color: Colors.white,
                                  fontFamily: "Sans",
                                  // fontWeight: FontWeight.w600,
                                  fontSize: 14.0),
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        cursorColor: Colors.white,
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: Emailcontroller,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 16.0, height: 0.8, color: Colors.white),
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Colors.black26,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.white54),
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Enter your password",
                              style: TextStyle(
                                  letterSpacing: 0.5,
                                  color: Colors.white,
                                  fontFamily: "Sans",
                                  // fontWeight: FontWeight.w600,
                                  fontSize: 14.0),
                            ),
                          )),
                      const SizedBox(height: 10),
                      TextField(
                        onChanged: (value) {
                          setState(() {});
                        },
                        controller: PasswordController,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontSize: 16.0, height: 0.8, color: Colors.white),
                        decoration: const InputDecoration(
                            filled: true,
                            fillColor: Colors.black26,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            hintText: "Enter your password",
                            hintStyle: TextStyle(color: Colors.white54)),
                      ),
                      const SizedBox(height: 5),
                      ListTile(
                        leading: Checkbox(
                            value: _checkbox,
                            checkColor: Colors.white,
                            activeColor: Colors.purple,
                            onChanged: (value) {
                              setState(() {
                                _checkbox = !_checkbox;
                              });
                            }),
                        title: InkWell(
                          onTap: () {
                            setState(() {
                              _checkbox = !_checkbox;
                            });
                          },
                          child: const Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        trailing: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ForgetPasswordPage()));
                            },
                            child: customText(
                                "Forgot your password?", 13, yellowColor)),
                      ),
                      const SizedBox(height: 50),
                      InkWell(
                        onTap: () {
                          loginWithEmailPassword();
                        },
                        child: Container(
                          height: 45,
                          width: 280,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: commonButtonLinearGridient),
                          child: Center(
                            child: customText("Login", 16, white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text(
                            'New around Here?',
                            style: TextStyle(color: Colors.white),
                          ),
                          customWidthBox(5),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SignUpPageScreen()));
                              },
                              child: customText(
                                  "SIGN UP", 15, const Color(0xffDFB48C)))
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      customHeightBox(15),
                      Row(
                        children: [
                          const Text(
                            'Choose Your',
                            style: TextStyle(color: Colors.white),
                          ),
                          customWidthBox(5),
                          InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChooseLanguage()));
                              },
                              child: customText(
                                  "languages", 15, Color(0xffDFB48C))),
                          customWidthBox(3),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                            color: Color(0xffDFB48C),
                          )
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: phoneWidth(context) / 0.2,
                        child: Row(
                          crossAxisAlignment: cCenter,
                          mainAxisAlignment: mCenter,
                          children: [
                            SizedBox(
                              width: phoneWidth(context) / 3,
                              child: customDivider(10, white),
                            ),
                            customWidthBox(10),
                            customText("or", 13, white),
                            customWidthBox(10),
                            SizedBox(
                              width: phoneWidth(context) / 3,
                              child: customDivider(10, white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: cCenter,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              height: 40,
                              decoration: BoxDecoration(
                                gradient: commonButtonLinearGridient,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.facebook,
                                    color: white,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  customText("Facebook", 15, white)
                                ],
                              ),
                            ),
                          ),
                          customWidthBox(30),
                          InkWell(
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(color: white, width: 1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.gpp_good,
                                    color: white,
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    'GOGGLE',
                                    style: TextStyle(color: white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                    ],
                  ),
                ),
                customHeightBox(50)
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Firebase notification
  init() async {
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;
      print("_______________________________________________1" +
          token.toString());
    });
    fcmToken = (await FirebaseMessaging.instance.getToken())!;
    print("_______________________________________________" + fcmToken);
  }

  void loginWithEmailPassword() {
    String email = Emailcontroller.text.trim().toString();
    String password = PasswordController.text.trim().toString();

    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the email!");
    } else if (password.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter the password!");
    } else {
      login(email, password);
    }
  }

  Future<void> login(String email, String password) async {
    SharedPreferences sharedPreferences = await _prefs;
    showProgressDialogBox(context);
    Map data = {
      'email': email,
      'password': password,
      'timezone': "Asia/Kolkata",
      'device_token': fcmToken,
      'device_type': "Android",
      'social_type': "APP"
    };
    var jsonResponse = null;
    var response = await http.post(Uri.parse(BASE_URL + "login"),
        headers: {'api-key': API_KEY}, body: data);
    jsonResponse = json.decode(response.body);

    loginModel = LoginModel.fromJson(jsonResponse);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      if (_checkbox) {
        await SaveStringToSF("remember", "yes");
        await SaveStringToSF("email", email);
        await SaveStringToSF("password", password);
      } else {
        sharedPreferences.remove("remember");
        sharedPreferences.remove("email");
        sharedPreferences.remove("password");
      }
      await SaveStringToSF("login", "yes");
      SaveTheUserInfo();
      Navigator.pop(context);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(
            builder: (context) => HomePagescreen(),
          ))
          .then((value) => () {
                init();
              });
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }

  void getSavedInfo() {
    String? remember = GetSaveStringValue("remember");
    String? email = GetSaveStringValue("email");
    String? password = GetSaveStringValue("password");
    if (remember == "yes") {
      Emailcontroller.value = email as TextEditingValue;
      PasswordController.value = password as TextEditingValue;
    }
  }

  SaveTheUserInfo() async {
    await SaveStringToSF(
        user.firstName, loginModel!.data!.firstName.toString());
    await SaveStringToSF(user.lastName, loginModel!.data!.lastName.toString());
    await SaveStringToSF(user.fullName, loginModel!.data!.fullName.toString());
    await SaveStringToSF(user.useremail, loginModel!.data!.email.toString());
    await SaveStringToSF(user.userdob, loginModel!.data!.dob.toString());
    await SaveStringToSF(
        user.profileImage, loginModel!.data!.profileImage.toString());
    await SaveStringToSF(user.gender, loginModel!.data!.gender.toString());
    await SaveStringToSF(user.locale, loginModel!.data!.locale.toString());
    await SaveStringToSF(user.token, loginModel!.data!.token.toString());
    await SaveStringToSF(
        user.deviceType, loginModel!.data!.deviceType.toString());
    await SaveStringToSF(
        user.deviceToken, loginModel!.data!.deviceToken.toString());
    await SaveStringToSF(
        user.socialType, loginModel!.data!.socialType.toString());
    await SaveStringToSF(user.bio, loginModel!.data!.bio.toString());
    await SaveStringToSF(user.facebook, loginModel!.data!.facebook.toString());
    await SaveStringToSF(
        user.instagram, loginModel!.data!.instagram.toString());
    await SaveStringToSF(user.twitter, loginModel!.data!.twitter.toString());
    await SaveStringToSF(user.linkdin, loginModel!.data!.linkdin.toString());
    await SaveStringToSF(user.city, loginModel!.data!.city.toString());
    await SaveStringToSF(user.state, loginModel!.data!.state.toString());
    await SaveStringToSF(
        user.community, loginModel!.data!.community!.title.toString());
    await SaveStringToSF(user.socketId, loginModel!.data!.socketId.toString());
    await SaveStringToSF(user.id, loginModel!.data!.id.toString());
  }
}

String generateTheTokenString() {
  var r = Random();
  const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(20, (index) => _chars[r.nextInt(_chars.length)]).join();
}
