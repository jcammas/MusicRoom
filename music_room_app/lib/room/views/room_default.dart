import 'dart:io';
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

  // Future<void> showRoomDialog(BuildContext context, Widget form) {
  //   if (!Platform.isIOS) {
  //     return showDialog(
  //       context: context,
  //       builder: (context) =>
  //           SimpleDialog(
  //             content: form,
  //             actions: <Widget>[
  //               if (cancelActionText != null)
  //                 TextButton(
  //                   child: Text(cancelActionText),
  //                   onPressed: () => Navigator.of(context).pop(false),
  //                 ),
  //               TextButton(
  //                 child: Text(defaultActionText),
  //                 onPressed: () => Navigator.of(context).pop(true),
  //               ),
  //             ],
  //           ),
  //     );
  //   } else {
  //     return showCupertinoDialog(
  //       context: context,
  //       builder: (context) =>
  //           CupertinoAlertDialog(
  //             title: Text(title),
  //             content: content,
  //             actions: <Widget>[
  //               if (cancelActionText != null)
  //                 CupertinoDialogAction(
  //                   child: Text(cancelActionText),
  //                   onPressed: () => Navigator.of(context).pop(false),
  //                 ),
  //               CupertinoDialogAction(
  //                 child: Text(defaultActionText),
  //                 onPressed: () => Navigator.of(context).pop(true),
  //               ),
  //             ],
  //           ),
  //     );
  //   }
  // }

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
            onPressed: () {
              showBottomForm(context, CreateRoomForm.create(context));
            },
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
