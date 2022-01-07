import 'package:flutter/material.dart';
import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:music_room_app/messenger/widgets/category_selector.dart';
import 'package:music_room_app/messenger/widgets/favorite.dart';
import 'package:music_room_app/messenger/widgets/recents_chats.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';

class MessengerScreen extends StatefulWidget {
  const MessengerScreen({Key? key}) : super(key: key);

  static const String routeName = '/messenger';

  @override
  _MessengerScreenState createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: customAppBar(appText: 'Messenger', context: context),
        backgroundColor: const Color(0xFFEFEFF4),
        drawer: const MyDrawer(),
        body: Column(
          children: <Widget>[
            const CategorySelector(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: const <Widget>[
                    Favorite(),
                    RecentChats(),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
