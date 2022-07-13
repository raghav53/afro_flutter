import 'package:afro/Screens/Authentication/ChooseLanguage.dart';
import 'package:afro/Screens/Authentication/ForgetPasswordPage.dart';
import 'package:afro/Screens/DashboardScreenPage.dart';
import 'package:afro/Screens/HomePageScreen.dart';
import 'package:afro/Screens/SignUpProcess/SignUpPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignPage extends StatefulWidget {
  _SignInPageScreen createState() => _SignInPageScreen();
}

Widget BuildEmailTextField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      const Text(
        "Email/ User Name",
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
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: 14, color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14, left: 15),
              suffixIcon: Icon(
                Icons.email,
                color: Colors.yellow,
              ),
              hintText: "Email/ User Name",
              hintStyle: TextStyle(color: Colors.white24)),
        ),
      )
    ],
  );
}

//Password
Widget BuildPasswordTextField() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        "Password",
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
      ),
      SizedBox(
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
          obscureText: true,
          style: const TextStyle(fontSize: 14, color: Colors.white),
          decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14, left: 15),
              suffixIcon: Icon(
                Icons.lock,
                color: Colors.yellow,
              ),
              hintText: "Password",
              hintStyle: TextStyle(color: Colors.white24)),
        ),
      )
    ],
  );
}

class _SignInPageScreen extends State<SignPage> {
  bool isChecked = false;
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF18182C),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                SizedBox(
                  height: 40,
                ),
                Center(
                  child: Image.asset(
                    'screen_logo.png',
                    height: 50,
                    width: 250,
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 80, right: 20, left: 20),
                    child: BuildEmailTextField()),
                Container(
                    margin: EdgeInsets.only(top: 20, right: 20, left: 20),
                    child: BuildPasswordTextField()),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: Color(0xFF7822A0),
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      Text(
                        "Remember me",
                        style: TextStyle(color: Colors.white24),
                      ),
                      SizedBox(
                        width: 80,
                      ),
                      TextButton(
                          onPressed: () => {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ForgetPasswordPage()))
                              },
                          child: Text(
                            "Forget your password?",
                            style: TextStyle(color: Colors.yellow[300]),
                          ))
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 40),
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => HomePagescreen()));
                      },
                      child: Padding(
                          padding: EdgeInsets.only(right: 30, left: 30),
                          child: Text('Sign In')),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF7822A0),
                        shape: StadiumBorder(),
                      ),
                    )),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: 150,
                        child: Divider(
                          height: 8,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Text("Or"),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                        width: 150,
                        child: Divider(
                          height: 8,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                //Connects with the social media
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //facebook
                    ClipOval(
                      child: Material(
                        color: Color(0xFF7822A0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () => {},
                            child: Image.asset(
                              "assets/social/facebook.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ClipOval(
                      child: Material(
                        color: Color(0xFF7822A0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () => {},
                            child: Image.asset(
                              "assets/social/google.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ClipOval(
                      child: Material(
                        color: Color(0xFF7822A0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () => {},
                            child: Image.asset(
                              "assets/social/instagram.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                //Don't have a account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "New account here?",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SignUpPageScreen()))
                            },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.yellow[300]),
                        ))
                  ],
                )

                //Choose the language
                ,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Choose your",
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () => {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ChooseLanguage()))
                            },
                        child: Text(
                          "language  >",
                          style: TextStyle(color: Colors.yellow[300]),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
