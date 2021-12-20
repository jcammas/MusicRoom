import 'package:flutter/material.dart';
import 'package:music_room_app/widgets/custom_raised_button.dart';

class LoginButton extends CustomRaisedButton {
  LoginButton({Key? key,
    required String title,
    required VoidCallback? onPressed,
  }) : super(key: key,
    child: Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 20.0),
    ),
    height: 44.0,
    color: const Color(0XFF072BB8),
    width: double.infinity,
    borderRadius: 4.0,
    onPressed: onPressed,
  );
}
