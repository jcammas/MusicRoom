import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/views/component/show_alert_dialog.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  late User user;
  late Timer timer;
  int count = 0;

  @override
  void initState() {
    user = widget.auth.currentUser!;
    user.sendEmailVerification();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Room'),
        elevation: 2.0,
        backgroundColor: Color(0XFF072BB8),
      ),
      backgroundColor: Colors.grey[50],
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> checkEmailVerified() async {
    user = widget.auth.currentUser!;
    count += 1;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      await showAlertDialog(context,
          title: 'Sent !',
          content: 'An email has been sent to you',
          defaultActionText: 'Ok');
      Navigator.of(context).pop();
    } else if (count > 4) {
      timer.cancel();
      await showAlertDialog(context,
          title: 'Failed !',
          content: 'Could not sent a mail to you',
          defaultActionText: 'Ok');
      Navigator.of(context).pop();
    }
  }
}
