import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../Model/Events/EventDetails/EventModel.dart';
import '../../../../../Util/Constants.dart';
import '../../../../../Util/CustomWidgetAttributes.dart';
class EventSetting extends StatefulWidget {
  String eventId ="";
   EventSetting({Key? key,required this.eventId}) : super(key: key);

  @override
  State<EventSetting> createState() => _EventSettingState();
}
var user = UserDataConstants();
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<EventDetailModel>? _getEventDetails;
String? userId = "";
String date = "";

class _EventSettingState extends State<EventSetting> {
  List<String> privacyList = ["Private","Public","Secret"];
  String? selectedValue = 'Private';


  /*refreshData() {
    _getEventDetails = getEventDetails(context, widget.eventId.toString());
    setState(() {});
    _getEventDetails!.whenComplete(() => () {});
  }*/

  getUserDetails() async {
    SharedPreferences shared = await _prefs;
    userId = shared.getString(user.id).toString();
  }


  TextEditingController eventController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserDetails();
    Future.delayed(Duration.zero, () {
      _getEventDetails = getEventDetails(context, widget.eventId.toString());
      setState(() {});
      _getEventDetails!.whenComplete(() => () {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EventDetailModel>(
          future: _getEventDetails,
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data!.data!=""
      ?Container(
        padding: const EdgeInsets.only(top: 20, left: 10, right: 10),

        decoration: commonBoxDecoration(),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           customText("NAME YOUR EVENT", 15, white),
            const SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                      color: black, borderRadius: BorderRadius.circular(5)),
                  child: TextFormField(
                    controller: eventController,
                    style: const TextStyle(fontSize: 14,color: Colors.white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: (widget.eventId=="")?"Enter your event name":snapshot.data!.data!.title.toString(),
                        hintStyle: (widget.eventId=="")?const TextStyle(color: Colors.white24):TextStyle(color: white,fontSize: 14),
                        contentPadding: const EdgeInsets.only(left: 15),
                       ),
                  ),
                ),
            /*Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow:  [
                    BoxShadow(color: black, offset: Offset(0, 2))
                  ]),
              height: 50,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    eventController.text = value;
                   *//* changeValue = value;*//*
                  });
                },
                textInputAction: TextInputAction.next,
                controller: eventController,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration:  InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 15),
                    hintText: (widget.eventId=="")?"Enter your event name":snapshot.data!.data!.title.toString(),
                    hintStyle: (widget.eventId=="")?TextStyle(color: Colors.white24):TextStyle(color: white,fontSize: 14)),
              ),
            ),*/
            const SizedBox(height: 20,),
            customText((snapshot.data!.data!.eventLink!=null||snapshot.data!.data!.eventLink!.isNotEmpty)?"LINK":"LOCATION", 15, white),
            const SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                  color: black, borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                controller: linkController,
                style: const TextStyle(fontSize: 14,color: Colors.white),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: (widget.eventId=="")
                      ?"Enter Link"
                      :snapshot.data!.data!.eventLink.toString(),
                  hintStyle:(widget.eventId=="")?const TextStyle(color: Colors.white24):TextStyle(color: white,fontSize: 14),
                  contentPadding: const EdgeInsets.only(left: 15),
                ),
              ),
            ),
           /* Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(0, 2))
                  ]),
              height: 50,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    *//* changeValue = value;*//*
                  });
                },
                textInputAction: TextInputAction.next,
                controller: linkController,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration:  InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15),
                    hintText: (widget.eventId=="")?"Enter Link":snapshot.data!.data!.eventLink.toString(),
                    hintStyle: (widget.eventId=="")?TextStyle(color: Colors.white24):TextStyle(color: white,fontSize: 14)),
              ),
            ),*/
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    customText("START DATE", 15, white),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: (){
                        openDateBottomSheet(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(10)),
                        child: (widget.eventId!=null)
                            ?customText(timeTextFormater(snapshot
                            .data!.data!.startDate
                            .toString())["date"] +
                            " , " +
                            timeTextFormater(snapshot
                                .data!.data!.startDate
                                .toString())["time"],
                            12, white)
                            :customText(
                             "Start date",

                            12,
                            Colors.white24),
                      ),
                    )
                  ],
                ),
                Column(
                  children: [
                    customText("END DATE", 15, white),
                    const SizedBox(height: 10,),
                    InkWell(
                       onTap: (){
                         openDateBottomSheet(context);
                       },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 15, bottom: 15, left: 10, right: 10),
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(10)),
                        child: (widget.eventId!=null)
                            ?customText(timeTextFormater(snapshot
                            .data!.data!.endDate
                            .toString())["date"] +
                            " , " +
                            timeTextFormater(snapshot
                                .data!.data!.endDate
                                .toString())["time"],
                            12, white)
                            :customText(

                                 "End date",
                            12,
                            Colors.white24),

                      ),
                    ),
                  ],
                )

              ],
            ),
            const SizedBox(height: 20,),
            customText("SELECT PRIVACY", 15, white),
            const SizedBox(height: 10,),
            Container(
              padding: const EdgeInsets.only(left: 16, right: 10),
              decoration: BoxDecoration(
                color: black,
                borderRadius: BorderRadius.circular(10),
              ),
              child: FormField(builder: (FormFieldState<String> state) {
                return InputDecorator(
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                 /* isEmpty: selectedGender == '',*/
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      icon: Icon(
                        Icons.arrow_drop_down_outlined,
                        color: yellowColor,
                      ),
                      dropdownColor: Colors.black,
                      value: selectedValue,
                      isDense: true,
                      onChanged: (val) {
                        setState(() {
                          selectedValue = val;;
                          state.didChange(val);

                        });
                      },
                      items: privacyList.map((String item,) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20,),
            customText("CATEGORY", 15, white),
            const SizedBox(height: 10,),

            Container(
              padding: const EdgeInsets.only(
                  top: 15, bottom: 15, left: 10, right: 10),
              width: phoneWidth(context),
              decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  customText(

                      "category"
                      ,
                      12,
                      Colors.white24),
                  Spacer(),
                  Icon(
                    Icons.arrow_drop_down_rounded,
                    color: yellowColor,
                  )
                ],
              ),
            ),
            const SizedBox(height: 20,),
            customText("WEBSITE(OPTIONAL)", 15, white),
            const SizedBox(height: 10,),
            Container(
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(0, 2))
                  ]),
              height: 50,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    /* changeValue = value;*/
                  });
                },
                textInputAction: TextInputAction.next,
                controller: websiteController,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration:  InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15),
                    hintText: (widget.eventId==""||snapshot.data!.data!.website=="")?"Website(optional)"
                        :snapshot.data!.data!.website.toString(),
                    hintStyle: (widget.eventId==""||snapshot.data!.data!.website=="")?TextStyle(color:  Colors.white24):TextStyle(color:  white,fontSize: 14),),
              ),
            ),
            const SizedBox(height: 20,),
            customText("About", 15, white),
            const SizedBox(height: 10,),
            Container(
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(0, 2))
                  ]),
              height: 150,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    /* changeValue = value;*/
                  });
                },
                textInputAction: TextInputAction.next,
                controller: websiteController,
                keyboardType: TextInputType.text,
                style: const TextStyle(fontSize: 14, color: Colors.white),
                decoration:  InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(left: 15),
                    hintText:(widget.eventId==""||snapshot.data!.data!.about=="")? " ":snapshot.data!.data!.about.toString(),
                    hintStyle: (widget.eventId==""||snapshot.data!.data!.about=="")?TextStyle(color:  Colors.white24):TextStyle(color:  white,fontSize: 14),),
              ),
            ),
            const SizedBox(height: 30,),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(onPressed: (){},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,

                  ),
                  child: Container(
                    height: 40,
                    width: 140,
                    decoration: BoxDecoration(
                      gradient: commonButtonLinearGridient,
                      borderRadius: BorderRadius.circular(20)
                    ),
                    alignment: Alignment.center,
                    child: customText("Save", 16, white),
                  ) ),
            )
          ],
        ) ):SizedBox();});
  }
  openDateBottomSheet(BuildContext context) {
    showModalBottomSheet(
        isDismissible: false,
        backgroundColor: Colors.transparent,
        context: context,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
                height: 300,
                margin: const EdgeInsets.only(top: 30),
                decoration: commonBoxDecoration(),
                child: Column(
                  crossAxisAlignment: cCenter,
                  children: [
                    Row(
                      mainAxisAlignment: mCenter,
                      crossAxisAlignment: cCenter,
                      children: [
                        const Spacer(),
                        const Spacer(),
                        customText("Pick Date", 15, white),
                        const Spacer(),
                        customWidthBox(25),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: customText("Done", 14, circleColor))
                      ],
                    ),
                    customDivider(10, white),
                    customHeightBox(10),
                    SizedBox(
                      height: 200,
                      child: CupertinoTheme(
                        data: const CupertinoThemeData(
                          textTheme: CupertinoTextThemeData(
                            dateTimePickerTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        child: CupertinoDatePicker(
                          dateOrder: DatePickerDateOrder.dmy,
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime(1980, 1, 1),
                          onDateTimeChanged: (DateTime newDateTime) {
                            setState(() {
                              timeTextFormater(newDateTime.toString());
                             /* String formatedTimeText = '';
                              String formatedDateText = '';
                              DateTime datetime = DateTime.fromMillisecondsSinceEpoch(int.parse(text));
                              formatedTimeText = DateFormat("hh:mm a").format(datetime);
                              formatedDateText = DateFormat("dd  MMM").format(datetime);
                              dateTime.addAll({"date": formatedDateText, "time": formatedTimeText});
                              print(dateTime["date"] + " " + dateTime["time"]);*/
                             /* dobTimeStamp =
                                  newDateTime.millisecondsSinceEpoch.toString();
                              print("TimeStamp :-" + dobTimeStamp);
                              String formattedDate =
                              DateFormat('dd-MM-yyyy').format(newDateTime);
                              date = formattedDate;
                              print(formattedDate);*/
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ));
          });
        });
    /*return dateOfBirth;*/
  }

  String getPrivacy(String privacy) {
    if (privacy == "1") {
      return "Private";
    } else if (privacy == "2") {
      return "Public";
    } else if (privacy == "3") {
      return "secret	";
    }else{
      return "";
    }
  }
}
