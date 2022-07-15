import 'package:afro/Model/Group/GroupDetails/GroupPostAllComments/PostCommentDataModel.dart';
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

//Get all comments
Future<GroupPostAllCommentsModel> getGroupCommentsList(
    BuildContext context, String groupPostId,
    {bool progress = true}) async {
  if (progress) {
    showProgressDialogBox(context);
  }

  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;

  var response = await http.get(
      Uri.parse(BASE_URL + "group_post_comments?group_post_id=$groupPostId"),
      headers: {
        'api-key': API_KEY,
        'x-access-token': token,
      });
  print(response.body);
  jsonResponse = json.decode(response.body);
  if (progress) {
    Navigator.pop(context);
  }
  var message = jsonResponse["message"];

  if (response.statusCode == 200) {
    print("Get event comments api success");
    return GroupPostAllCommentsModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

//Get all replies of the comment
//Get all comments
Future<GroupPostAllCommentsModel> getGroupCommentsRepliesList(
    BuildContext context, String groupPostId,
    String parentcommentId,
    {bool progress = true}) async {
  if (progress) {
    showProgressDialogBox(context);
  }

  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;

  var response = await http.get(
      Uri.parse(BASE_URL + "group_post_comments?group_post_id=$groupPostId"),
      headers: {
        'api-key': API_KEY,
        'x-access-token': token,
      });
  print(response.body);
  jsonResponse = json.decode(response.body);
  if (progress) {
    Navigator.pop(context);
  }
  var message = jsonResponse["message"];

  if (response.statusCode == 200) {
    print("Get event comments api success");
    return GroupPostAllCommentsModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}




class GroupPostAllCommentsModel {
  bool? success;
  int? code;
  String? message;
  List<GroupCommentDataModel>? data;
  Metadata? metadata;

  GroupPostAllCommentsModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  GroupPostAllCommentsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <GroupCommentDataModel>[];
      json['data'].forEach((v) {
        data!.add(new GroupCommentDataModel.fromJson(v));
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
