import 'package:afro/Model/Events/Going/GoingInterestedEventsDataModel.dart';
import 'dart:convert';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:afro/Network/Apis.dart';

import 'package:afro/Util/CommonMethods.dart';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<GoingInterestedEventsModel> getAllGoingInterestedEventsUsers(
    BuildContext context,
    {String search = "",
    String page = "1",
    String limit = "1000",
    String is_online = "",
    bool isShow = true,
    String type = "0"}) async {
  if (isShow) {
    showProgressDialogBox(context);
  }
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;

  var response = await http.get(
      Uri.parse(BASE_URL +
          "going_events?search=$search&page=$page&limit=$limit&type=$type&is_online=$is_online"),
      headers: {
        'api-key': API_KEY,
        'x-access-token': token,
      });
  print(
      "going_events?search=$search&page=$page&limit=$limit&type=$type&is_online=$is_online");
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (isShow) {
    Navigator.pop(context);
  }
  if (response.statusCode == 200) {
    print("Get All Going events api success");
    print(jsonResponse["metadata"]["totalDocs"]);
    return GoingInterestedEventsModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

class GoingInterestedEventsModel {
  bool? success;
  int? code;
  String? message;
  List<GoingInterestedEventUserData>? data;
  GoingEventMetadata? metadata;

  GoingInterestedEventsModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  GoingInterestedEventsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GoingInterestedEventUserData>[];
      json['data'].forEach((v) {
        data!.add(new GoingInterestedEventUserData.fromJson(v));
      });
    }
    metadata = json['metadata'] != null
        ? new GoingEventMetadata.fromJson(json['metadata'])
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
