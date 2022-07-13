import 'dart:convert';

import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<WorkExperience> getAllWorkExpireince(BuildContext context) async {
  showProgressDialogBox(context);
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;
  var response = await http
      .get(Uri.parse(BASE_URL + "experiences?user_id=$userId"), headers: {
    'api-key': API_KEY,
    'x-access-token': token,
  });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    Navigator.pop(context);
    return WorkExperience.fromJson(jsonDecode(response.body));
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

//Delete the education item
Future<void> deleteWorkItem(BuildContext context, String itemId) async {
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  var jsonResponse = null;
  var response =
      await http.delete(Uri.parse(BASE_URL + "experience/${itemId}"), headers: {
    'api-key': API_KEY,
    'x-access-token': token,
  });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    customToastMsg("Item deleted successfully!");
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    Navigator.pop(context);
    customToastMsg(message);
  }
}

class WorkExperience {
  bool? success;
  int? code;
  String? message;
  List<Data>? data;
  Metadata? metadata;

  WorkExperience(
      {this.success, this.code, this.message, this.data, this.metadata});

  WorkExperience.fromJson(Map<String, dynamic> json) {
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
  String? company;
  String? location;
  String? position;
  int? from;
  int? to;
  int? current;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
      this.userId,
      this.company,
      this.location,
      this.position,
      this.from,
      this.to,
      this.current,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    company = json['company'];
    location = json['location'];
    position = json['position'];
    from = json['from'];
    to = json['to'];
    current = json['current'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['company'] = this.company;
    data['location'] = this.location;
    data['position'] = this.position;
    data['from'] = this.from;
    data['to'] = this.to;
    data['current'] = this.current;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
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
