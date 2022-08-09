import 'dart:io';

import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonUI.dart';
import 'package:afro/Util/CustomWidget.dart';

import 'package:afro/Screens/SignUpProcess/SelectInterest.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:afro/Util/SharedPreferencfes.dart';
import 'package:app_settings/app_settings.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadPhotoPage extends StatefulWidget {
  _UploadPhoto createState() => _UploadPhoto();
}

var imageFile = "";
bool cameraGranted = false;
bool storageGranted = false;

class _UploadPhoto extends State<UploadPhotoPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getPer();
    });
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
              decoration: commonBoxDecoration(),
              height: phoneHeight(context),
              width: phoneWidth(context),
              child: Stack(alignment: Alignment.bottomCenter, children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      customHeightBox(70),
                      customText("Steady!", 18, Colors.white),
                      customHeightBox(15),
                      customText("Please upload your Profile Photo", 14,
                          Colors.white24),
                      customHeightBox(50),
                      Container(
                          height: 400,
                          width: phoneWidth(context),
                          decoration: const BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage("upload_img_logo.png"))),
                          child: Padding(
                            padding: EdgeInsets.all(100),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: imageFile.isNotEmpty
                                  ? Image.file(
                                      File(imageFile),
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      "tom_cruise.jpeg",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ))
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: imageFile.toString().isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(bottom: 25),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    if (imageFile.isEmpty) {
                                      customToastMsg(
                                          "Please pick the image from camera and storage!");
                                      return;
                                    }
                                    uploadProfileImage(imageFile);
                                  },
                                  child: Container(
                                      alignment: Alignment.center,
                                      width: 200,
                                      margin: const EdgeInsets.only(
                                          left: 60, right: 60),
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10),
                                      decoration: BoxDecoration(
                                          gradient: commonButtonLinearGridient,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      child: customText(
                                          "Ok Good", 15, Colors.white)),
                                ),
                                customHeightBox(15),
                                InkWell(
                                  onTap: () {
                                    openPickImageBottomsheet();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 200,
                                    padding: const EdgeInsets.only(
                                      top: 10,
                                      bottom: 10,
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color(0xFF707070),
                                            width: 1.0),
                                        borderRadius:
                                            BorderRadius.circular(25)),
                                    child: customText("Change Photo", 15,
                                        const Color(0xFF707070)),
                                  ),
                                ),
                              ]),
                        )
                      : InkWell(
                          onTap: () {
                            openPickImageBottomsheet();
                          },
                          child: Container(
                            width: 200,
                            margin: EdgeInsets.only(bottom: 25),
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            decoration: BoxDecoration(
                                gradient: commonButtonLinearGridient,
                                borderRadius: BorderRadius.circular(50)),
                            child: Row(
                              mainAxisAlignment: mCenter,
                              children: [
                                Icon(
                                  Icons.lock,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                customWidthBox(10),
                                customText("Take a Photo", 15, Colors.white)
                              ],
                            ),
                          ),
                        ),
                )
              ]),
            )));
  }

  //Upload proflie image api
  Future<void> uploadProfileImage(String path) async {
    showProgressDialogBox(context);
    SharedPreferences sharedPreferences = await _prefs;
    String? token = sharedPreferences.getString("token");
    var request = http.MultipartRequest(
        'POST', Uri.parse(BASE_URL + "user_profile_image"));
    request.files.add(await http.MultipartFile.fromPath(
        'profile_image', File(path.toString()).path));
    request.headers.addAll({'api-key': API_KEY, 'x-access-token': token!});
    var res = await request.send();
    debugPrint("res.statusCode ${res.statusCode}");
    if (res.statusCode == 200) {
      Navigator.pop(context);
      SaveStringToSF("newuser", "profileuploaded");
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
      if (!mounted) return;
      print(imageTemp.toString());

      setState(() {
        imageFile = imageTemp.path;
      });
      //uploadProfileImage(imageTemp.path);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  open(String subType) {
    if (subType.contains("camera")) {
      pickImage(ImageSource.camera);
    } else if (subType.contains("gallery")) {
      pickImage(ImageSource.gallery);
    }
  }

  //Check contacts permission
  Future<PermissionStatus> _getCameraPermission() async {
    final PermissionStatus permission = await Permission.camera.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.camera].request();
      return permissionStatus[Permission.camera] ?? PermissionStatus.restricted;
    } else {
      return permission;
    }
  }

  //Check contacts permission
  Future<PermissionStatus> _getStoragePermission() async {
    final PermissionStatus permission = await Permission.storage.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      final Map<Permission, PermissionStatus> permissionStatus =
          await [Permission.storage].request();
      return permissionStatus[Permission.storage] ??
          PermissionStatus.restricted;
    } else {
      return permission;
    }
  }

  getPer() async {
    _getCameraPermission();
    _getStoragePermission();
    final PermissionStatus permissionCameraStatus =
        await _getCameraPermission();
    final PermissionStatus permissionStorageStatus =
        await _getStoragePermission();
    if (permissionCameraStatus == PermissionStatus.granted) {
      setState(() {
        cameraGranted = true;
      });
    } else if (permissionStorageStatus == PermissionStatus.granted) {
      setState(() {
        cameraGranted = true;
      });
    } else {
      setState(() {
        cameraGranted = false;
        storageGranted = false;
      });
    }
  }

  openSettings() async {
    customToastMsg("Please grant the permission of storage!");
    await AppSettings.openAppSettings();
  }

  openPickImageBottomsheet() {
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
                      if (!cameraGranted) {
                        openSettings();
                        return;
                      }
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
                      if (!cameraGranted) {
                        openSettings();
                        return;
                      }
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
}
