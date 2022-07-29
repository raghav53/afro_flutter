import 'package:afro/Model/Friends/ReceivedRequest/GetAllReceivedDataModel.dart';
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

Future<ReceivedRequestModel> getAllReceivedContactsRequests(
    BuildContext context,
    {String search = "",
    String page = "1",
    String limit = "500",
    String gender = "",
    String cities = "",
    String min_age = "",
    String max_age = ""}) async {
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;

  var response = await http.get(
      Uri.parse(BASE_URL +
          "received_friend_requests?page=$page&limit=$limit&search=$search&city=$cities&gender=$gender&min_age=$min_age&max_age=$max_age"),
      headers: {
        'api-key': API_KEY,
        'x-access-token': token,
      });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    print("Get Received Requests api success");
    return ReceivedRequestModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

class ReceivedRequestModel {
  bool? success;
  int? code;
  String? message;
  List<ReceivedRequestData>? data;
  ReceivedMetadata? metadata;

  ReceivedRequestModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  ReceivedRequestModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ReceivedRequestData>[];
      json['data'].forEach((v) {
        data!.add(new ReceivedRequestData.fromJson(v));
      });
    }
    metadata = json['metadata'] != null
        ? new ReceivedMetadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}
