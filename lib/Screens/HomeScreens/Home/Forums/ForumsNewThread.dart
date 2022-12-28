import 'dart:convert';
import 'dart:io';
import 'package:afro/Model/CountryModel.dart';
import 'package:afro/Model/Fourms/ForumCategoryModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:http_parser/http_parser.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ForumsNewThreadPage extends StatefulWidget {
  @override
  _ForumsNewThreadPage createState() => _ForumsNewThreadPage();
}

class _ForumsNewThreadPage extends State<ForumsNewThreadPage> {
  String? visible;
  String? selectedItem = "Item 1";
  var userType = "";
  String? categoryTypeID = "";
  String? categoryTypeName = "", countryId = "", countryName = "";
  int _groupValue = -1;
  int _usergroupValue = -1;
  List<File> imagesList = [];
//Country
  Future<CountryModel>? _getCountriesList;
  Future<ForumCategoryModel>? _getForumsCategories;
  String? caption = "";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController titleController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool showList = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getCountriesList = getCountriesList(context);
      setState(() {});
      _getCountriesList!.whenComplete(() => () {});
    });
    getDataOfForumCategories();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: mStart,
              crossAxisAlignment: cStart,
              children: [
                customHeadingPart("Create New Thread"),
                customDivider(10, Colors.white),
                customHeightBox(30),
                Container(
                  margin: EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    mainAxisAlignment: mStart,
                    crossAxisAlignment: cStart,
                    children: [
                      customText("SELECT CATEGORY", 14, Colors.white),
                      customHeightBox(10),
                      Container(
                        padding: EdgeInsets.only(top: 15, bottom: 15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.black),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  showList = !showList;
                                });
                              },
                              child: Row(
                                children: [
                                  customWidthBox(10),
                                  customText(
                                      categoryTypeName.toString().isEmpty
                                          ? "Select Category"
                                          : categoryTypeName.toString(),
                                      14,
                                      Colors.white),
                                  const Spacer(),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              child: showList
                                  ? FutureBuilder<ForumCategoryModel>(
                                      future: _getForumsCategories,
                                      builder: (context, snapshot) {
                                        return snapshot.hasData &&
                                                snapshot.data!.data!.isNotEmpty
                                            ? ListView.builder(
                                                itemCount:
                                                    snapshot.data!.data!.length,
                                                shrinkWrap: true,
                                                itemBuilder: (context, index) {
                                                  return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          showList = false;

                                                          categoryTypeID =
                                                              snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .sId
                                                                  .toString();
                                                          categoryTypeName =
                                                              snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .title
                                                                  .toString();
                                                        });
                                                      },
                                                      child: ListTile(
                                                        title: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0,
                                                                  top: 5,
                                                                  bottom: 5),
                                                          child: customText(
                                                              snapshot
                                                                  .data!
                                                                  .data![index]
                                                                  .title
                                                                  .toString(),
                                                              15,
                                                              white),
                                                        ),
                                                      ));
                                                },
                                              )
                                            : Center(
                                                child: customText(
                                                    "No data found!",
                                                    15,
                                                    white),
                                              );
                                      },
                                    )
                                  : null,
                            )
                          ],
                        ),
                      ),
                      customHeightBox(20),
                      customText("TITLE", 14, Colors.white),
                      customHeightBox(10),
                      forumsEditext("Title", titleController),
                      customHeightBox(20),
                      customText("LINK", 14, Colors.white),
                      customHeightBox(10),
                      forumsEditext("Link", linkController),
                      customHeightBox(20),
                      customText("Visible to:", 14, Colors.white),
                      customWidthBox(10),
                      customRadiosButton(),
                      customHeightBox(20),
                      customText("Content", 14, Colors.white),
                      customHeightBox(10),
                      Container(
                        height: 150,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                            color: Colors.black,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black, offset: Offset(0, 2))
                            ]),
                        child: TextFormField(
                          onChanged: (value) => {caption = value.toString()},
                          maxLength: null,
                          maxLines: null,
                          textInputAction: TextInputAction.done,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 15),
                              hintStyle: TextStyle(color: Colors.white24)),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Colors.black),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                crossAxisAlignment: cEnd,
                                mainAxisAlignment: mEnd,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        //pickVideo();
                                        openBottomSheet("video");
                                      },
                                      icon: const Icon(
                                        Icons.video_call,
                                        color: Colors.white,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        //pickImage(ImageSource.camera);
                                        openBottomSheet("photo");
                                      },
                                      icon: const Icon(
                                        Icons.photo,
                                        color: Colors.white,
                                      ))
                                ],
                              ),
                            ),
                            Visibility(
                                visible: imagesList.isNotEmpty ? true : false,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: white24,
                                  ),
                                  height: 100,
                                  width: phoneWidth(context),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: imagesList.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.all(5),
                                          height: 80,
                                          width: 70,
                                          child: Stack(children: [
                                            lookupMimeType(
                                                        imagesList[index].path)!
                                                    .contains("image")
                                                ? Image.file(
                                                    imagesList[index],
                                                  )
                                                : Image.asset(
                                                    "assets/tom_cruise.jpeg",
                                                    fit: BoxFit.fill,
                                                  ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  imagesList.remove(
                                                      imagesList[index]);
                                                });
                                              },
                                              child: Align(
                                                alignment: Alignment.topRight,
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color: red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30)),
                                                    padding: const EdgeInsets.all(3),
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: white,
                                                      size: 15,
                                                    )),
                                              ),
                                            ),
                                          ]),
                                        );
                                      }),
                                ))
                          ],
                        ),
                      ),
                      customHeightBox(50),
                      InkWell(
                        onTap: () {
                          print(
                              "Category ID :- ${categoryTypeID}\n Forum Title :- ${titleController.text}\n Link :- ${linkController.text} \n contentController:-${caption} ");
                          selectUserType(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 100, right: 100),
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          decoration: fixedButtonDesign(),
                          child: Row(
                            mainAxisAlignment: mCenter,
                            children: [customText("Publish", 17, Colors.white)],
                          ),
                        ),
                      ),
                      customHeightBox(50)
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Radio buttons (title and link)
  Widget customRadiosButton() {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _groupValue = 0;
                  countryId = "0";
                  countryName = "";
                });
              },
              child: Row(
                children: [
                  Radio(
                      value: 0,
                      groupValue: _groupValue,
                      onChanged: (index) {
                        setState(() {
                          _groupValue = 0;
                          countryId = "0";
                          countryName = "";
                        });
                      }),
                  Expanded(
                    child: customText("Global", 14, Colors.white),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _groupValue = 1;
                  showCountryDialog(context);
                });
              },
              child: Row(
                children: [
                  Radio(
                      value: 1,
                      groupValue: _groupValue,
                      onChanged: (index) {
                        setState(() {
                          _groupValue = 1;
                          showCountryDialog(context);
                        });
                      }),
                  Expanded(
                      child: customText(
                          countryName!.isEmpty
                              ? "Select Country"
                              : "Select Country\n ($countryName)",
                          14,
                          Colors.white))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //custom edittext
  Widget forumsEditext(String title, TextEditingController _controller) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(0, 2))
          ]),
      child: TextFormField(
        controller: _controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: title,
            contentPadding: const EdgeInsets.only(left: 15),
            hintStyle: const TextStyle(color: Colors.white24)),
      ),
    );
  }

  //get Forums categories
  showForumsCategoris() {
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
                          height: 360,
                          child: FutureBuilder<ForumCategoryModel>(
                            future: _getForumsCategories,
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

  getDataOfForumCategories() {
    Future.delayed(Duration.zero, () {
      _getForumsCategories = getForumCategorisList(context);
      setState(() {});
      _getForumsCategories!.whenComplete(() => () {});
    });
  }

  //Get all countries
  void showCountryDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                child: Container(
                  padding: EdgeInsets.all(10),
                  height: phoneHeight(context),
                  decoration: BoxDecoration(
                      color: gray1, borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    crossAxisAlignment: cCenter,
                    children: [
                      Row(
                        crossAxisAlignment: cCenter,
                        mainAxisAlignment: mCenter,
                        children: [
                          Spacer(),
                          Spacer(),
                          customText("Search Country", 15, white),
                          Spacer(),
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.close))
                        ],
                      ),
                      // Container(
                      //   decoration: BoxDecoration(
                      //       color: black,
                      //       borderRadius: BorderRadius.circular(10)),
                      //   margin: EdgeInsets.only(top: 10, left: 5, right: 5),
                      //   child: TextField(
                      //     onChanged: ((value) {
                      //       state(() {
                      //         // searchCountry = value;
                      //       });
                      //     }),
                      //     keyboardType: TextInputType.multiline,
                      //     maxLines: 1,
                      //     style: const TextStyle(
                      //         fontSize: 14, color: Colors.white),
                      //     decoration: const InputDecoration(
                      //         border: InputBorder.none,
                      //         hintText: "Enter country name!",
                      //         contentPadding: EdgeInsets.only(left: 10),
                      //         hintStyle: TextStyle(color: Colors.white24)),
                      //   ),
                      // ),
                      customHeightBox(10),
                      Expanded(
                          child: FutureBuilder<CountryModel>(
                        future: _getCountriesList,
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.data!.length,
                                  itemBuilder: (context, index) {
                                    String flageCode = snapshot
                                        .data!.data![index].iso2!
                                        .toString()
                                        .toLowerCase();
                                    String fullImageUrl =
                                        flagImageUrl! + flageCode + ".png";
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          countryName = snapshot
                                              .data!.data![index].name
                                              .toString();

                                          countryId = snapshot
                                              .data!.data![index].sId
                                              .toString();

                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10),
                                        margin: EdgeInsets.only(bottom: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: Border.all(color: gray4D)),
                                        height: 40,
                                        child: Row(children: [
                                          CachedNetworkImage(
                                            height: 35,
                                            width: 35,
                                            imageUrl: fullImageUrl,
                                            placeholder: (context, url) =>
                                                Icon(Icons.flag),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          customWidthBox(10),
                                          customText(
                                              snapshot.data!.data![index].name
                                                  .toString(),
                                              15,
                                              white),
                                        ]),
                                      ),
                                    );
                                  })
                              : customText("No data available", 15, white);
                        },
                      ))
                    ],
                  ),
                ));
          });
        });
  }

  //Get Image and video from camera / Gallery
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        imagesList.add(File(image.path));
        print(lookupMimeType(image.name));
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future pickVideo(ImageSource source) async {
    try {
      final image = await ImagePicker().pickVideo(source: source);
      if (image == null) return;
      final videoTemp = File(image.path);

      print(videoTemp);
      setState(() {
        imagesList.add(File(image.path));
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  //Open the bottom sheet for image and video
  openBottomSheet(String whichType) {
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
                      open(whichType, "camera");
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
                      open(whichType, "gallery");
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

  open(String type, String subType) {
    if (type.contains("photo")) {
      if (subType.contains("camera")) {
        pickImage(ImageSource.camera);
      } else if (subType.contains("gallery")) {
        pickImage(ImageSource.gallery);
      }
    } else if (type.contains("video")) {
      if (subType.contains("camera")) {
        pickVideo(ImageSource.camera);
      } else if (subType.contains("gallery")) {
        pickVideo(ImageSource.camera);
      }
    }
  }

  //User type alertbox
  void selectUserType(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0.0,
                child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: gray1, borderRadius: BorderRadius.circular(10)),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: cCenter,
                        children: [
                          Row(
                            crossAxisAlignment: cCenter,
                            mainAxisAlignment: mCenter,
                            children: [
                              Spacer(),
                              Spacer(),
                              customText("Afro-united", 15, white),
                              Spacer(),
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: white,
                                  ))
                            ],
                          ),
                          customText(
                              "Do you want to post this thread as:", 15, white),
                          customHeightBox(15),
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      state(() {
                                        _usergroupValue = 0;
                                        userType = "0";
                                        print(userType);
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Radio(
                                            focusColor: Colors.blueAccent,
                                            value: 0,
                                            groupValue: _usergroupValue,
                                            onChanged: (index) {}),
                                        Expanded(
                                          child: customText("Real Identity", 13,
                                              Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      state(() {
                                        _usergroupValue = 1;
                                        userType = "1";
                                        print(userType);
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Radio(
                                            focusColor: Colors.blueAccent,
                                            value: 1,
                                            groupValue: _usergroupValue,
                                            onChanged: (index) {}),
                                        Expanded(
                                            child: customText(
                                                "Anonymous", 13, Colors.white))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              postTheForumThread();
                            },
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  gradient: commonButtonLinearGridient,
                                  borderRadius: BorderRadius.circular(30)),
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child:
                                  Center(child: customText("Done", 15, white)),
                            ),
                          )
                        ])));
          });
        });
  }

  Future<void> postTheForumThread() async {
    if (categoryTypeID.toString().isEmpty) {
      Navigator.pop(context);
      customToastMsg("Please the category of the forum thread!");
      return;
    }
    if (titleController.text.toString().isEmpty) {
      Navigator.pop(context);
      customToastMsg("Please type the title of forum thread!");
      return;
    }
    if (linkController.text.toString().isEmpty) {
      Navigator.pop(context);
      customToastMsg("Please enter the link of forum thread!");
      return;
    }
    if (caption.toString().isEmpty) {
      Navigator.pop(context);
      customToastMsg("Please type the showrt description of forum thread!");
      return;
    }
    if (countryId.toString().isEmpty) {
      Navigator.pop(context);
      customToastMsg("Please select the option of visibility!");
      return;
    }
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var jsonResponse;
    var uri = Uri.parse(BASE_URL + 'create_form');
    var request = http.MultipartRequest('POST', uri);

    if (imagesList.isNotEmpty) {
      for (int i = 0; i < imagesList.length; i++) {
        String mimes = lookupMimeType(imagesList[i].path).toString();

        var mm = mimes.split("/");
        print(imagesList[i]);

        request.files.add(await http.MultipartFile.fromPath(
            "media", imagesList[i].path,
            contentType: MediaType(mm[0], mm[1])));
        print(request);
      }
    }
    request.headers.addAll({'api-key': API_KEY, 'x-access-token': token!});
    request.fields["title"] = titleController.text.toString();
    request.fields["question"] = caption.toString();
    request.fields["category"] = categoryTypeID.toString();
    request.fields["country"] = countryId.toString();
    request.fields["link"] = linkController.text.toString();
    request.fields["type"] = userType.toString();
    var response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.pop(context);
      print("success");
      clearData();
      Navigator.pop(context);
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

  clearData() {
    titleController.clear();
    linkController.clear();
    contentController.clear();
    _groupValue = -1;
    _usergroupValue = -1;
    caption = "";
    userType = "";
    imagesList.clear();
  }
}
