import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customSignInAppBar(appText: 'Music Room', context: context),
      backgroundColor: Theme.of(context).backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
          child: LoginForm.create(context),
        ),
      ),
    );
  }
}
