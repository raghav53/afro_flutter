import 'package:afro/Screens/Authentication/SignInPage2.dart';
import 'package:afro/Screens/OnBoardingScreen/FirstOnBoard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool checkEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

//Month With year
String convetDateFormat(String time) {
  DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
  String datetime = tsdate.month.toString() + " " + tsdate.year.toString();
  return formatDate(tsdate);
}

//date With month year
String convetFullFormat(String time) {
  DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
  String datetime = tsdate.day.toString() +
      "/" +
      tsdate.month.toString() +
      "/" +
      tsdate.year.toString();
  return datetime;
}

String formatFullDate(DateTime date) =>
    new DateFormat("dd MMM yyyy").format(date);

String formatDate(DateTime date) => new DateFormat("MMM yyyy").format(date);

//Only year
String convetYearFormat(String time) {
  DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
  String datetime = tsdate.year.toString();
  return formatYear(tsdate);
}

String formatYear(DateTime date) => new DateFormat("yyyy").format(date);

clearAllDatabase(BuildContext context) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();

  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => FirstOnBoardScreen()),
      (Route<dynamic> route) => false);
}

String getFullDateWithTime(String time) {
  DateTime parseDate = DateFormat("HH:mm:ss.SSS'Z'").parse(time);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('dd/MMM/yyyy hh:mm a');
  var outputDate = outputFormat.format(inputDate);
  print(outputDate);
  return outputDate;
}

String getTimeFormat(String time) {
  DateTime parseDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parse(time);
  var inputDate = DateTime.parse(parseDate.toString());
  var outputFormat = DateFormat('hh:mm a');
  var outputDate = outputFormat.format(inputDate);
  return outputDate;
}

//Format(07 Apr , 12:00 AM)
Map dataTimeTextFormater(String text) {
  Map dateTime = {};
  String formatedTimeText = '';
  String formatedDateText = '';
  DateTime datetime = DateTime.parse(text);
  formatedTimeText = DateFormat("hh:mm a").format(datetime);
  formatedDateText = DateFormat("dd  MMM").format(datetime);
  dateTime.addAll({"date": formatedDateText, "time": formatedTimeText});
  return dateTime;
}

//Format(07 Apr , 12:00 AM)
Map dayTimeTextFormater(String text) {
  Map dateTime = {};
  String formatedTimeText = '';
  String formatedDateText = '';
  String formatedDayText = '';
  DateTime datetime = DateTime.parse(text);
  formatedTimeText = DateFormat("hh:mm a").format(datetime);
  formatedDateText = DateFormat("dd  MMM").format(datetime);
  formatedDayText = DateFormat("EEEE").format(datetime);
  dateTime.addAll({
    "date": formatedDateText,
    "time": formatedTimeText,
    "day": formatedDayText
  });
  return dateTime;
}




  /***
 * //Country
  Future<CountryModel> _getSearchCountriesList(String search) async {
    CountryModel mm = await _getCountriesList!;
    var ss = mm.toJson();
    CountryModel model = CountryModel.fromJson(ss);

    if (search.isEmpty) {
      return model;
    }

    int i = 0;
    while (i < model.data!.length) {
      if (!model.data![i].name
          .toString()
          .toLowerCase()
          .contains(search.toLowerCase())) {
        model.data!.removeAt(i);
      } else {
        i++;
      }
    }
    return model;
  }
 */


class DateAgo{
 static String convertToAgo(String dateTime) {
    DateTime input =
    DateFormat('yyyy-MM-DD HH:mm:ss').parse(dateTime, true);//2022-06-06 10:17:53
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays >= 1) {
      return '${diff.inDays} day${diff.inDays == 1 ? '' : 's'} ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second${diff.inSeconds == 1 ? '' : 's'} ago';
    } else {
      return 'just now';
    }
  }



}