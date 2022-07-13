import 'dart:convert';

import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/OnBoardingScreen/FirstOnBoard.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<CitiesModel> getCitiessList(BuildContext context, String stateId) async {
  showProgressDialogBox(context);
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();

  print(token);
  var jsonResponse = null;
  var response = await http
      .get(Uri.parse(BASE_URL + "cities?state_id=${stateId}"), headers: {
    'api-key': API_KEY,
    'x-access-token': token,
  });

  print("\n\n\n\n" + response.body);
  jsonResponse = json.decode(response.body);

  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    Navigator.pop(context);
    print("success");
    return CitiesModel.fromJson(jsonDecode(response.body));
  }else if (response.statusCode == 401) {
    customToastMsg("Unauthorized User!");
    clearAllDatabase(context);
    throw Exception("Unauthorized User!");
  } else {
    Navigator.pop(context);
    customToastMsg(message);
    throw Exception("Failed to load the work experience!");
  }
}

class CitiesModel {
  bool? success;
  int? code;
  String? message;
  List<Data>? data;
  Metadata? metadata;

  CitiesModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  CitiesModel.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  int? stateId;
  String? stateCode;
  String? stateName;
  int? countryId;
  String? countryCode;
  String? countryName;
  String? latitude;
  String? longitude;
  String? wikiDataId;
  String? title;
  String? status;

  Data(
      {this.sId,
      this.id,
      this.name,
      this.stateId,
      this.stateCode,
      this.stateName,
      this.countryId,
      this.countryCode,
      this.countryName,
      this.latitude,
      this.longitude,
      this.wikiDataId,
      this.title,
      this.status});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    stateId = json['state_id'];
    stateCode = json['state_code'];
    stateName = json['state_name'];
    countryId = json['country_id'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    wikiDataId = json['wikiDataId'];
    title = json['title'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_id'] = this.stateId;
    data['state_code'] = this.stateCode;
    data['state_name'] = this.stateName;
    data['country_id'] = this.countryId;
    data['country_code'] = this.countryCode;
    data['country_name'] = this.countryName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['wikiDataId'] = this.wikiDataId;
    data['title'] = this.title;
    data['status'] = this.status;
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
