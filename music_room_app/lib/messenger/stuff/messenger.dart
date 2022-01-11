import 'package:flutter/material.dart';

import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:music_room_app/messenger/stuff/recents_chats.dart';
import 'package:music_room_app/messenger/stuff/search.dart';

import 'package:music_room_app/widgets/custom_appbar.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({Key? key}) : super(key: key);

  static const String routeName = '/messenger';

  @override
  _MessengerScreenState createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  int index = 0;

  void switchIndex(newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appText: 'Messenger', context: context),
      backgroundColor: const Color(0xFFEFEFF4),
      drawer: const MyDrawer(),
      body: Column(
        children: <Widget>[
          index == 0 ? SearchFriends.create(context) : const RecentChats(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
        ],
        onTap: switchIndex,
      ),
    );
  }
}
