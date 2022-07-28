import 'package:afro/Model/Events/EventDetails/EventPosts/EventPostDataModel.dart';
import 'package:afro/Model/Events/EventDetails/EventComments/EventCommentDataModel.dart';

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

Future<EventPostModel> getEventPostList(
    BuildContext context, String eventId) async {

  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;

  var response = await http
      .get(Uri.parse(BASE_URL + "event_posts?event_id=$eventId"), headers: {
    'api-key': API_KEY,
    'x-access-token': token,
  });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {

    print("Get event posts api success");
    return EventPostModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
   
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

class EventPostModel {
  bool? success;
  int? code;
  String? message;
  List<EventPostDataModel>? data;
  PostMetadata? metadata;

  EventPostModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  EventPostModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EventPostDataModel>[];
      json['data'].forEach((v) {
        data!.add(new EventPostDataModel.fromJson(v));
      });
    }
    metadata = json['metadata'] != null
        ? new PostMetadata.fromJson(json['metadata'])
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
