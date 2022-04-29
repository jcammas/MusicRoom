import 'package:flutter/material.dart';
import 'package:music_room_app/room/managers/room_scaffold_manager.dart';
import 'package:music_room_app/room/widgets/room_button.dart';
import '../../constant_colors.dart';
import 'create_room_form.dart';
import 'join_room_form.dart';

Future<void> showBottomForm(BuildContext context, Widget form) async {
  await showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.9,
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        minHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return form;
      });
}

class RoomDefault extends StatelessWidget {
  RoomDefault({required this.scaffoldManager});

  final RoomScaffoldManager scaffoldManager;

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, scaffoldManager.resetScaffold);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          RoomButton(
            color: primaryColor,
            text: 'Create',
            onPressed: () {
              showBottomForm(context, CreateRoomForm.create(context));
            },
          ),
          RoomButton(
            color: primaryColor,
            text: 'Join',
            onPressed: () {
              showBottomForm(context, JoinRoomForm.create(context));
            },
          ),
        ],
      ),
    );
  }
}
