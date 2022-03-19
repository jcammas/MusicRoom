import 'package:flutter/material.dart';
import 'package:music_room_app/services/database.dart';


class RoomJoin extends StatelessWidget {
  RoomJoin({Key? key, required this.db}) : super(key: key);

  final Database db;

  @override
  Widget build(BuildContext context) {
    // final double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Center(),
    );
  }
}
