import 'dart:convert';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/Authentication/SignInPage.dart';
import 'package:afro/Screens/Authentication/SignInPage2.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Util/CustomWidget.dart';

class ForgetPasswordPage extends StatefulWidget {
  _ForgetPassword createState() => _ForgetPassword();
}

class _ForgetPassword extends State<ForgetPasswordPage> {
  TextEditingController Emailcontroller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: commonAppbar("Forget your password"),
        resizeToAvoidBottomInset: false,
        body: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                customHeightBox(30),
                Container(
                  margin: const EdgeInsets.only(top: 80, left: 20),
                  child: Column(
                    children: const [
                      Text(
                        "What's your email\naddress?",
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                customHeightBox(10),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Confirm your email and we'll send the instructions",
                    style: TextStyle(color: Colors.yellow[300]),
                  ),
                ),
                customHeightBox(40),
                Container(
                    margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          "Your Email",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 2))
                              ]),
                          height: 50,
                          child: TextField(
                            controller: Emailcontroller,
                            keyboardType: TextInputType.emailAddress,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white),
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(left: 15),
                                hintText: "hello@gmail.com",
                                hintStyle: TextStyle(color: Colors.white24)),
                          ),
                        )
                      ],
                    )),
                customHeightBox(50),
                InkWell(
                  onTap: () {
                    String email = Emailcontroller.text.trim().toString();
                    if (email.isEmpty) {
                      customToastMsg("Please enter the email!");
                    } else {
                      ForgetPasswordApi(email);
                    }
                  },
                  child: Center(
                    child: Container(
                      margin: EdgeInsets.only(left: 55, right: 55),
                      padding: const EdgeInsets.only(
                          left: 50, right: 50, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        gradient: commonButtonLinearGridient,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisAlignment: mCenter,
                        children: [
                          Icon(
                            Icons.lock,
                            color: white,
                          ),
                          customWidthBox(20),
                          customText("Reset Password", 15, white)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> ForgetPasswordApi(String email) async {
    showProgressDialogBox(context);
    Map data = {'email': email};
    var jsonResponse = null;
    var response = await http.post(Uri.parse(BASE_URL + "forget_password"),
        headers: {'api-key': API_KEY}, body: data);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      customToastMsg(message);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }
}
