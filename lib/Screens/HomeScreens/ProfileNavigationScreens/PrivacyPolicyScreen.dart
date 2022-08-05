import 'dart:io';

import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);
  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: commonAppbar("Privacy Policy"),
        body: Container(
            padding: EdgeInsets.only(top: 60, left: 20, right: 20),
            height: phoneHeight(context),
            width: phoneWidth(context),
            decoration: commonBoxDecoration(),
            child: WebView(
              initialUrl: 'https://flutter.dev',
            )),
      ),
    );
  }
}
