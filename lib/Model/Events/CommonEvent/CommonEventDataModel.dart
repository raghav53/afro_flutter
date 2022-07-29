import 'dart:convert';

import 'package:afro/Model/Events/CommonEvent/CommonEventModel.dart';
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

Future<CommonEventsModel> getAllEventsUsers(BuildContext context,
    {String search = "",
    bool showProgress = true,
    String page = "1",
    String limit = "500",
    String minGoing = "0",
    String maxGoing = "500",
    String minInterested = "0",
    String maxInterested = "500",
    String countryIds = "",
    String isLink = ""}) async {
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;
  print("=============================================================" +
      countryIds);
  var response = await http.get(
      Uri.parse(BASE_URL +
          "events?page=$page&limit=$limit&search=$search&guests_max=$maxGoing&guests_min=$minGoing&interested_max=$maxInterested&interested_min=$minInterested&country=$countryIds&is_online=$isLink"),
      headers: {
        'api-key': API_KEY,
        'x-access-token': token,
      });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    print("Get All events api success");
    print(jsonResponse["metadata"]["totalDocs"]);
    return CommonEventsModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

class CommonEventsModel {
  bool? success;
  int? code;
  String? message;
  List<CommonEventsDataModel>? data;
  DisCoverMetadata? metadata;

  CommonEventsModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  CommonEventsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CommonEventsDataModel>[];
      json['data'].forEach((v) {
        data!.add(new CommonEventsDataModel.fromJson(v));
      });
    }
    metadata = json['metadata'] != null
        ? new DisCoverMetadata.fromJson(json['metadata'])
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
