import 'package:flutter/material.dart';
import 'package:music_room_app/friends/widgets/friends-section.dart';
import 'package:music_room_app/friends/widgets/search-section.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:music_room_app/home/widgets/drawer.dart';

import '../constant_colors.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);
  static const String routeName = '/friends';

  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appText: 'Friends', context: context),
      backgroundColor: backgroundColor,
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        SearchSection.create(context),
        FriendSection.create(context)
      ])),
    );
  }
}
