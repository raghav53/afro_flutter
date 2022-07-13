import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';

void showProgressDialogBox(BuildContext context) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            child: Container(
              padding: EdgeInsets.all(20),
              height: 100,
              width: 50,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: const LoadingIndicator(
                  indicatorType: Indicator.ballClipRotate,
                  colors: [
                    Colors.white,
                    Colors.black,
                    Colors.yellow,
                  ],
                  strokeWidth: 1,
                  pathBackgroundColor: Colors.black),
            ));
      });
}

void customToastMsg(String msg) {
  Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_SHORT);
}
