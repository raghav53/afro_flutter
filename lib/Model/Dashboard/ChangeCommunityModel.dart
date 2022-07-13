import 'dart:convert';

import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/Constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
UserDataConstants user = UserDataConstants();

Future<void> changeTheCommunity(BuildContext context, String countryId) async {
  showProgressDialogBox(context);
  SharedPreferences sharedPreferences = await _prefs;
  String token = sharedPreferences.getString(user.token).toString();

  var jsonResponse = null;
  var response =
      await http.post(Uri.parse(BASE_URL + "change_community"), headers: {
    'api-key': API_KEY,
    'x-access-token': token,
  }, body: {
    "community": countryId
  });
  print(response.body);
  jsonResponse = json.decode(response.body);
  var message = jsonResponse["message"];

  if (response.statusCode == 200) {
    Navigator.pop(context);
    customToastMsg("Country changed successfully!");
    Navigator.pop(context);
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
