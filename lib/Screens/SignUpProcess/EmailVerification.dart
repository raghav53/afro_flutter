import 'dart:convert';

import 'package:afro/Model/SignUpModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/SignUpProcess/FillInformation.dart';
import 'package:afro/Screens/SignUpProcess/SignUpPage.dart';
import 'package:afro/Util/SharedPreferencfes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class EmailVerification extends StatefulWidget {
  Map<String, dynamic> receivedMap;
  String? otpCode;
  String? userEmail;
  EmailVerification(
      {required this.receivedMap,
      required this.otpCode,
      required this.userEmail});

  _Email createState() => _Email();
}

TextEditingController firstCode = TextEditingController();
TextEditingController secondCode = TextEditingController();
TextEditingController thirdCode = TextEditingController();
TextEditingController forthCode = TextEditingController();

SignUpModel? signUpModel;

String? first = "";
String? second = "";
String? third = "";
String? forth = "";

class _Email extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: customText("Email Verification", 20, Colors.white),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 100),
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xff3E55AF)),
                child: Image.asset(
                  "assets/icons/email.png",
                  height: 180,
                  width: 150,
                ),
              ),
              customHeightBox(30),
              const Text(
                "Please enter the 4 digit code sent to",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              customHeightBox(10),
              Text(
                widget.userEmail.toString(),
                style: TextStyle(color: Color(0xFFDFB48C), fontSize: 15),
              ),
              customHeightBox(50),
              //OTP screen
              Container(
                margin: EdgeInsets.only(left: 55, right: 55),
                child: Form(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //First OtpCode
                      SizedBox(
                        height: 68,
                        width: 64,
                        child: TextField(
                          controller: firstCode,
                          onChanged: (value) {
                            first = value.toString();
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "0",
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      //Second OtpCode
                      SizedBox(
                        height: 68,
                        width: 64,
                        child: TextField(
                          controller: secondCode,
                          onChanged: (value) {
                            second = value.toString();
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            } else if (value.length == 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "1",
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      //Third OtpCode
                      SizedBox(
                        height: 68,
                        width: 64,
                        child: TextField(
                          controller: thirdCode,
                          onChanged: (value) {
                            third = value.toString();
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            } else if (value.length == 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "2",
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                      //Fourth OtpCode
                      SizedBox(
                        height: 68,
                        width: 64,
                        child: TextField(
                          controller: forthCode,
                          onChanged: (value) {
                            forth = value.toString();
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            } else if (value.length == 0) {
                              FocusScope.of(context).previousFocus();
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: "3",
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 1.0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(1),
                            FilteringTextInputFormatter.digitsOnly
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                  onPressed: () => {resendOtp()},
                  child: const Text(
                    "Resend Code",
                    style: TextStyle(
                      color: Color(0xFFDFB48C),
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                    ),
                  )),
              customHeightBox(50),
              //Verify Button
              InkWell(
                onTap: () {
                  String? fullOtp = first.toString() +
                      second.toString() +
                      third.toString() +
                      forth.toString();
                  if (widget.otpCode == fullOtp) {
                    signUptheUser();
                  } else {
                    customToastMsg("Please enter the otp!");
                  }
                },
                child: Container(
                    alignment: Alignment.center,
                    height: 40.0,
                    width: 200,
                    decoration: BoxDecoration(
                        gradient: commonButtonLinearGridient,
                        borderRadius: BorderRadius.circular(50)),
                    child: customText("Verify Email", 15, white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signUptheUser() async {
    var _userData = UserDataConstants();
    widget.receivedMap.addAll({
      'device_token': "hjgadswfhjg",
      'device_type': "Android",
      'social_type': "APP"
    });
    showProgressDialogBox(context);
    var jsonResponse = null;
    var response = await http.post(Uri.parse(BASE_URL + "signup"),
        headers: {'api-key': API_KEY}, body: widget.receivedMap);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      signUpModel = SignUpModel.fromJson(jsonResponse);
      SaveStringToSF("token", signUpModel!.data!.token!);
      SaveStringToSF(_userData.id, signUpModel!.data!.id!);
      SaveStringToSF("newuser", "verified");

      print(
          "User Token:-${signUpModel!.data!.token!} , User Id :- ${signUpModel!.data!.id!}");
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  FillInformation(token: signUpModel!.data!.token!)));
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }

  Future<void> resendOtp() async {
    showProgressDialogBox(context);
    Map data = {'email': widget.userEmail};
    var jsonResponse = null;
    var response = await http.post(Uri.parse(BASE_URL + "check_email"),
        headers: {'api-key': API_KEY}, body: data);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      customToastMsg("Otp sent successfully..");
      widget.otpCode = jsonResponse["data"]["code"];
      print(widget.otpCode);
      customToastMsg(jsonResponse["data"]["code"]);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }
}
