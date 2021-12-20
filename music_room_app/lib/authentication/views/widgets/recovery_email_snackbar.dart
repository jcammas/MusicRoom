import 'package:flutter/material.dart';

class RecoveryEmailSnackBar extends SnackBar {
  const RecoveryEmailSnackBar({
    Key? key,
  }) : super(
          key: key,
          backgroundColor: const Color(0XFF072BB8),
          content: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'An email has been sent, please check your mail inbox to recover your password.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
          ),
          duration: const Duration(seconds: 5),
        );
}
