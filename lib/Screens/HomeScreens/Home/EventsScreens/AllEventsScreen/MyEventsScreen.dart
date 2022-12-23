import 'package:afro/Model/Events/UserEvents/UserEventModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsDetailsPage.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../Util/Colors.dart';

MyEventsScreenState(BuildContext context, UsersEventsModel eventData) {
  return Container(
    width: phoneWidth(context),
    child: Column(
      children: [
        customHeightBox(20),
        Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            height: phoneHeight(context) / 1.5,
            child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: eventData.data!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EventDetailsScreenPage(
                                eventId: eventData.data![index].sId.toString(),
                                userId: eventData.data![index].userId!.id
                                    .toString(),
                              )));
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom:
                              eventData.data!.length - 1 == index ? 100 : 0),
                      child: Column(
                        mainAxisAlignment: mStart,
                        crossAxisAlignment: cStart,
                        children: [
                          CachedNetworkImage(
                            imageUrl: IMAGE_URL +
                                eventData.data![index].coverImage.toString(),
                            imageBuilder: (context, imageProvider) => Container(
                              width: phoneWidth(context),
                              height: 150.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                          customHeightBox(10),
                          customText(eventData.data![index].title.toString(),
                              12, Colors.white),
                          customHeightBox(5),
                          customText(
                            eventData.data![index].totalInterested.toString() +
                                " Interested",
                            11,
                            const Color(0xff7822A0),
                          ),
                          customHeightBox(5),
                          Row(
                            children: [
                              (eventData.data![index].isLink.toString()!="2")? Image.asset("assets/location.png",height: 15,width: 15,): Image.asset(
                                "assets/icons/http.png",
                                height: 15,
                                width: 15,
                                color: yellowColor,
                              ),

                              customWidthBox(5),
                              customWidthBox(5),
                              (eventData
                                  .data![index].country != null&&eventData
                                  .data![index].country!= ""&&eventData.data![index].isLink.toString()!="2")?
                              customText(
                                  eventData
                                      .data![index].state.toString()+","+
                                  eventData
                                      .data![index].country!.title.toString(),

                                  12,
                                  Colors.white): (  eventData
                                  .data![index].eventLink==""&& eventData
                                  .data![index].eventLink == null)?const Text(""):customText(
                                  eventData
                                      .data![index].eventLink.toString(),

                                  12,
                                  Colors.white),
                            ],
                          ),
                          customHeightBox(30)
                        ],
                      ),
                    ),
                  );
                })),
      ],
    ),
  );
}
