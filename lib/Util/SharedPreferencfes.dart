

import 'package:shared_preferences/shared_preferences.dart';
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();


//Save the values
SaveStringToSF(String key , String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

//Integer
SaveIntToSF(String key,int value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt(key, value);
}

//Double
SaveDoubleToSF(String key,double value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setDouble(key, value);
}

//Boolean
SaveBoolToSF(String key,bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(key,value);
}


///Get the Values
String? GetSaveStringValue(String key){
  SharedPreferences sharedPreferences =  _prefs as SharedPreferences;
  return sharedPreferences.getString(key);
}

double? GetSaveDoubleValue(String key){
  SharedPreferences sharedPreferences =  _prefs as SharedPreferences;
  return sharedPreferences.getDouble(key);
}

int? GetSaveIntValue(String key){
  SharedPreferences sharedPreferences=_prefs as SharedPreferences;
  return sharedPreferences.getInt(key);
}

bool? GetSaveBooleanValue(String key){
  SharedPreferences sharedPreferences=_prefs as SharedPreferences;
  return sharedPreferences.getBool(key);
}

