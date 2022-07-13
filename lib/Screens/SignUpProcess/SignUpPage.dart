import 'dart:convert';


import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/Authentication/SignInPage.dart';
import 'package:afro/Screens/Authentication/SignInPage2.dart';
import 'package:afro/Screens/HomeScreens/Home/Contacts/AllContactsScreen.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/SignUpProcess/EmailVerification.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:afro/Util/SharedPreferencfes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
int timeStamp = 0;
//Custom/Common Editext for only text
Widget buildCustomEdittext(
    String text, TextEditingController controller, TextInputType input) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        text,
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 10,
      ),
      Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 50,
        child: TextField(
          controller: controller,
          keyboardType: input,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 14),
              hintText: text,
              hintStyle: TextStyle(color: Colors.white24)),
        ),
      )
    ],
  );
}

//common / custom Edittext for password edittext
Widget buildCustomPasswordWidget(
    String text, TextEditingController controller, TextInputType type) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                  color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
            ]),
        height: 50,
        child: TextField(
          controller: controller,
          keyboardType: type,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(left: 14),
              hintText: text,
              hintStyle: const TextStyle(color: Colors.white24)),
        ),
      )
    ],
  );
}

class _SignUpPage extends State<SignUpPageScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: commonAppbar("Sign Up"),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("background.png"), fit: BoxFit.cover)),
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
                    buildCustomEdittext(
                        "First Name", firstNamecontroller, TextInputType.text),
                    const SizedBox(height: 20),
                    buildCustomEdittext(
                        "Last Name", lastNamecontroller, TextInputType.text),
                    const SizedBox(
                      height: 20,
                    ),
                    buildCustomEdittext(
                        "Email", Emailcontroller, TextInputType.emailAddress),
                    const SizedBox(
                      height: 20,
                    ),
                    buildCustomPasswordWidget(
                        "Create Password",
                        createPasswordController,
                        TextInputType.visiblePassword),
                    const SizedBox(
                      height: 20,
                    ),
                    buildCustomPasswordWidget(
                        "Confirm Password",
                        confirmPasswordController,
                        TextInputType.visiblePassword),
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
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () => {
                                  Navigator.of(context).pop(MaterialPageRoute(
                                      builder: (context) => LoginScreen()))
                                },
                            child: Text(
                              "SIGN IN",
                              style: TextStyle(color: Colors.yellow[300]),
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
                              Navigator.pop(context);
                            },
                            child: customText("Done", 14, circleColor))
                      ],
                    ),
                    customDivider(10, white),
                    customHeightBox(10),
                    Container(
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
                          initialDateTime: DateTime(1980, 1, 1),
                          onDateTimeChanged: (DateTime newDateTime) {
                            setState(() {
                              //hh:mm:ss
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

    if (firstName.isEmpty)
      customToastMsg("Enter the first name");
    else if (lastName.isEmpty)
      customToastMsg("Enter the last name");
    else if (email1.isEmpty)
      customToastMsg("Enter the valid email");
    else if (createPassword.isEmpty)
      customToastMsg("Enter the new password");
    else if (conFirmPassword.isEmpty)
      customToastMsg("Enter the confirm password");
    else if (createPassword != conFirmPassword) {
      customToastMsg("Password dosen't matched!");
    } else if (dateOfBirth.isEmpty) {
      customToastMsg("Please selec the date of birth");
    } else {
      Map<String, dynamic> map = {
        'first_name': firstName,
        'last_name': lastName,
        'email': email1,
        'password': conFirmPassword,
        'dob': "554774709"
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
      Navigator.push(
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
