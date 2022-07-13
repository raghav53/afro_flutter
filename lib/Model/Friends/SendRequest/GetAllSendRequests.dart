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

Future<SendRequestModel> getAllSendRequests(BuildContext context) async {
  showProgressDialogBox(context);
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;

  var response =
      await http.get(Uri.parse(BASE_URL + "sent_friend_requests"), headers: {
    'api-key': API_KEY,
    'x-access-token': token,
  });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    Navigator.pop(context);
    print("Get Send Requests api success");
    return SendRequestModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    Navigator.pop(context);
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

class SendRequestModel {
  bool? success;
  int? code;
  String? message;
  List<SendRequestData>? data;

  SendRequestModel({this.success, this.code, this.message, this.data});

  SendRequestModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <SendRequestData>[];
      json['data'].forEach((v) {
        data!.add(new SendRequestData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
