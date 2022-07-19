import 'package:afro/Model/Group/UserGroups/UserGroupsModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/Groups/GroupDetails/GroupDetailsPage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/Constants.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MyGroupsScreen extends StatefulWidget {
  const MyGroupsScreen({Key? key}) : super(key: key);

  @override
  State<MyGroupsScreen> createState() => _MyGroupsScreenState();
}

Future<UserGroupsModel>? _allGroups;
var user = UserDataConstants();

class _MyGroupsScreenState extends State<MyGroupsScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _allGroups = getAllUsersGroups(context);
      setState(() {});
      _allGroups!.whenComplete(() => () {});
    });
  }

  refreshData() {
    Future.delayed(Duration.zero, () {
      _allGroups = getAllUsersGroups(context);
      setState(() {});
      _allGroups!.whenComplete(() => () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserGroupsModel>(
        future: _allGroups,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.data!.data!.isNotEmpty
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.data!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 10, left: 5, right: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      padding:
                          const EdgeInsets.only(top: 15, bottom: 15, left: 10),
                      child: Column(
                        children: [
                          Row(children: [
                            CachedNetworkImage(
                                imageUrl: IMAGE_URL +
                                    snapshot.data!.data![index].coverImage!
                                        .toString(),
                                errorWidget: (error, context, url) =>
                                    const Icon(Icons.person),
                                placeholder: (context, url) =>
                                    const Icon(Icons.person),
                                imageBuilder: (context, url) {
                                  return CircleAvatar(
                                    backgroundImage: url,
                                  );
                                }),
                            customWidthBox(10),
                            Column(
                              crossAxisAlignment: cStart,
                              children: [
                                SizedBox(
                                    width: 120,
                                    child: Text(
                                      snapshot.data!.data![index].title
                                          .toString(),
                                      overflow: TextOverflow.fade,
                                      maxLines: null,
                                      softWrap: false,
                                      style:
                                          TextStyle(color: white, fontSize: 11),
                                    )),
                                customHeightBox(5),
                                Row(
                                  children: [
                                    customText(
                                        snapshot.data!.data![index].totalMembers
                                                .toString() +
                                            " Members",
                                        11,
                                        yellowColor)
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => GroupDetailsPage(
                                          groupId: snapshot
                                              .data!.data![index].id
                                              .toString(),
                                          groupAdmin: snapshot
                                              .data!.data![index].userId!.id
                                              .toString(),
                                        )));
                              },
                              child: Container(
                                width: 110,
                                margin: const EdgeInsets.only(right: 20),
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, left: 10, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    gradient: commonButtonLinearGridient),
                                child: Center(
                                    child:
                                        customText("View Details", 11, white)),
                              ),
                            )
                          ]),
                          customHeightBox(5),
                          customDivider(1, white24)
                        ],
                      ),
                    );
                  })
              : Center(
                  child: customText("No data found!", 15, white),
                );
        });
  }
}
