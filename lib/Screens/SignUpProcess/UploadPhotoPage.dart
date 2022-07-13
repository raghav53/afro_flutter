import 'dart:io';

import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';

import 'package:afro/Screens/SignUpProcess/SelectInterest.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadPhotoPage extends StatefulWidget {
  _UploadPhoto createState() => _UploadPhoto();
}

var imageFile = null;

class _UploadPhoto extends State<UploadPhotoPage> {
  String path = "";
  @override
  void initState() {
    super.initState();
  }

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
            extendBodyBehindAppBar: true,
            resizeToAvoidBottomInset: false,
            appBar: onlyTitleCommonAppbar("UPLOAD PHOTO"),
            body: Container(
                height: phoneHeight(context),
                width: phoneWidth(context),
                decoration: commonBoxDecoration(),
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    children: [
                      customHeightBox(70),
                      customText("Steady!", 18, Colors.white),
                      customHeightBox(15),
                      customText("Please upload your Profile Photo", 14,
                          Colors.white24),
                      customHeightBox(50),
                      Container(
                        padding: EdgeInsets.only(left: 100, right: 100),
                        child: imageFile != null
                            ? Image.file(imageFile)
                            : Image.asset("assets/tom_cruise.jpeg"),
                      ),
                      customHeightBox(50),
                      InkWell(
                        onTap: () {
                          setState(() {
                            open("camera");
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 60, right: 60),
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              gradient: commonButtonLinearGridient,
                              borderRadius: BorderRadius.circular(50)),
                          child: Row(
                            mainAxisAlignment: mCenter,
                            children: [
                              Image.asset(
                                "assets/icons/camera.png",
                                height: 20,
                                width: 20,
                              ),
                              customWidthBox(10),
                              customText("Take a Photo", 15, Colors.white)
                            ],
                          ),
                        ),
                      ),
                      customHeightBox(30),
                      InkWell(
                        onTap: () {
                          open("gallery");
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, right: 60, left: 60),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: const Color(0xFF707070), width: 1.0),
                              borderRadius: BorderRadius.circular(25)),
                          child: customText(
                              "Browse from Media", 15, const Color(0xFF707070)),
                        ),
                      ),
                      customHeightBox(10),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                (context),
                                MaterialPageRoute(
                                    builder: (context) => SelectIntrest()));
                          },
                          child:
                              customText("Skip for Now", 15, Color(0xFFDFB48C)))
                    ],
                  ),
                ))));
  }

  Future<void> uploadProfileImage(String path) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var request = http.MultipartRequest(
        'POST', Uri.parse(BASE_URL + "user_profile_image"));
    request.files.add(await http.MultipartFile.fromPath('profile_image', path));
    request.headers.addAll({'api-key': API_KEY, 'x-access-token': token!});
    var res = await request.send();
    debugPrint("res.statusCode ${res.statusCode}");
    if (res.statusCode == 200) {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SelectIntrest()));
    } else {
      Navigator.pop(context);
      customToastMsg("Something gone wrong...");
    }
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

  // //Open bottomsheet for image
  // openBottomSheet() {
  //   showModalBottomSheet(
  //       context: context,
  //       backgroundColor: black,
  //       clipBehavior: Clip.antiAlias,
  //       shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(10.0),
  //           topRight: Radius.circular(10.0),
  //         ),
  //       ),
  //       builder: (context) {
  //         return StatefulBuilder(builder: (context, state) {
  //           return Container(
  //             height: 100,
  //             child: Row(
  //               mainAxisAlignment: mCenter,
  //               crossAxisAlignment: cCenter,
  //               children: [
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     open("camera");
  //                   },
  //                   child: Container(
  //                       decoration: BoxDecoration(
  //                           border: Border.all(color: white, width: 1),
  //                           borderRadius: BorderRadius.circular(50)),
  //                       padding: EdgeInsets.all(5),
  //                       child: Icon(
  //                         Icons.camera,
  //                         color: white,
  //                         size: 35,
  //                       )),
  //                 ),
  //                 customWidthBox(50),
  //                 InkWell(
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     open("gallery");
  //                   },
  //                   child: Container(
  //                       decoration: BoxDecoration(
  //                           border: Border.all(color: white, width: 1),
  //                           borderRadius: BorderRadius.circular(50)),
  //                       padding: EdgeInsets.all(5),
  //                       child: Icon(
  //                         Icons.photo_library,
  //                         color: white,
  //                         size: 35,
  //                       )),
  //                 )
  //               ],
  //             ),
  //           );
  //         });
  //       });
  // }

  open(String subType) {
    if (subType.contains("camera")) {
      pickImage(ImageSource.camera);
    } else if (subType.contains("gallery")) {
      pickImage(ImageSource.gallery);
    }
  }
}
