import 'package:afro/Model/Events/EventsUsers/EventsUsersModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AllEventUsersScreenPage extends StatefulWidget {
  String? type = "";
  String? title = "";
  String? eventId = "";
  AllEventUsersScreenPage(
      {Key? key,
      required this.type,
      required this.title,
      required this.eventId})
      : super(key: key);

  @override
  State<AllEventUsersScreenPage> createState() =>
      _AllEventUsersScreenPageState();
}

Future<EventUsesModel>? _getAllEventsUsers;

class _AllEventUsersScreenPageState extends State<AllEventUsersScreenPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _getAllEventsUsers = getEventUsers(
          context, widget.eventId.toString(), widget.type.toString());
      setState(() {});
      _getAllEventsUsers!.whenComplete(() => () {});
    });
  }

  refreshList() {
    Future.delayed(Duration.zero, () {
      _getAllEventsUsers = getEventUsers(
          context, widget.eventId.toString(), widget.type.toString());
      setState(() {});
      _getAllEventsUsers!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: commonAppbar(widget.title.toString()),
        body: Container(
          padding: EdgeInsets.only(top: 70, left: 20, right: 20),
          decoration: commonBoxDecoration(),
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(0, 2))
                    ]),
                height: 50,
                child: const TextField(
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFFDFB48C),
                      ),
                      border: InputBorder.none,
                      hintText: "Search",
                      contentPadding: const EdgeInsets.only(left: 15, top: 15),
                      hintStyle: const TextStyle(color: Colors.white24)),
                ),
              ),
              customHeightBox(20),
              FutureBuilder<EventUsesModel>(
                  future: _getAllEventsUsers,
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            itemCount: snapshot.data!.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                color: Colors.black38,
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                OtherUserProfilePageScreen(
                                                  userID: snapshot.data!
                                                      .data![index].user!.sId
                                                      .toString(),
                                                  name: snapshot
                                                      .data!
                                                      .data![index]
                                                      .user!
                                                      .fullName,
                                                )));
                                  },
                                  leading: CachedNetworkImage(
                                      imageUrl: IMAGE_URL +
                                          snapshot.data!.data![index].user!
                                              .profileImage
                                              .toString(),
                                      placeholder: (context, url) =>
                                          const CircleAvatar(
                                              backgroundImage: AssetImage(
                                                  "tom_cruise.jpeg")),
                                      imageBuilder: (context, image) =>
                                          CircleAvatar(
                                            backgroundImage: image,
                                          ),
                                      errorWidget: (context, url, error) {
                                        return Icon(
                                          Icons.person,
                                          size: 40,
                                          color: white,
                                        );
                                      }),
                                  title: customText(
                                      snapshot.data!.data![index].user!.fullName
                                          .toString(),
                                      14,
                                      white),
                                  subtitle: Row(
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        color: white,
                                        size: 20,
                                      ),
                                      customText(
                                          snapshot.data!.data![index].user!
                                              .city![0].title
                                              .toString(),
                                          12,
                                          white)
                                    ],
                                  ),
                                ),
                              );
                              ;
                            })
                        : Center(
                            child: customText("Not data found", 15, white),
                          );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

Widget listItem() {
  return Container(
    margin: EdgeInsets.only(top: 10),
    height: 100,
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(10), color: black),
  );
}
