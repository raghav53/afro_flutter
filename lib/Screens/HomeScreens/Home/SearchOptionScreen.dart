import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/material.dart';

class SearchOptionScreen extends StatefulWidget {
  @override
  State<SearchOptionScreen> createState() => _SearchOptionScreenState();
}

class _SearchOptionScreenState extends State<SearchOptionScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: commonBoxDecoration(),
          height: double.infinity,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: cStart,
            mainAxisAlignment: mStart,
            children: [
              customHeadingPart("Search"),
              customHeightBox(20),
              Container(
                margin: EdgeInsets.only(left: 35, right: 20),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black),
                child: TextField(
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFFDFB48C),
                      ),
                      hintText: "Search Events , Group and Contacts",
                      contentPadding: const EdgeInsets.only(left: 15, top: 15),
                      hintStyle: const TextStyle(color: Colors.white24)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
