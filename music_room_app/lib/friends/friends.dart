import 'package:flutter/material.dart';
import 'package:music_room_app/friends/services/friend-links-manager.dart';
import 'package:music_room_app/friends/widgets/friend-card.dart';
import 'package:music_room_app/friends/widgets/friends-section.dart';
import 'package:music_room_app/friends/widgets/search-section.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:provider/provider.dart';

import '../constant_colors.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);
  static const String routeName = '/friends';

  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendsScreen> {
  _showBottomModal(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.9,
        maxHeight: MediaQuery.of(context).size.height * 0.68,
      ),
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (builder) {
        return StatefulBuilder(
          builder: (context, StateSetter setState) {
            var friendLinksManager = context.watch<FriendLinksManagerService>();

            return Container(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius:
                          10.0, // has the effect of softening the shadow
                      spreadRadius:
                          0.0, // has the effect of extending the shadow
                    )
                  ],
                ),
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: [
                              const Icon(Icons.sort_rounded,
                                  size: 30, color: Color(0XFF434343)),
                              SizedBox(
                                width: screenWidth * 0.02,
                              ),
                              Text(
                                "pending".toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0XFF434343)),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              margin: const EdgeInsets.only(top: 5, right: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 2,
                                      color: const Color(0XFFDDDDDD))),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: screenHeight * 0.003,
                                      bottom: screenHeight * 0.003,
                                      left: screenWidth * 0.01,
                                      right: screenWidth * 0.01),
                                  child: const Icon(Icons.close,
                                      color: Color(0xFF434343), size: 25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: friendLinksManager.pendingLinks.map((e) {
                          return FriendCard(e, true);
                        }).toList(),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    var friendLinksManager = context.watch<FriendLinksManagerService>();
    var count = friendLinksManager.pendingLinks.length;
    return Scaffold(
      appBar: customAppBar(appText: 'Friends', context: context),
      backgroundColor: backgroundColor,
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SearchSection(),
            FriendSection(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showBottomModal(context);
        },
        child: Stack(
          children: <Widget>[
            Icon(
              Icons.notifications,
            ),
            count != 0
                ? Positioned(
                    right: 11,
                    top: 11,
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 0,
                        minHeight: 0,
                      ),
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
