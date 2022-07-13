import 'dart:convert';

import 'package:afro/Model/Group/GroupDetails/GroupContacts/JoinedContacts/JoinedContactsDataModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
var user = UserDataConstants();
  //Get the Group Joined members api
  Future<JoinedContactsModel> getJoinedGroupscontacts(
      BuildContext context, String groupId) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String token = sharedPreferences.getString(user.token).toString();
    String userId = sharedPreferences.getString(user.id).toString();
    print(token);
    var jsonResponse = null;
    var response =
        await http.get(Uri.parse(BASE_URL + "group_members?group_id=$groupId"), headers: {
      'api-key': API_KEY,
      'x-access-token': token,
    });
    print(response.body);
    jsonResponse = json.decode(response.body);
    var message = jsonResponse["message"];
    if (response.statusCode == 200) {
      Navigator.pop(context);
      return JoinedContactsModel.fromJson(jsonDecode(response.body));
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
class JoinedContactsModel {
  bool? success;
  int? code;
  String? message;
  List<JoinedContactsDataModel>? data;
  Metadata? metadata;

  JoinedContactsModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  JoinedContactsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <JoinedContactsDataModel>[];
      json['data'].forEach((v) {
        data!.add(new JoinedContactsDataModel.fromJson(v));
      });
    }
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
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

