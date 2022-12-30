import 'package:afro/Model/Group/GroupMember/GroupMemberModel.dart';
import 'package:afro/Network/Apis.dart';
import 'package:afro/Screens/HomeScreens/Home/OtherUserProfilePage.dart';
import 'package:afro/Util/Colors.dart';
import 'package:afro/Util/CustomWidget.dart';
import 'package:afro/Util/CustomWidgetAttributes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class GroupMemberListScreen extends StatefulWidget {
  String? group_id = "";
  String? userId = "";
  GroupMemberListScreen({Key? key, this.group_id, this.userId})
      : super(key: key);

  @override
  State<GroupMemberListScreen> createState() => _GroupMemberListScreenState();
}

Future<GroupMemberModel>? _getGroupMembers;

class _GroupMemberListScreenState extends State<GroupMemberListScreen> {
  var searchKey = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: commonAppbar("Members"),
      body: Container(
        height: phoneHeight(context),
        width: phoneWidth(context),
        decoration: commonBoxDecoration(),
        padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              customHeightBox(50),
              //Search Editext
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow:  [
                      BoxShadow(color: black, offset: Offset(0, 2))
                    ]),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchKey = value.toString();
                    });
                  },
                  keyboardType: TextInputType.text,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFFDFB48C),
                      ),
                      hintText: "Search",
                      contentPadding: EdgeInsets.only(left: 15, top: 15),
                      hintStyle: TextStyle(color: Colors.white24)),
                ),
              ),
              customHeightBox(15),
              FutureBuilder<GroupMemberModel>(
                  future: getAllGroupsMembers(
                      context, widget.group_id.toString(),
                      search: searchKey, showProgress: false),
                  builder: (context, snapshot) {
                    return snapshot.hasData && snapshot.data!.data!.isNotEmpty
                        ? ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: snapshot.data!.data!.length,
                            itemBuilder: (context, index) {
                              int? isFriend =
                                  snapshot.data!.data![index].member!.isFriend;
                              int? isRequestSend =
                                  snapshot.data!.data![index].member!.isReqSent;
                              int? isRequestReceived = snapshot
                                  .data!.data![index].member!.isReqReceived;
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          OtherUserProfilePageScreen(
                                              name: snapshot.data!.data![index]
                                                  .member!.fullName,
                                              userID: snapshot
                                                  .data!.data![index].memberId
                                                  .toString(),
                                              loginUserId: widget.userId)));
                                },
                                child: Container(

                                  margin: const EdgeInsets.only(top: 10),

                                  decoration: BoxDecoration(
                                      color: black,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.only(
                                      right: 10, left: 10,top: 15,bottom: 15),
                                  child: Row(
                                      children: [
                                    CachedNetworkImage(
                                        imageUrl: IMAGE_URL +
                                            snapshot.data!.data![index].member!
                                                .profileImage
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
                                              snapshot.data!.data![index]
                                                  .member!.fullName
                                                  .toString(),
                                              overflow: TextOverflow.fade,
                                              maxLines: null,
                                              softWrap: false,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11),
                                            )),
                                        customHeightBox(5),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_pin,
                                              size: 15,
                                              color: white,
                                            ),
                                            customText(
                                                snapshot.data!.data![index]
                                                        .member!.state![0].title
                                                        .toString() +
                                                    " , " +
                                                    snapshot
                                                        .data!
                                                        .data![index]
                                                        .member!
                                                        .country![0]
                                                        .title
                                                        .toString(),
                                                11,
                                                white)
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: (){},
                                      child: (snapshot.data!.data![index].member!.isFriend ==0&&widget.userId!=snapshot.data!.data![index].member!.sId.toString())?Container(
                                        alignment: Alignment.center,
                                        width: 70,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            gradient: commonButtonLinearGridient),
                                        child: customText("Add Friend", 11, white),
                                      ):const SizedBox(),
                                    )
                                  ]),
                                ),
                              );
                            })
                        : Center(
                            child: customText("No data found!", 15, white),
                          );
                  })
            ],
          ),
        ),
      ),
    ));
  }
}
