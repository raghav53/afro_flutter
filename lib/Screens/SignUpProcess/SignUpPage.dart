import 'dart:convert';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/Authentication/SignInPage2.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/SignUpProcess/EmailVerification.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SignUpPageScreen extends StatefulWidget {
  _SignUpPage createState() => _SignUpPage();
}

// Text Editing controllers
TextEditingController firstNamecontroller = new TextEditingController();
TextEditingController lastNamecontroller = new TextEditingController();
TextEditingController Emailcontroller = new TextEditingController();
TextEditingController createPasswordController = new TextEditingController();
TextEditingController confirmPasswordController = new TextEditingController();

String dateOfBirth = "";
String? timeStamp = "";

class _SignUpPage extends State<SignUpPageScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: commonAppbar("Sign Up"),
      body: Container(
        height: phoneHeight(context),
        width: phoneWidth(context),
        padding: EdgeInsets.only(top: 50),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("background.png"), fit: BoxFit.cover)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  crossAxisAlignment: cStart,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Center(
                      child: Image.asset(
                        'screen_logo.png',
                        height: 50,
                        width: 250,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    basicInformation(),
                    const SizedBox(
                      height: 20,
                    ),

                    customHeightBox(20),
                    customText("Date Of Birth", 16, white),
                    customHeightBox(10),
                    //Date Picker
                    InkWell(
                      onTap: () {
                        openBottomSheet(context);
                      },
                      child: Container(
                        width: 500,
                        padding: const EdgeInsets.only(
                            top: 12, bottom: 12, left: 15, right: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: black),
                        child: Row(
                          children: [
                            customText(dateOfBirth, 15,
                                dateOfBirth.isEmpty ? gray1 : white),
                            Spacer(),
                            Icon(
                              Icons.arrow_drop_down_outlined,
                              color: gray1,
                            )
                          ],
                        ),
                      ),
                    ),
                    customHeightBox(30),
                    Center(child: signUpButton(context)),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () => {
                                  Navigator.of(context).pop(MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()))
                                },
                            child: Text(
                              "SIGN IN",
                              style: TextStyle(color: yellowColor),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  //Basic Informations
  basicInformation() {
    return Column(
      children: [
        //First Name edittext
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "First Name",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            customHeightBox(10),
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
                controller: firstNamecontroller,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 14),
                    hintText: "Enter Your First Name",
                    hintStyle: const TextStyle(color: Colors.white24)),
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        //Last Name Edittext
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Last Name",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            customHeightBox(10),
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
                controller: lastNamecontroller,
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 14),
                    hintText: "Enter Your Last Name",
                    hintStyle: TextStyle(color: Colors.white24)),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        //Email edittext
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              "Email",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            customHeightBox(10),
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
                keyboardType: TextInputType.text,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 14),
                    hintText: "Enter Your Email",
                    hintStyle: TextStyle(color: Colors.white24)),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        //Create new password
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText("Create Password", 16, white, bold: "yes"),
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
                controller: createPasswordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 14),
                    hintText: "Enter Your  Password",
                    hintStyle: TextStyle(color: Colors.white24)),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        //Confirm new password
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customText("Confirm Password", 16, white, bold: "yes"),
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
                controller: confirmPasswordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 14),
                    hintText: "Enter Your Confirm Password",
                    hintStyle: TextStyle(color: Colors.white24)),
              ),
            )
          ],
        ),
      ],
    );
  }

  void openBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
                height: 300,
                margin: EdgeInsets.only(top: 30),
                decoration: commonBoxDecoration(),
                child: Column(
                  crossAxisAlignment: cCenter,
                  children: [
                    Row(
                      mainAxisAlignment: mCenter,
                      crossAxisAlignment: cCenter,
                      children: [
                        Spacer(),
                        Spacer(),
                        customText("Pick Date", 15, white),
                        Spacer(),
                        customWidthBox(25),
                        TextButton(
                            onPressed: () {
                              if (timeStamp.toString().isEmpty) {
                                customToastMsg("Please Select Your dob!");
                                return;
                              }
                              Navigator.pop(context);
                            },
                            child: customText("Done", 14, circleColor))
                      ],
                    ),
                    customDivider(10, white),
                    customHeightBox(10),
                    SizedBox(
                      height: 200,
                      child: CupertinoTheme(
                        data: const CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          dateOrder: DatePickerDateOrder.dmy,
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime(1990, 01, 1),
                          maximumDate: DateTime.now(),
                          onDateTimeChanged: (DateTime newDateTime) {
                            setState(() {
                              //hh:mm:ss
                              final timestamp1 =
                                  newDateTime.millisecondsSinceEpoch;
                              timeStamp = timestamp1.toString();
                              print("DOb TimeStamp :- " + timeStamp.toString());
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(newDateTime);
                              dateOfBirth = formattedDate;
                              print(formattedDate);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ));
          });
        });
  }

  Widget signUpButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Map? map = checkValues();
        if (map != null) {
          checkEmail();
        }
      },
      child: Container(
          width: 200,
          decoration: BoxDecoration(
              gradient: commonButtonLinearGridient,
              borderRadius: BorderRadius.circular(30)),
          height: 40.0,
          child: Center(
            child: customText("Sign Up ", 15, white),
          )),
    );
  }

  Map? checkValues() {
    String firstName = firstNamecontroller.text.toString();
    String lastName = lastNamecontroller.text.toString();
    String email1 = Emailcontroller.text.toString();
    String createPassword = createPasswordController.text.toString();
    String conFirmPassword = confirmPasswordController.text.toString();

    if (firstName.isEmpty) {
      customToastMsg("Enter the first name");
    } else if (lastName.isEmpty)
      customToastMsg("Enter the last name");
    else if (!isEmailValid(email1))
      customToastMsg("Email address not valid!");
    else if (email1.isEmpty)
      customToastMsg("Please enter the email address!");
    else if (createPassword.isEmpty)
      customToastMsg("Enter the new password");
    else if (conFirmPassword.isEmpty)
      customToastMsg("Enter the confirm password");
    else if (createPassword != conFirmPassword) {
      customToastMsg("Password dosen't matched!");
    } else if (timeStamp.toString().isEmpty) {
      customToastMsg("Please select the date of birth");
    } else {
      Map<String, dynamic> map = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email1,
        'password': conFirmPassword,
        'dob': timeStamp
      };
      return map;
    }
    return null;
  }

  Future<void> checkEmail() async {
    showProgressDialogBox(context);
    String emailApi = Emailcontroller.text.trim().toString();
    Map data = {'email': emailApi};
    var jsonResponse = null;
    var response = await http.post(Uri.parse(BASE_URL + "check_email"),
        headers: {'api-key': API_KEY}, body: data);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      customToastMsg(jsonResponse["data"]["code"]);
      Navigator.pop(context);
      Map<String, dynamic>? map = checkValues()!.cast<String, dynamic>();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => EmailVerification(
                    receivedMap: map,
                    otpCode: jsonResponse["data"]["code"],
                    userEmail: emailApi,
                  )));
    } else {
      Navigator.pop(context);
      customToastMsg(message);
    }
  }
}
