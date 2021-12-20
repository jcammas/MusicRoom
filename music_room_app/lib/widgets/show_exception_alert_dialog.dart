import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/views/component/show_alert_dialog.dart';

Future<void> showExceptionAlertDialog(
  BuildContext context, {
  required String title,
  required Exception exception,
}) =>
    showAlertDialog(
      context,
      title: title,
      content: _message(exception),
      defaultActionText: 'OK',
    );

String _message(Exception exception) {

  if (exception is FirebaseException) {
    return exception.message != null ? exception.message! : "No content";
  }
  return exception.toString();
}