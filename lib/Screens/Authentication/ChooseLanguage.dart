import 'package:afro/Screens/Authentication/SignInPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChooseLanguage extends StatefulWidget {
  _ChooseLangauge createState() => _ChooseLangauge();
}

class _ChooseLangauge extends State<ChooseLanguage> {
  var defaultLanguage = "English";
  var defaultIndex = 0;
  List<String> flagNameList = ['English', 'French', 'Spanish', 'German'];
  List<int> indexList = [0, 1, 2, 3];
  List<String> flagImageList = [
    'assets/language/france.png',
    'assets/language/germany.png',
    'assets/language/spain.png',
    'assets/language/united_kingdom.png'
  ];
  @override
  Widget build(BuildContext context) {
    int _Value = 0;
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        appBar: commonAppbar("Select Language"),
        extendBodyBehindAppBar: true,
        body: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("background.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: flagImageList.length,
                  itemBuilder: (context, index) {
                    return languageTitle(flagImageList[index],
                        flagNameList[index], indexList[index]);
                  }),
              customHeightBox(50),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 150,
                  height: 35,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: commonButtonLinearGridient),
                  child: Center(child: customText("Done", 12, white)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget languageTitle(String image, String name, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          defaultIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 50, right: 50, top: 10),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                image,
                height: 40,
                width: 30,
              ),
              Text(
                name,
                style: TextStyle(color: Colors.white),
              ),
              Radio(
                focusColor: white,
                activeColor: white,
                value: index,
                groupValue: defaultIndex,
                onChanged: (value) {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
