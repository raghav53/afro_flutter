import 'package:afro/Model/NotificationModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Contacts/AllContactsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/AllEventsScreen.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsDetailsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Forums/FourmDetailsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupDetailsPage.dart';
import 'package:afro/Screens/HomeScreens/Home/Messages/MessageListScreen.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/FollowerFollowing.dart';
import 'package:afro/Screens/HomeScreens/ProfileNavigationScreens/WorkPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CommonMethods.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Tabs/FollowerTab.dart';

class NotificationScreenPage extends StatefulWidget {
  const NotificationScreenPage({Key? key}) : super(key: key);

  @override
  State<NotificationScreenPage> createState() => _NotificationScreenPageState();
}

Future<NotificationModel>? _getAllNotification;
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
var _userContants = UserDataConstants();

class _NotificationScreenPageState extends State<NotificationScreenPage> {
  var _userLoginID = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
    Future.delayed(Duration.zero, () {
      _getAllNotification = getNotificationList(context);
      _getAllNotification!.whenComplete(() => {setState(() {})});
    });
  }

  getUserId() async {
    SharedPreferences _dataPrefs = await _prefs;
    _userLoginID = _dataPrefs.getString(_userContants.id).toString();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: commonAppbar("Notifications"),
        body: Container(
          padding: const EdgeInsets.only(top: 80, left: 10, right: 10),
          height: phoneHeight(context),
          width: phoneWidth(context),
          decoration: commonBoxDecoration(),
          child: FutureBuilder<NotificationModel>(
            future: _getAllNotification,
            builder: (context, snapshot) {
              return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.data!.length,
                      itemBuilder: (context, index) {
                        String? imageUrl = snapshot
                            .data!.data![index].senderId!.profileImage
                            .toString();
                        String? message =
                            snapshot.data!.data![index].notification.toString();
                        return InkWell(
                          onTap: (){
                            if(snapshot.data!.data![index].type=="Chat"){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MessageListScreen()));
                            } else if(snapshot.data!.data![index].type=="follow"){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const FollowerFollowingPage(selectedIndex: 1,)));

                            } else if (snapshot.data!.data![index].type == "friend_request"){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> AllContactsListScreen(selectedIndex: 1,)));
                            }else if (snapshot.data!.data![index].type == "join_group"){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                  GroupDetailsPage(groupId: snapshot.data!.data![index].tableId.toString(), groupAdmin: '',)));

                            }else if (snapshot.data!.data![index].type == "event_invite"){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> AllEventsScreen(selectedIndex:  3,)));
                            }else if (snapshot.data!.data![index].type == "event_interested"){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> AllEventsScreen(selectedIndex:  2,)));
                            }else if (snapshot.data!.data![index].type == "form_reply"){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> FourmDetailsPage(fourmId:snapshot.data!.data![index].tableId.toString(),)));
                            }
                          },
                          child: Container(
                            width: phoneWidth(context),
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 10, right: 5),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                                color: gray1,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                              CachedNetworkImage(
                                imageUrl: IMAGE_URL + imageUrl,
                                placeholder: (context, url) => const Icon(
                                  Icons.person,
                                  size: 50,
                                ),
                                imageBuilder: (context, image) {
                                  return CircleAvatar(backgroundImage: image);
                                },
                              ),

                              //Message
                              Container(
                                margin: const EdgeInsets.only(left: 15),
                                width: phoneWidth(context) / 2.5,
                                child: Text(
                                  message,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12, color: white,fontWeight: FontWeight.bold),
                                ),
                              ),
                              const Spacer(),
                              customText(
                                  notificationDateFormat(snapshot
                                      .data!.data![index].createdAt
                                      .toString()),
                                  10,
                                  Colors.white54)
                            ]),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: customText("No data found!", 15, white),
                    );
            },
          ),
        ),
      ),
    );
  }

  /*clickToNavigate(String type, String tableId) {
    switch (type) {
      case "friend_request":
        Navigator.push(context,
            MaterialPageRoute(builder: (builder) =>  AllContactsListScreen(selectedIndex: 1,)));
        break;
      case "event_invite":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => AllEventsScreen(
                      type: "back",
                    )));
        break;
      case "join_group":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupDetailsPage(
                      groupAdmin: "",
                      groupId: tableId,
                    )));
        break;
      case "event_interested":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (builder) => EventDetailsScreenPage(
                    eventId: tableId, userId: _userLoginID)));
        break;
      case "form_reply":
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FourmDetailsPage(
                      fourmId: tableId,
                    )));
        break;
      case "Chat":
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MessageListScreen()));
        break;
      case "follow":
        Navigator.push(context,
            MaterialPageRoute(builder: (builder) => const FollowerFollowingPage(selectedIndex: 1,)));
        break;
      default:
    }
  }*/
}
