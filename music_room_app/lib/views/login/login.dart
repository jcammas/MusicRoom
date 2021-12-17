import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/views/login/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Room'),
        elevation: 2.0,
        backgroundColor: const Color(0XFF072BB8),
      ),
      backgroundColor: Colors.grey[50],
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
          child: LoginForm(),
        ),
      ),
    );
  }
}
