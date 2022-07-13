import 'dart:convert';

import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/Authentication/SignInPage.dart';
import 'package:afro/Screens/Authentication/SignInPage2.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Util/CustomWidget.dart';

class ForgetPasswordPage extends StatefulWidget {
  _ForgetPassword createState() => _ForgetPassword();
}

TextEditingController Emailcontroller = new TextEditingController();


Widget BuildEmailTextField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        "Your Email",
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      const SizedBox(
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
          controller: Emailcontroller,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: 14, color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 15),
              // suffixIcon: Icon(
              //   Icons.email,
              //   color: Colors.yellow,
              // ),
              hintText: "hello@gmail.com",
              hintStyle: TextStyle(color: Colors.white24)),
        ),
      )
    ],
  );
}

class _ForgetPassword extends State<ForgetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () => {
                            Navigator.of(context).pop(MaterialPageRoute(
                                builder: (context) => SignPage()))
                          },
                      icon: Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 6,
                  ),
                  Text(
                    "Forget your password",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 80, left: 20),
                child: Column(
                  children: [
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
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Confirm your email and we'll send the instructions",
                  style: TextStyle(color: Colors.yellow[300]),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                  margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: BuildEmailTextField()),
             customHeightBox(50),
            InkWell(
              onTap: (){
                 String email=Emailcontroller.text.trim().toString();
                 if(email.isEmpty){
                   customToastMsg("Please enter the email!");
                 }else{
                   ForgetPasswordApi(email);
                 }
              },
              child:   Center(
                child: Container(
                  width: phoneWidth(context)/1.5,
                  padding: EdgeInsets.only(left: 50,right: 50,top: 10,bottom: 10),
                  decoration: BoxDecoration(
                    gradient: commonButtonLinearGridient,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    crossAxisAlignment: cCenter,
                    mainAxisAlignment: mCenter,
                    children: [
                      Icon(Icons.lock,color: white,),
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
    );
  }

  Future<void> ForgetPasswordApi(String email) async  {
    showProgressDialogBox(context);
    Map data={'email':email};
    var jsonResponse = null;
    var response = await http.post(
        Uri.parse(BASE_URL+"forget_password"),
        headers: {'api-key': API_KEY},
        body: data);
    jsonResponse = json.decode(response.body);
    var message=jsonResponse["message"];
    if(response.statusCode==200){
      Navigator.pop(context);
      customToastMsg(message);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
    }else{
      Navigator.pop(context);
      customToastMsg(message);
    }
  }
}
