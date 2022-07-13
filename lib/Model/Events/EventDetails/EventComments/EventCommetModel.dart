import 'package:afro/Model/Events/EventDetails/EventComments/EventCommentDataModel.dart';

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

Future<EventCommentModel> getEventCommentsList(
    BuildContext context, String eventPostId,
    {String progress = ""}) async {
  progress == "yes" ? showProgressDialogBox(context) : null;
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;

  var response = await http.get(
      Uri.parse(BASE_URL + "event_post_comments?event_post_id=$eventPostId"),
      headers: {
        'api-key': API_KEY,
        'x-access-token': token,
      });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    progress == "yes" ? Navigator.pop(context) : null;
    print("Get event comments api success");
    return EventCommentModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    progress == "yes" ? Navigator.pop(context) : null;
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

Future<EventCommentModel> getEventCommentsoCommentList(
    BuildContext context, String eventPostId,
    String eventParenCommentId
    ) async {
 
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;

  var response = await http.get(
      Uri.parse(BASE_URL + "event_post_comments?event_post_id=$eventPostId&parent_comment_id=$eventParenCommentId"),
      headers: {
        'api-key': API_KEY,
        'x-access-token': token,
      });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    
    print("Get event comments of comments api success");
    return EventCommentModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

class EventCommentModel {
  bool? success;
  int? code;
  String? message;
  List<EventCommentDataModel>? data;
  Metadata? metadata;

  EventCommentModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  EventCommentModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <EventCommentDataModel>[];
      json['data'].forEach((v) {
        data!.add(new EventCommentDataModel.fromJson(v));
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
