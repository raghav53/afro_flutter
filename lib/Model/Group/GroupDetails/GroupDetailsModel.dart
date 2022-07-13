import 'dart:convert';

import 'package:afro/Model/Events/Discover/DiscoverDataModel.dart';
import 'package:afro/Model/Events/EventDetails/EventDetailDataModel.dart';
import 'package:afro/Model/Group/GroupDetails/GroupDetailsDataModel.dart';
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

Future<GroupDetailsModel> getGroupDetails(BuildContext context, String groupId,
    {bool showProgress = true}) async {
  showProgress == true ? showProgressDialogBox(context) : null;
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;

  var response =
      await http.get(Uri.parse(BASE_URL + "group?group_id=$groupId"), headers: {
    'api-key': API_KEY,
    'x-access-token': token,
  });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    showProgress == true ? Navigator.pop(context) : null;
    print("Get group details api success");
    return GroupDetailsModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    showProgress == true ? Navigator.pop(context) : null;
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

class GroupDetailsModel {
  bool? success;
  int? code;
  String? message;
  GroupDetailsDataModel? data;
  Metadata? metadata;

  GroupDetailsModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  GroupDetailsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null
        ? new GroupDetailsDataModel.fromJson(json['data'])
        : null;
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}
