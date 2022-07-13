import 'package:afro/Model/Events/InterestedGoing/InterstedGoingModel.dart';

import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsUsers/EventGoingUsersPage.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsUsers/EventInterestedUsers.dart';

import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsUsers/InvitedUsersPage.dart';
import 'package:afro/Screens/HomeScreens/Home/EventsScreens/EventDetails/EventsUsers/InvitesUsers.dart';

import 'package:afro/Util/Colors.dart';

import 'package:afro/Util/CustomWidget.dart';

import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EventContacts extends StatefulWidget {
  String eventId = "";
  String userId = "";
  EventContacts({Key? key, required this.eventId, required this.userId})
      : super(key: key);
  @override
  State<EventContacts> createState() => _EventContactsState();
}

var selectedPeopleListItem = 0;
String? loginUserID = "";
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

//getGoingEventUsers
class _EventContactsState extends State<EventContacts> {
  @override
  void initState() {
    super.initState();
    getTheUserDetails();
    setState(() {});
  }

  getTheUserDetails() async {
    SharedPreferences data = await _prefs;
    loginUserID = data.getString(user.id).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedPeopleListItem = 0;
                  });
                },
                child: Container(
                  height: 30,
                  width: 70,
                  decoration: BoxDecoration(
                      gradient: selectedPeopleListItem == 0
                          ? commonButtonLinearGridient
                          : null,
                      color: selectedPeopleListItem == 0 ? null : black,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Center(
                    child: customText("Going", 12, white),
                  ),
                ),
              ),
              customWidthBox(7),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedPeopleListItem = 1;
                  });
                },
                child: Container(
                  height: 30,
                  width: 70,
                  decoration: BoxDecoration(
                      gradient: selectedPeopleListItem == 1
                          ? commonButtonLinearGridient
                          : null,
                      color: selectedPeopleListItem == 1 ? null : black,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  child: Center(
                    child: customText("Interested", 12, white),
                  ),
                ),
              ),
              customWidthBox(7),
              Container(
                  child: loginUserID.toString() == widget.userId.toString()
                      ? Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedPeopleListItem = 2;
                                });
                              },
                              child: Container(
                                height: 30,
                                width: 70,
                                decoration: BoxDecoration(
                                    gradient: selectedPeopleListItem == 2
                                        ? commonButtonLinearGridient
                                        : null,
                                    color: selectedPeopleListItem == 2
                                        ? null
                                        : black,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: Center(
                                  child: customText("Invited", 12, white),
                                ),
                              ),
                            ),
                            customWidthBox(7),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedPeopleListItem = 3;
                                });
                              },
                              child: Container(
                                height: 30,
                                width: 70,
                                decoration: BoxDecoration(
                                    gradient: selectedPeopleListItem == 3
                                        ? commonButtonLinearGridient
                                        : null,
                                    color: selectedPeopleListItem == 3
                                        ? null
                                        : black,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: Center(
                                  child: customText("Invites", 12, white),
                                ),
                              ),
                            ),
                          ],
                        )
                      : null)
            ],
          ),
          selectedUsersListView(selectedPeopleListItem)
        ]));
  }

  selectedUsersListView(int index) {
    if (index == 0) {
      return EventGoingUsersPage(
        eventId: widget.eventId.toString(),
      );
    } else if (index == 1) {
      return EventInterestedUsersPage(
        eventId: widget.eventId,
      );
    } else if (index == 2) {
      return InvitedUsersPage(eventId: widget.eventId);
    } else if (index == 3) {
      return EventInvitesUsers();
    }
  }
}
