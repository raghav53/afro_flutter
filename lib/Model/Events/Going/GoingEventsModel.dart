import 'package:afro/Model/Events/Going/GoingEventsDataModel.dart';
import 'dart:convert';

import 'package:afro/Model/Events/Discover/DiscoverDataModel.dart';
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

Future<GoingEventsModel> getAllGoingEventsUsers(
    BuildContext context, String page, String limit) async {
  showProgressDialogBox(context);
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;

  var response = await http.get(
      Uri.parse(BASE_URL + "going_events?page=$page&limit=$limit&type=0"),
      headers: {
        'api-key': API_KEY,
        'x-access-token': token,
      });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    Navigator.pop(context);
    print("Get All Going events api success");
    print(jsonResponse["metadata"]["totalDocs"]);
    return GoingEventsModel.fromJson(jsonDecode(response.body));
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

class GoingEventsModel {
  bool? success;
  int? code;
  String? message;
  List<GoingEventUserData>? data;
  GoingEventMetadata? metadata;

  GoingEventsModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  GoingEventsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GoingEventUserData>[];
      json['data'].forEach((v) {
        data!.add(new GoingEventUserData.fromJson(v));
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
