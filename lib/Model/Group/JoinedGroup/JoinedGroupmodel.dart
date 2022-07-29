import 'dart:convert';
import 'package:afro/Model/Group/JoinedGroup/JoinedGroupDataModel.dart';
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

Future<JoinedGroupModel> getAllJoinedGroups(
   {
    
  String search = "",
  bool showProgress = true,
  String page = "1",
  String limit = "500",
}) async {
  // if (showProgress) {
  //   showProgressDialogBox(context);
  // }
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);

  var jsonResponse = null;

  var response = await http.get(
      Uri.parse(
          BASE_URL + "joined_groups?page=$page&limit=$limit&search=$search"),
      headers: {
        'api-key': API_KEY,
        'x-access-token': token,
      });
  print(response.body);
  // if (showProgress) {
  //   Navigator.pop(context);
  // }
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    print("Get All joined groups api success");
    print(jsonResponse["metadata"]["totalDocs"]);
    return JoinedGroupModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    //clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

class JoinedGroupModel {
  bool? success;
  int? code;
  String? message;
  List<JoinedGroupDataModel>? data;
  Metadata? metadata;

  JoinedGroupModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  JoinedGroupModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <JoinedGroupDataModel>[];
      json['data'].forEach((v) {
        data!.add(new JoinedGroupDataModel.fromJson(v));
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
