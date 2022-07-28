import 'package:afro/Model/Events/EventMedia/EventMediaDataModel.dart';
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

Future<EventMediaModel> getMediaFiles(
    BuildContext context, String eventId, String type) async {
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;

  var response = await http.get(
      Uri.parse(BASE_URL + "event_media?event_id=$eventId&type=$type"),
      headers: {
        'api-key': API_KEY,
        'x-access-token': token,
      });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    print("Get event media api success");
    return EventMediaModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

class EventMediaModel {
  bool? success;
  int? code;
  String? message;
  List<EventMediaDataModel>? data;
  Metadata? metadata;

  EventMediaModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  EventMediaModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EventMediaDataModel>[];
      json['data'].forEach((v) {
        data!.add(new EventMediaDataModel.fromJson(v));
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
