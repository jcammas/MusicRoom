import 'package:flutter/material.dart';

import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:music_room_app/messenger/widgets/search.dart';

import 'package:music_room_app/widgets/custom_appbar.dart';

class MessengerScreen extends StatefulWidget {
  MessengerScreen({Key? key}) : super(key: key);

  static const String routeName = '/messenger';

  @override
  _MessengerScreenState createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appText: 'Messenger', context: context),
      backgroundColor: const Color(0xFFEFEFF4),
      drawer: const MyDrawer(),
      body: Column(
        children: <Widget>[
          SearchFriends.create(context),
        ],
      ),
    );
  }
}
