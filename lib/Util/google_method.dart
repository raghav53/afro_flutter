import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';


import '../Model/AllInterestsModel.dart';
import '../Model/LoginModel.dart';
import 'package:http/http.dart' as http;

import '../Network/Apis.dart';
import '../Screens/HomePageScreen.dart';
import 'CommonUI.dart';
import 'SharedPreferencfes.dart';

GoogleSignIn _googleSignIn = GoogleSignIn();
final plugin = FacebookLogin(debug: true);

var fcmToken = "";
LoginModel? loginModel;

void googleSignInProcess(BuildContext context) async {
  if (await _googleSignIn.isSignedIn()) {
    handleSignOut();
  }

  GoogleSignInAccount? googleUser;
  GoogleSignInAuthentication googleSignInAuthentication;
  try {
    googleUser = (await _googleSignIn.signIn());
    if (googleUser != null) {
      googleSignInAuthentication = await googleUser.authentication;
      print(googleSignInAuthentication.accessToken);
    }
  } catch (error) {
    print(error);
  }

  if (await _googleSignIn.isSignedIn()) {
    print(googleUser?.email);
    print(googleUser?.displayName);
    print(googleUser?.photoUrl);
    print(googleUser?.id);
    var firstName = googleUser?.displayName!.split(' ')[0];
    var lastName = googleUser?.displayName!.split(' ')[1];
    var deviceToken = "";
    FirebaseMessaging _firebaseMessaging =
        FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token) {
      deviceToken = token.toString();
      debugPrint("token is $deviceToken");
    });
    debugPrint('FIRST_NAME__' + firstName! + '___LASTNAME___' + lastName!);
    apiLoginGoogle(context, googleUser!.id, firstName, lastName,
        googleUser.email, deviceToken, 'Android', 'GOOGLE');
  }
}

Future<void> handleSignOut() => _googleSignIn.disconnect();

Future<LoginModel?> apiLoginGoogle(

  BuildContext context,
  String socialId,
  String firstName,
  String lastName,
  String email,
  String deviceToken,
  String deviceType,
  String socialType,
) async {
  var jsonResponse = null;
  showProgressDialogBox(context);
  var response = await http.post(
    Uri.parse(BASE_URL + 'social_login'),
    headers: {'api-key': API_KEY},
    body: {
      'social_id': socialId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'device_type': deviceType,
      'device_token': deviceToken,
      'social_type': socialType,
    },
  );

  print(response.body);
  jsonResponse = json.decode(response.body);
  var loginModel = LoginModel.fromJson(jsonResponse);
  print(jsonResponse);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    Navigator.pop(context);
    customToastMsg(message);
    saveTheUserInfo(loginModel);
    // saveUserData(loginModel);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(
          builder: (context) => const HomePagescreen(),
        ))
        .then((value) => () {
              init();
            });
    return loginModel;
  } else if (response.statusCode == 401) {
    Navigator.pop(context);
    customToastMsg(message);
  } else {
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

//Firebase notification
init() async {
  FirebaseMessaging.instance.getToken().then((value) {
    String? token = value;
    print(
        "_______________________________________________1" + token.toString());
  });
  fcmToken = (await FirebaseMessaging.instance.getToken())!;
  print("_______________________________________________" + fcmToken);
}

saveTheUserInfo(LoginModel loginModel) async {
  await SaveStringToSF(user.firstName, loginModel.data!.firstName.toString());
  await SaveStringToSF(user.lastName, loginModel.data!.lastName.toString());
  await SaveStringToSF(user.fullName, loginModel.data!.fullName.toString());
  await SaveStringToSF(user.useremail, loginModel.data!.email.toString());
  await SaveStringToSF(user.userdob, loginModel.data!.dob.toString());
  await SaveStringToSF(
      user.profileImage, loginModel.data!.profileImage.toString());
  await SaveStringToSF(user.gender, loginModel.data!.gender.toString());
  await SaveStringToSF(user.locale, loginModel.data!.locale.toString());
  await SaveStringToSF(user.token, loginModel.data!.token.toString());
  await SaveStringToSF(user.deviceType, loginModel.data!.deviceType.toString());
  await SaveStringToSF(
      user.deviceToken, loginModel.data!.deviceToken.toString());
  await SaveStringToSF(user.socialType, loginModel.data!.socialType.toString());
  await SaveStringToSF(user.bio, loginModel.data!.bio.toString());
  await SaveStringToSF(user.facebook, loginModel.data!.facebook.toString());
  await SaveStringToSF(user.instagram, loginModel.data!.instagram.toString());
  await SaveStringToSF(user.twitter, loginModel.data!.twitter.toString());
  await SaveStringToSF(user.linkdin, loginModel.data!.linkdin.toString());
  await SaveStringToSF(user.city, loginModel.data!.city.toString());
  await SaveStringToSF(user.state, loginModel.data!.state.toString());
/*  await SaveStringToSF(
      user.community, loginModel.data!.community!.title.toString());*/
  await SaveStringToSF(user.socketId, loginModel.data!.socketId.toString());
  await SaveStringToSF(user.id, loginModel.data!.id.toString());
}

Future<dynamic> faceBookLogin(BuildContext context) async {
  _logOut();
  await plugin.logIn(permissions: [
    FacebookPermission.email,FacebookPermission.publicProfile,
  ]);
  final fbToken = await plugin.accessToken;
  FacebookUserProfile? profile;
  String? email;
  String? imageUrl;
  debugPrint('TOEKN___' + fbToken.toString());
  var deviceToken = "";
 await FirebaseMessaging.instance.getToken().then((token) {
    deviceToken = token.toString();
    debugPrint("token is $deviceToken");
  });

  if (fbToken != null) {
    profile = await plugin.getUserProfile();
    if (fbToken.permissions.contains(FacebookPermission.email.name)) {
       email = await plugin.getUserEmail();
    }
    imageUrl = await plugin.getProfileImageUrl(width: 100);
      apiLoginGoogle(context,profile!.userId,profile.firstName.toString(),profile.lastName.toString(),email.toString(),deviceToken,"Android","FACEBOOK");
  }
}

Future<void> _logOut() async {
  await plugin.logOut();
}
