import 'package:afro/Model/Fourms/FourmDetails/FourmDetailsModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FourmDetailsPage extends StatefulWidget {
  String fourmId = "";
  FourmDetailsPage({Key? key, required this.fourmId}) : super(key: key);

  @override
  State<FourmDetailsPage> createState() => _FourmDetailsPageState();
}

Future<FourmDetailsModel>? _getFourmDetails;

class _FourmDetailsPageState extends State<FourmDetailsPage> {
  @override
  void initState() {
    super.initState();
    print(widget.fourmId);
    Future.delayed(Duration.zero, () {
      _getFourmDetails = getFourmDetails(context, widget.fourmId);
      setState(() {});
      _getFourmDetails!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: commonAppbar("Detail"),
      body: Container(
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          padding: EdgeInsets.only(top: 70),
          child: FutureBuilder<FourmDetailsModel>(
            future: _getFourmDetails,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? SingleChildScrollView(
                      child: Column(
                      crossAxisAlignment: cStart,
                      children: [
                        //Main Content
                        Container(
                            margin: EdgeInsets.only(left: 15, right: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(color: white24, width: 1)),
                            child: Column(
                              crossAxisAlignment: cStart,
                              children: [
                                customHeightBox(10),
                                Row(
                                  children: [
                                    customWidthBox(10),
                                    CachedNetworkImage(
                                      imageUrl: IMAGE_URL +
                                          snapshot
                                              .data!.data!.userId!.profileImage
                                              .toString(),
                                      placeholder: (context, url) =>
                                          const CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "tom_cruise.jpeg")),
                                      imageBuilder: (context, image) =>
                                          CircleAvatar(
                                        backgroundImage: image,
                                      ),
                                    ),
                                    customWidthBox(10),
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment: cStart,
                                          children: [
                                            customText(
                                                snapshot.data!.data!.userId!
                                                    .fullName
                                                    .toString(),
                                                15,
                                                yellowColor),
                                            customHeightBox(7),
                                            customText(
                                                snapshot.data!.data!.title
                                                    .toString(),
                                                13,
                                                white)
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                customHeightBox(20),
                                Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: customText(
                                      snapshot.data!.data!.question.toString(),
                                      15,
                                      white),
                                ),
                                customHeightBox(10)
                              ],
                            )),
                        customHeightBox(20),
                        customDivider(1, yellowColor),

                        Padding(
                          padding:
                              EdgeInsets.only(top: 10, left: 15, right: 15),
                          child: RichText(
                              text: const TextSpan(
                                  style: TextStyle(fontSize: 15),
                                  text:
                                      "Remember to keep comments respectful and to follow our",
                                  children: [
                                TextSpan(
                                    text: " Community Guidelines ",
                                    style: TextStyle(color: Colors.blueAccent))
                              ])),
                        ),
                      ],
                    ))
                  : Center(
                      child: customText("No details available", 15, white),
                    );
            },
          )),
    ));
  }
}
