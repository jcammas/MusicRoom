import 'package:flutter/material.dart';
import 'package:music_room_app/views/component/custom_raised_button.dart';

class SignInButton extends CustomRaisedButton {
  SignInButton({
    String text = 'No Text',
    Color? color = Colors.red,
    Color textColor = Colors.white,
    required VoidCallback onPressed,
  }) : super(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: 15.0),
          ),
          color: color,
          onPressed: onPressed,
        );
}
