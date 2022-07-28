import 'dart:convert';
import 'package:afro/Model/Events/InvitedEvents/InvitedEventsDataModel.dart';
import 'package:http/http.dart' as http;
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<InvitedEventsModel> getAllInvitedEventsUsers(
  BuildContext context, {
  String search = "",
  String page = "1",
  String limit = "1000",
  bool isShow = true,
}) async {
  if (isShow) {
    showProgressDialogBox(context);
  }
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;
  print("received_event_invites_user?search=$search&page=$page&limit=$limit");
  var response = await http.get(
      Uri.parse(BASE_URL +
          "received_event_invites_user?search=$search&page=$page&limit=$limit"),
      headers: {
        'api-key': API_KEY,
        'x-access-token': token,
      });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (isShow) {
    Navigator.pop(context);
  }
  if (response.statusCode == 200) {
    print("Get All invited events api success");
    print(jsonResponse["metadata"]["totalDocs"]);
    return InvitedEventsModel.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

class InvitedEventsModel {
  bool? success;
  int? code;
  String? message;
  List<InvitedEventsDataModel>? data;
  Metadata? metadata;

  InvitedEventsModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  InvitedEventsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <InvitedEventsDataModel>[];
      json['data'].forEach((v) {
        data!.add(new InvitedEventsDataModel.fromJson(v));
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
