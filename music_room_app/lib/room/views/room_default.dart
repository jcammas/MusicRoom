import 'package:flutter/material.dart';
import 'package:music_room_app/room/managers/room_default_manager.dart';
import 'package:music_room_app/room/widgets/room_button.dart';
import '../managers/room_default_manager.dart';
import 'create_room_form.dart';

class RoomDefault extends StatelessWidget {
  RoomDefault({Key? key, required this.manager}) : super(key: key);

  final RoomDefaultManager manager;

  Future<void> showBottomForm(BuildContext context, Widget form) async {
    await showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
          maxWidth: MediaQuery
              .of(context)
              .size
              .width * 0.9,
          maxHeight: MediaQuery
              .of(context)
              .size
              .height * 0.9,
          minHeight: MediaQuery
              .of(context)
              .size
              .height * 0.8,
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return form;
        });
  }

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
            color: Theme.of(context).primaryColor,
            text: 'Create',
            onPressed: () {
              showBottomForm(context, CreateRoomForm.create(context));
            },
          ),
          RoomButton(
            color: Theme.of(context).primaryColor,
            text: 'Join',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}
