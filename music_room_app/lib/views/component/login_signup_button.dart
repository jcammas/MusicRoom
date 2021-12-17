import 'package:flutter/material.dart';
import 'package:music_room_app/views/component/custom_raised_button.dart';

class LoginSignupButton extends CustomRaisedButton {
  LoginSignupButton({Key? key,
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
