
//Get all user interest List
import 'dart:convert';

import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<UserInterestModel> getUserInterestsList(BuildContext context,
    {bool isShow = true}) async {
  // if (isShow) {
  //   showProgressDialogBox(context);
  // }
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();

  print(token);
  var jsonResponse = null;
  var response = await http.get(
    Uri.parse(BASE_URL + "user_interests"),
    headers: {'api-key': API_KEY, 'x-access-token': token},
  );
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  // if (isShow) {
  //   Navigator.pop(context);
  // }
  if (response.statusCode == 200) {
    print("Get user interests list Api success!");
    return UserInterestModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}


class UserInterestModel {
  bool? success;
  int? code;
  String? message;
  List<Data>? data;
  Metadata? metadata;

  UserInterestModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  UserInterestModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? sId;
  String? userId;
  String? interestId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Interest? interest;

  Data(
      {this.sId,
      this.userId,
      this.interestId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.interest});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    interestId = json['interest_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    interest = json['interest'] != null
        ? new Interest.fromJson(json['interest'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['interest_id'] = this.interestId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.interest != null) {
      data['interest'] = this.interest!.toJson();
    }
    return data;
  }
}

class Interest {
  String? sId;
  String? title;
  int? popularity;

  Interest({this.sId, this.title, this.popularity});

  Interest.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    popularity = json['popularity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['popularity'] = this.popularity;
    return data;
  }
}

class Metadata {
  Metadata();

  Metadata.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
