import 'package:afro/Model/Events/Going/GoingInterestedEventsModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsDetailsPage.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

GoingEventsScreen(
    BuildContext context, GoingInterestedEventsModel _getAllGoingEvents) {
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
                itemCount: _getAllGoingEvents.data!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EventDetailsScreenPage(
                                eventId: _getAllGoingEvents.data![index].eventId
                                    .toString(),
                                userId: _getAllGoingEvents.data![index].userId
                                    .toString(),
                              )));
                    },
                    child: Column(
                      mainAxisAlignment: mStart,
                      crossAxisAlignment: cStart,
                      children: [
                        CachedNetworkImage(
                          imageUrl: IMAGE_URL +
                              _getAllGoingEvents.data![index].event!.coverImage
                                  .toString(),
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
                        customText(
                            _getAllGoingEvents.data![index].event!.title
                                .toString(),
                            12,
                            Colors.white),
                        customHeightBox(5),
                        customText(
                          _getAllGoingEvents.data![index].event!.totalInterested
                                  .toString() +
                              " Interested",
                          11,
                          const Color(0xff7822A0),
                        ),
                        customHeightBox(5),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_pin,
                              color: Color(0xFFDFB48C),
                              size: 15,
                            ),
                            customWidthBox(5),
                            customText(
                                _getAllGoingEvents
                                    .data![index].event!.country![0].title
                                    .toString(),
                                12,
                                Colors.white)
                          ],
                        ),
                        customHeightBox(30)
                      ],
                    ),
                  );
                })),
      ],
    ),
  );
}
