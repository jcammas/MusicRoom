import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/home/widgets/drawer.dart';

import 'package:music_room_app/widgets/custom_appbar.dart';

class MessengerScreen extends StatefulWidget {
  UserApp? user;
  MessengerScreen({Key? key}) : super(key: key);

  static const String routeName = '/messenger';

  @override
  _MessengerScreenState createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: customAppBar(appText: 'Messenger', context: context),
      backgroundColor: const Color(0xFFEFEFF4),
      drawer: const MyDrawer(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                  hintText: "type username",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          )
        ],
      ),
    );
  }
}
