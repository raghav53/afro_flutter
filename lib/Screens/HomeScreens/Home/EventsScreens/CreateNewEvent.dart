import 'dart:convert';
import 'dart:io';

import 'package:afro/Model/AllInterestsModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:http/http.dart' as http;
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';

import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewEvent extends StatefulWidget {
  const CreateNewEvent({Key? key}) : super(key: key);

  @override
  _CreateNewEventState createState() => _CreateNewEventState();
}

String? privacyType = "Public";
String? categoryTypeID = "";
String? categoryTypeName = "";
var items = [
  'Public',
  'Private',
  'Secret',
];

String fromText = "000000000";
String toText = "000000000";

String fromTextStartDate = "";
String toTextEndDate = "";
var imageFile = null;
TextEditingController eventName = TextEditingController();
TextEditingController eventLocationLink = TextEditingController();
TextEditingController eventWebsite = TextEditingController();
TextEditingController eventAbout = TextEditingController();
TextEditingController eventTicketLink = TextEditingController();
var type = ["In-Person", "Online"];
var defaultValue = 1;
var _selectedPrivacy = "1";

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
Future<AllInterestModel>? _getAllInterests;

class _CreateNewEventState extends State<CreateNewEvent> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getAllInterests = getInterestssList(context);
      setState(() {});
      _getAllInterests!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: commonAppbar("Create New Event"),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.only(top: 80),
        decoration: commonBoxDecoration(),
        height: phoneHeight(context),
        width: phoneWidth(context),
        child: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                  onTap: () {
                    openBottomSheet();
                  },
                  child: evntImage()),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: cStart,
                  mainAxisAlignment: mStart,
                  children: [
                    customHeightBox(50),
                    customText("NAME YOUR EVENT", 14, Colors.white),
                    customHeightBox(10),
                    eventEditext("Enter your event name", eventName),
                    customHeightBox(20),

                    //Event Type selection
                    Column(
                      crossAxisAlignment: cStart,
                      children: [
                        customText("EVENT TYPE", 14, white),
                        customHeightBox(10),
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  defaultValue = 1;
                                  eventLocationLink.text = "";
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.zero,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      focusColor: white,
                                      activeColor: white,
                                      value: 1,
                                      groupValue: defaultValue,
                                      onChanged: (value) {
                                        setState(() {
                                          defaultValue = 1;
                                          eventLocationLink.text = "";
                                        });
                                      },
                                    ),
                                    const Text(
                                      "In-Person",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  defaultValue = 2;
                                  eventLocationLink.text = "";
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.zero,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Radio(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      focusColor: white,
                                      activeColor: white,
                                      value: 2,
                                      groupValue: defaultValue,
                                      onChanged: (value) {
                                        setState(() {
                                          defaultValue = 2;
                                          eventLocationLink.text = "";
                                        });
                                      },
                                    ),
                                    const Text(
                                      "Online",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    customHeightBox(20),
                    customText(defaultValue == 1 ? "LOCATION" : "LINK", 14,
                        Colors.white),
                    customHeightBox(10),
                    eventEditext(defaultValue == 1 ? "Locaiton" : "Enter Link",
                        eventLocationLink),
                    customHeightBox(20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: InkWell(
                          onTap: () {
                            openDateBottomSheet(context, "from");
                          },
                          child: Column(
                            mainAxisAlignment: mStart,
                            crossAxisAlignment: cStart,
                            children: [
                              customText("START DATE", 14, Colors.white),
                              customHeightBox(10),
                              Container(
                                width: 160,
                                padding: const EdgeInsets.only(
                                    top: 15, bottom: 15, left: 10),
                                decoration: BoxDecoration(
                                    color: black,
                                    borderRadius: BorderRadius.circular(10)),
                                child: customText(
                                    fromTextStartDate.isEmpty
                                        ? "Start Date"
                                        : fromTextStartDate,
                                    15,
                                    fromTextStartDate.isEmpty
                                        ? white24
                                        : white),
                              ),
                            ],
                          ),
                        )),
                        customWidthBox(10),
                        Flexible(
                            child: InkWell(
                          onTap: () {
                            openDateBottomSheet(context, "to");
                          },
                          child: Column(
                            mainAxisAlignment: mStart,
                            crossAxisAlignment: cStart,
                            children: [
                              customText("END DATE", 14, Colors.white),
                              customHeightBox(10),
                              Container(
                                width: 160,
                                padding: const EdgeInsets.only(
                                    top: 15, bottom: 15, left: 10),
                                decoration: BoxDecoration(
                                    color: black,
                                    borderRadius: BorderRadius.circular(10)),
                                child: customText(
                                    toTextEndDate.isEmpty
                                        ? "End Date"
                                        : toTextEndDate,
                                    15,
                                    toTextEndDate.isEmpty ? white24 : white),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                    customHeightBox(20),
                    customText("PRIVACY", 14, Colors.white),
                    customHeightBox(10),
                    selectPrivacy(),
                    customHeightBox(20),
                    customText("CATEGORY", 14, Colors.white),
                    customHeightBox(10),
                    InkWell(
                      onTap: () {
                        showInterests();
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 15, bottom: 15, left: 15),
                        decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(children: [
                          customText(
                              categoryTypeName!.isEmpty
                                  ? "Select category"
                                  : categoryTypeName.toString(),
                              15,
                              categoryTypeName!.isEmpty ? white24 : white),
                          Spacer(),
                          Icon(
                            Icons.arrow_drop_down,
                            color: white,
                          ),
                          customWidthBox(15)
                        ]),
                      ),
                    ),
                    customHeightBox(20),
                    customText("WEBSITE(OPTIONAL)", 14, Colors.white),
                    customHeightBox(10),
                    eventEditext("Website(optional)", eventWebsite),
                    customHeightBox(20),
                    Visibility(
                        visible: defaultValue == 1 ? true : false,
                        child: Column(
                          crossAxisAlignment: cStart,
                          children: [
                            customText(
                                "INFORMATION & TIKECTS", 14, Colors.white),
                            customHeightBox(10),
                            eventEditext("Link", eventTicketLink),
                            customHeightBox(20),
                          ],
                        )),

                    customText("About", 14, Colors.white),
                    customHeightBox(10),
                    Container(
                      height: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black),
                      child: TextFormField(
                        controller: eventAbout,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 10, top: 10),
                            hintStyle: TextStyle(color: Colors.white24)),
                      ),
                    ),
                    customHeightBox(50),
                    //Save Button

                    InkWell(
                      onTap: () {
                        createNewEvent();
                      },
                      child: Center(
                        child: Container(
                            alignment: Alignment.center,
                            height: 40.0,
                            width: 100,
                            decoration: BoxDecoration(
                                gradient: commonButtonLinearGridient,
                                borderRadius: BorderRadius.circular(50)),
                            child: customText("Save", 15, white)),
                      ),
                    ),
                    customHeightBox(50)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  //Custom Privacy
  Widget selectPrivacy() {
    final FocusNode _focusNode = FocusNode();
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.black),
      width: 500,
      child: DropdownButton(
        dropdownColor: Colors.black,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        underline: Container(),
        value: privacyType,
        hint: const Text("Privacy"),
        isExpanded: true,
        items: items.map((String items) {
          return DropdownMenuItem(
              value: items,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  items,
                  style: const TextStyle(color: Colors.white),
                ),
              ));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            FocusScope.of(context).requestFocus(_focusNode);
            privacyType = newValue;
            if (privacyType!.contains("public")) {
              _selectedPrivacy = "1";
            } else if (privacyType!.contains("private")) {
              _selectedPrivacy = "2";
            } else if (privacyType!.contains("secret")) {
              _selectedPrivacy = "3";
            }
          });
        },
      ),
    );
  }

  //Custom Editext
  Widget eventEditext(String hint, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.black, borderRadius: BorderRadius.circular(5)),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            contentPadding: const EdgeInsets.only(left: 15),
            hintStyle: const TextStyle(color: Colors.white24)),
      ),
    );
  }

//Custom Event Image
  Widget evntImage() {
    return Container(
      height: 80,
      width: 130,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Container(
                child: imageFile == null
                    ? Container(
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("tom_cruise.jpeg"))),
                      )
                    : Center(
                        child: Container(
                          width: 130,
                          child: Image.file(
                            imageFile,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )),
            Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                    padding: EdgeInsets.all(4),
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: yellowColor,
                        borderRadius: BorderRadius.circular(30.0)),
                    child: const Icon(
                      Icons.edit,
                      size: 13,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  //Pick image
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        imageFile = imageTemp;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //Open bottomsheet for image
  openBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: black,
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
              height: 100,
              child: Row(
                mainAxisAlignment: mCenter,
                crossAxisAlignment: cCenter,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      open("camera");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: white, width: 1),
                            borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.camera,
                          color: white,
                          size: 35,
                        )),
                  ),
                  customWidthBox(50),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      open("gallery");
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: white, width: 1),
                            borderRadius: BorderRadius.circular(50)),
                        padding: EdgeInsets.all(5),
                        child: Icon(
                          Icons.photo_library,
                          color: white,
                          size: 35,
                        )),
                  )
                ],
              ),
            );
          });
        });
  }

  open(String subType) {
    if (subType.contains("camera")) {
      pickImage(ImageSource.camera);
    } else if (subType.contains("gallery")) {
      pickImage(ImageSource.gallery);
    }
  }

  //Date Picker
  void openDateBottomSheet(BuildContext context, String type) {
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
                margin: EdgeInsets.only(top: 30),
                decoration: commonBoxDecoration(),
                child: Column(
                  crossAxisAlignment: cCenter,
                  children: [
                    Row(
                      mainAxisAlignment: mCenter,
                      crossAxisAlignment: cCenter,
                      children: [
                        Spacer(),
                        Spacer(),
                        customText("Pick Date", 15, white),
                        Spacer(),
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
                    Container(
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
                          initialDateTime: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          onDateTimeChanged: (DateTime newDateTime) {
                            setState(() {
                              //hh:mm:ss
                              final timestamp1 =
                                  newDateTime.millisecondsSinceEpoch;
                              print(timestamp1);
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(newDateTime);
                              if (type == "from") {
                                setState(() {
                                  fromText = timestamp1.toString();
                                  fromTextStartDate = formattedDate;
                                });
                              } else if (type == "to") {
                                setState(() {
                                  toText = timestamp1.toString();
                                  toTextEndDate = formattedDate;
                                });
                              }

                              print(formattedDate);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ));
          });
        });
  }

  Future<void> createNewEvent() async {
    int fromTime = int.parse(fromText);
    int toTime = int.parse(toText);
    if (toTime <= fromTime) {
      customToastMsg("Please select another end date!");
      return;
    }
    if (eventName.text.toString().isEmpty) {
      customToastMsg("Please ente the title of event");
      return;
    }
    if (fromText == "000000000") {
      customToastMsg("Please select the valid start date of event");
      return;
    }
    if (toText == "000000000") {
      customToastMsg("Please select the valid end date of event");
      return;
    }
    if (defaultValue == 1) {
      if (eventLocationLink.text.isEmpty) {
        customToastMsg("Please Enter the location of event");
        return;
      }
      if (eventTicketLink.text.isEmpty) {
        customToastMsg("Please Enter the location of event");
        return;
      }
    }
    if (defaultValue == 2) {
      if (eventLocationLink.text.isEmpty) {
        customToastMsg("Please Enter the link of event");
        return;
      }
    }
    if (eventAbout.text.isEmpty) {
      customToastMsg("Please Enter the short description of event");
      return;
    }
    if (imageFile == null) {
      customToastMsg("Please select the image of event");
      return;
    }
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var jsonResponse;
    var uri = Uri.parse(BASE_URL + 'create_event');
    var request = http.MultipartRequest('POST', uri);
    String mimes = lookupMimeType(imageFile.path).toString();
    var mm = mimes.split("/");

    request.files.add(await http.MultipartFile.fromPath(
        "cover_image", imageFile.path,
        contentType: MediaType(mm[0], mm[1])));
    request.headers.addAll({'api-key': API_KEY, 'x-access-token': token!});
    request.fields["title"] = eventName.text.toString();
    request.fields["category"] = categoryTypeID.toString();
    request.fields["privacy"] = _selectedPrivacy;
    request.fields["about"] = eventAbout.text.toString();
    request.fields["start_date"] = fromText.toString();
    request.fields["end_date"] = toText.toString();
    request.fields["website"] = eventWebsite.text.toString();
    request.fields["location"] = eventLocationLink.text.toString();
    request.fields["event_link"] = eventTicketLink.text.toString();
    request.fields["is_link"] = defaultValue == 1 ? "1" : "2";
    request.fields["city"] = "Mohali";
    request.fields["state"] = "Punjab";
    request.fields["country"] = "India";
    var response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.pop(context);
      clearData();
      print("success");
      Navigator.pop(context);
    } else if (response.statusCode == 401) {
      customToastMsg("Unauthorized User!");
      clearAllDatabase(context);
      throw Exception("Unauthorized User!");
    } else {
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      Navigator.pop(context);
      throw Exception("Failed to load the work experience!");
    }
  }

  showInterests() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: black, borderRadius: BorderRadius.circular(10)),
                  child: StatefulBuilder(builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        customHeightBox(10),
                        customText("Select the category", 15, white),
                        customHeightBox(10),
                        Container(
                          child: FutureBuilder<AllInterestModel>(
                            future: _getAllInterests,
                            builder: (context, snapshot) {
                              return snapshot.hasData &&
                                      snapshot.data!.data!.isNotEmpty
                                  ? Flexible(
                                      child: ListView.builder(
                                        itemCount: snapshot.data!.data!.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              setState(() {
                                                Navigator.pop(context);
                                                categoryTypeID = snapshot
                                                    .data!.data![index].sId
                                                    .toString();
                                                categoryTypeName = snapshot
                                                    .data!.data![index].title
                                                    .toString();
                                              });
                                            },
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 5),
                                                decoration: BoxDecoration(
                                                    color: white24,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 15),
                                                child: customText(
                                                    snapshot.data!.data![index]
                                                        .title
                                                        .toString(),
                                                    15,
                                                    white)),
                                          );
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: customText(
                                          "No data found!", 15, white),
                                    );
                            },
                          ),
                        ),
                      ],
                    );
                  })));
        });
  }

  clearData() {
    eventName.clear();
    eventLocationLink.clear();
    eventWebsite.clear();
    eventAbout.clear();
    eventTicketLink.clear();
    imageFile = null;
    privacyType = "Public";
    categoryTypeID = "";
    categoryTypeName = "";
    fromTextStartDate = "";
    toTextEndDate = "";
  }
}
