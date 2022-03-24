import 'package:flutter/material.dart';
import 'package:music_room_app/widgets/custom_raised_button.dart';

class RoomButton extends CustomRaisedButton {
  RoomButton({
    Key? key,
    String text = 'No Text',
    required Color color,
    Color textColor = Colors.white,
    required VoidCallback? onPressed,
  }) : super(
          key: key,
          child: Text(
            text,
            style: TextStyle(
                color: textColor, fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          color: color,
          borderRadius: 10,
          height: 70,
          width: 100,
          onPressed: onPressed,
        );
}