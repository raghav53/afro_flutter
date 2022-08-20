import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:http_parser/http_parser.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareThoughts extends StatefulWidget {
  String evenGroupId = "";
  String type = "";
  ShareThoughts({Key? key, required this.evenGroupId, required this.type})
      : super(key: key);

  @override
  State<ShareThoughts> createState() => _ShareThoughtsState();
}

class _ShareThoughtsState extends State<ShareThoughts> {
  Future<Uint8List>? uint8list;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<File> imagesList = [];

  String caption = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: commonAppbar("Share your thoughts"),
        body: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 70),
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          child: Column(
            children: [
              Container(
                height: 150,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(color: Colors.black, offset: Offset(0, 2))
                    ]),
                child: TextFormField(
                  onChanged: (value) => {caption = value.toString()},
                  maxLength: null,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "What's in your Mind? #Hashtag #Tags",
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
                                    lookupMimeType(imagesList[index].path)!
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
                                          imagesList.remove(imagesList[index]);
                                        });
                                      },
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: red,
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            padding: EdgeInsets.all(3),
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
                  if (widget.type.contains("event")) {
                    uploadTheUserPost();
                  } else if (widget.type.contains("group")) {
                    uploadTheGroupUserPost();
                  }
                },
                child: Container(
                  height: 40,
                  width: 200,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: commonButtonLinearGridient),
                  child: Center(
                    child: customText("POST", 20, white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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

  //Upload th euser post for event
  Future<void> uploadTheUserPost() async {
    if (caption.isEmpty) {
      customToastMsg("Please write the caption of post");
      return;
    }
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var jsonResponse;
    var uri = Uri.parse(BASE_URL + 'add_event_post');
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
    request.fields['event_id'] = widget.evenGroupId.toString();
    request.fields['caption'] = caption;
    var response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.pop(context, true);
      print("success");
      caption = "";
      imagesList.clear();
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

  //Upload th euser post for GRoup
  Future<void> uploadTheGroupUserPost() async {
    if (caption.isEmpty) {
      customToastMsg("Please write the caption of post");
      return;
    }
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var jsonResponse;
    var uri = Uri.parse(BASE_URL + 'add_group_post');
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
    request.fields['group_id'] = widget.evenGroupId.toString();
    request.fields['caption'] = caption;
    var response = await request.send();
    print(response.statusCode);

    if (response.statusCode == 200) {
      Navigator.pop(context);
      caption = "";
      imagesList.clear();
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
}
