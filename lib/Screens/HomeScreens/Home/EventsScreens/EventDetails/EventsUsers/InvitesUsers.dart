import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class EventInvitesUsers extends StatefulWidget {
  const EventInvitesUsers({Key? key}) : super(key: key);

  @override
  State<EventInvitesUsers> createState() => _EventInvitesUsersState();
}

class _EventInvitesUsersState extends State<EventInvitesUsers> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: phoneWidth(context),
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: black,
      ),
    );
  }
}
