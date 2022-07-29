import 'dart:convert';
import 'dart:io';

import 'package:afro/Model/AllInterestsModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupsAllListScreen.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewGroup extends StatefulWidget {
  const CreateNewGroup({Key? key}) : super(key: key);

  @override
  State<CreateNewGroup> createState() => _CreateNewGroupState();
}

String? public = "Anyone can see the group , it's members and their\nposts.";
String closed = "Only members can see post";
String secret = "Only members can find the group and see posts";
String? categoryType = "Sports";
var imageFile = null;
String? categoryTypeID = "";
String? groupBio = "";
String? categoryTypeName = "";
var groupName = "";
int selectPrivacy = 0;
Future<AllInterestModel>? _getAllInterests;

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class _CreateNewGroupState extends State<CreateNewGroup> {
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
        appBar: commonAppbar("Create New Group"),
        extendBodyBehindAppBar: true,
        body: Container(
          padding: EdgeInsets.only(top: 90),
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                    onTap: () {
                      openBottomSheet();
                    },
                    child: evntImage()),
                customHeightBox(20),
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      mainAxisAlignment: mStart,
                      crossAxisAlignment: cStart,
                      children: [
                        customText("Name Your Group", 12, Colors.white),
                        customHeightBox(10),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            onChanged: (value) {
                              groupName = value.toString();
                            },
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Please enter group name",
                                contentPadding: const EdgeInsets.only(left: 15),
                                hintStyle:
                                    const TextStyle(color: Colors.white24)),
                          ),
                        ),
                        customHeightBox(20),
                        customText("Select Privacy", 12, Colors.white),
                        customHeightBox(10),
                        privacySelection(),
                        customHeightBox(20),
                        customText("Select Category", 12, Colors.white),
                        customHeightBox(10),
                        InkWell(
                          onTap: () {
                            showInterests();
                          },
                          child: Container(
                            padding:
                                EdgeInsets.only(top: 15, bottom: 15, left: 15),
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
                        customText("About", 12, Colors.white),
                        customHeightBox(10),
                        Container(
                          height: 130,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black),
                          child: TextFormField(
                            onChanged: (value) {
                              groupBio = value.toString();
                            },
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                                hintText: "About",
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(left: 10, top: 10),
                                hintStyle: TextStyle(color: Colors.white24)),
                          ),
                        ),
                        customHeightBox(50),
                        twoButtons(context),
                        customHeightBox(50)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Category Selection
  Widget selectCatory() {
    final FocusNode _focusNode = FocusNode();
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.black),
      width: 500,
      child: DropdownButton(
        menuMaxHeight: 250,
        dropdownColor: Colors.black,
        style: TextStyle(color: Colors.white, fontSize: 16),
        underline: Container(),
        value: categoryType,
        hint: Text("Select Category"),
        isExpanded: true,
        items: category.map((String items) {
          return DropdownMenuItem(
              value: items,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  items,
                  style: TextStyle(color: Colors.white),
                ),
              ));
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            FocusScope.of(context).requestFocus(_focusNode);
            categoryType = newValue;
          });
        },
      ),
    );
  }

//Privacy Selection
  Widget privacySelection() {
    return Column(
      children: [
        //1st
        InkWell(
          onTap: () {
            setState(() {
              selectPrivacy = 1;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                  border: selectPrivacy == 1
                      ? Border.all(color: white, width: 1)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, top: 10, bottom: 10, right: 5),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/icons/world_grid.png",
                      height: 20,
                      width: 20,
                      color: selectPrivacy == 1 ? white : white24,
                    ),
                    customWidthBox(10),
                    Column(
                      crossAxisAlignment: cStart,
                      children: [
                        customText("Public Group", 10,
                            selectPrivacy == 1 ? white : white24),
                        customHeightBox(7),
                        customText(
                            public!, 12, selectPrivacy == 1 ? white : white24)
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_drop_down,
                      color: selectPrivacy == 1 ? white : black,
                    )
                  ],
                ),
              )),
        ),
        customHeightBox(7),

        //2nd
        InkWell(
          onTap: () {
            setState(() {
              selectPrivacy = 2;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                  border: selectPrivacy == 2
                      ? Border.all(color: white, width: 1)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, top: 10, bottom: 10, right: 5),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/icons/world_grid.png",
                      height: 20,
                      width: 20,
                      color: selectPrivacy == 2 ? white : white24,
                    ),
                    customWidthBox(10),
                    Column(
                      crossAxisAlignment: cStart,
                      children: [
                        customText("Closed Group", 10,
                            selectPrivacy == 2 ? white : white24),
                        customHeightBox(7),
                        customText(
                            closed, 12, selectPrivacy == 2 ? white : white24)
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_drop_down,
                      color: selectPrivacy == 2 ? white : black,
                    )
                  ],
                ),
              )),
        ),
        customHeightBox(7),

        //3rd
        InkWell(
          onTap: () {
            setState(() {
              selectPrivacy = 3;
            });
          },
          child: Container(
              decoration: BoxDecoration(
                  border: selectPrivacy == 3
                      ? Border.all(color: white, width: 1)
                      : null,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10, top: 10, bottom: 10, right: 5),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/icons/world_grid.png",
                      height: 20,
                      width: 20,
                      color: selectPrivacy == 3 ? white : white24,
                    ),
                    customWidthBox(10),
                    Column(
                      crossAxisAlignment: cStart,
                      children: [
                        customText("Secret Group", 10,
                            selectPrivacy == 3 ? white : white24),
                        customHeightBox(7),
                        customText(
                            secret, 12, selectPrivacy == 3 ? white : white24)
                      ],
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_drop_down,
                      color: selectPrivacy == 3 ? white : black,
                    )
                  ],
                ),
              )),
        )
      ],
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
        // imagesList.add(File(image.path));
        // print(lookupMimeType(image.name));
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

  //Show all interests
  showInterests() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              child: Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.only(left: 20, right: 10, bottom: 10),
                  height: phoneHeight(context) / 2,
                  decoration: BoxDecoration(
                      color: black, borderRadius: BorderRadius.circular(10)),
                  child: StatefulBuilder(builder: (context, state) {
                    return Column(
                      children: [
                        customHeightBox(10),
                        customText("Select the category", 15, white),
                        customHeightBox(10),
                        Container(
                          height: 380,
                          child: FutureBuilder<AllInterestModel>(
                            future: _getAllInterests,
                            builder: (context, snapshot) {
                              return snapshot.hasData &&
                                      snapshot.data!.data!.isNotEmpty
                                  ? ListView.builder(
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
                                                  left: 10, right: 10, top: 5),
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
                                                  snapshot
                                                      .data!.data![index].title
                                                      .toString(),
                                                  15,
                                                  white)),
                                        );
                                      },
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

  //Create group Api
  Future<void> createNewGroup() async {
    if (categoryTypeID!.isEmpty) {
      customToastMsg("Please select the category of group!");
      return;
    }
    if (selectPrivacy == 0) {
      customToastMsg("Please select the privacy of group!");
      return;
    }
    if (imageFile == null) {
      customToastMsg("Please pick the image of group!");
      return;
    }
    if (groupName.isEmpty) {
      customToastMsg("Please enter the name of group!");
      return;
    }
    if (groupBio!.isEmpty) {
      customToastMsg("Please type the short bio of group!");
      return;
    }

    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var jsonResponse;
    var uri = Uri.parse(BASE_URL + 'create_group');
    var request = http.MultipartRequest('POST', uri);
    String mimes = lookupMimeType(imageFile.path).toString();
    var mm = mimes.split("/");

    request.files.add(await http.MultipartFile.fromPath(
        "cover_image", imageFile.path,
        contentType: MediaType(mm[0], mm[1])));
    request.headers.addAll({'api-key': API_KEY, 'x-access-token': token!});
    request.fields["title"] = groupName;
    request.fields["category"] = categoryTypeID.toString();
    request.fields["privacy"] = selectPrivacy == 1
        ? "1"
        : selectPrivacy == 2
            ? "2"
            : selectPrivacy == 3
                ? "3"
                : "";
    request.fields["about"] = groupBio.toString();
    var response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.pop(context);
      print("success");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => GroupsAllListScreen()));
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

  //Create And Cancel Button
  Widget twoButtons(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: cCenter,
        mainAxisAlignment: mCenter,
        children: [
          InkWell(
            onTap: () {
              createNewGroup();
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: commonButtonLinearGridient),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 25, right: 25),
                child: customText("Create", 15, Colors.white),
              ),
            ),
          ),
          customWidthBox(50),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => GroupsAllListScreen()));
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 1, color: Colors.white)),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 25, right: 25),
                child: customText("Cancel", 15, Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
