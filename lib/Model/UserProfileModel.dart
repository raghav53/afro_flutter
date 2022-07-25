import 'dart:convert';

import 'package:afro/Model/UserProfile.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/SharedPreferencfes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
UserDataConstants user = UserDataConstants();

Future<UserProfile> getUserProfileinfo(BuildContext context, String id,
    {bool isShow = false}) async {
  if (!isShow) {
    showProgressDialogBox(context);
  }

  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;
  var response =
      await http.get(Uri.parse(BASE_URL + "user?user_id=$userId"), headers: {
    'api-key': API_KEY,
    'x-access-token': token,
  });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (!isShow) {
    Navigator.pop(context);
  }
  if (response.statusCode == 200) {
    UserProfile? userProfile = UserProfile.fromJson(jsonDecode(response.body));
    saveTheUser(userProfile);
    return UserProfile.fromJson(jsonDecode(response.body));
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

saveTheUser(UserProfile data) {
  SaveStringToSF(user.fullName, data.data!.fullName.toString());
  SaveStringToSF(user.firstName, data.data!.firstName.toString());
  SaveStringToSF(user.lastName, data.data!.lastName.toString());
  SaveStringToSF(user.age, data.data!.age.toString());
  SaveStringToSF(user.linkdin, data.data!.linkdin.toString());
  SaveStringToSF(user.facebook, data.data!.facebook.toString());
  SaveStringToSF(user.instagram, data.data!.instagram.toString());
  SaveStringToSF(user.twitter, data.data!.twitter.toString());
  SaveStringToSF(user.website, data.data!.website.toString());
  SaveStringToSF(user.token, data.data!.token.toString());
  SaveStringToSF(user.gender, data.data!.gender.toString());
  SaveStringToSF(user.profileImage, data.data!.profileImage.toString());
  SaveStringToSF(user.userType, data.data!.userType.toString());
  SaveStringToSF(user.deviceToken, data.data!.deviceToken.toString());
  SaveStringToSF(user.city, data.data!.city!.name.toString());
  SaveStringToSF(user.state, data.data!.state!.name.toString());
  SaveStringToSF(user.community, data.data!.community.toString());
  SaveStringToSF(user.socketId, data.data!.socketId.toString());
  SaveStringToSF(user.id, data.data!.id.toString());
  SaveStringToSF(user.country, data.data!.country!.title.toString());
  SaveStringToSF(user.hometown, data.data!.hometown.toString());
  SaveStringToSF(user.useremail, data.data!.email.toString());
  SaveStringToSF(user.userdob, data.data!.dob.toString());
  SaveStringToSF(user.bio, data.data!.bio.toString());
  SaveStringToSF(user.status, data.data!.status.toString());
  SaveStringToSF(user.socialId, data.data!.socialId.toString());
  SaveStringToSF(user.totalFollowers, data.data!.totalFollowers.toString());
  SaveStringToSF(user.totalFollowings, data.data!.totalFollowings.toString());
  SaveStringToSF(user.totalContacts, data.data!.totalFirends.toString());
  SaveStringToSF(user.countryId, data.data!.country!.sId.toString());
  print("Data Saved Successfully");
}

Future<UserProfile> getOtherUserProfileinfo(
    BuildContext context, String id) async {
  showProgressDialogBox(context);
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();
  String userId = sharedPreferences.getString(user.id).toString();
  print(token);
  var jsonResponse = null;
  var response =
      await http.get(Uri.parse(BASE_URL + "user?user_id=$id"), headers: {
    'api-key': API_KEY,
    'x-access-token': token,
  });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];
  if (response.statusCode == 200) {
    Navigator.pop(context);
    return UserProfile.fromJson(jsonDecode(response.body));
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

class UserProfile {
  bool? success;
  int? code;
  String? message;
  UserProfileData? data;
  Metadata? metadata;

  UserProfile(
      {this.success, this.code, this.message, this.data, this.metadata});

  UserProfile.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null
        ? new UserProfileData.fromJson(json['data'])
        : null;
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
      data['data'] = this.data!.toJson();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}
