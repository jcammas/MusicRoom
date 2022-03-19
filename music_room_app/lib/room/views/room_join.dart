import 'package:flutter/material.dart';
import 'package:music_room_app/room/managers/join_manager.dart';
import 'package:music_room_app/room/widgets/room_button.dart';
import '../managers/join_manager.dart';

class RoomJoin extends StatelessWidget {
  RoomJoin({Key? key, required this.manager}) : super(key: key);

  final JoinManager manager;

  @override
  Widget build(BuildContext context) {
    // final double screenHeight = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RoomButton(
            text: 'Create',
            onPressed: null,
          ),
          RoomButton(
            text: 'Join',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
