import 'package:afro/Model/Friends/SendRequest/GetAllSendRequestDataModel..dart';
import 'package:afro/Model/MyProfile/FollowingData.dart';

import 'package:afro/Model/MyProfile/FollowerData.dart';
import 'package:afro/Model/MyProfile/FollowingData.dart';
import 'dart:convert';

import 'package:afro/Model/MyProfile/FollowingModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/OnBoardingScreen/FirstOnBoard.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//Send and Cancel Friend request
Future<void> FriendRequest(
    BuildContext context, int type, String friendId) async {
  print(friendId);
  print(type);
  showProgressDialogBox(context);
  SharedPreferences userData = await _prefs;
  String? token = userData.getString(user.token).toString();
  print(token);
  Map data = {"friend_id": friendId};
  var response = type == 1
      ? await http.delete(Uri.parse(BASE_URL + "friend_request/$friendId"),
          headers: {'api-key': API_KEY, 'x-access-token': token})
      : await http.post(Uri.parse(BASE_URL + "send_friend_request"),
          headers: {'api-key': API_KEY, 'x-access-token': token}, body: data);
  var jsonResponse = json.decode(response.body);
  print(jsonResponse);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    Navigator.pop(context);
    type == 1
        ? print("Friend request successfully deleted....")
        : print("Friend request send successfully...");
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    Navigator.pop(context);
    print(message);
    customToastMsg(message);
  }
}
