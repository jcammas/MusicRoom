import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
<<<<<<< HEAD:music_room_app/lib/authentication/views/reset/old_reset.dart
import 'package:music_room_app/authentication/views/widgets/login_button.dart';
import 'package:music_room_app/widgets/constants.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';
=======
import 'package:music_room_app/views/component/login_signup_button.dart';
import 'package:music_room_app/views/component/show_exception_alert_dialog.dart';
import '../../../constants.dart';
>>>>>>> 3b4f21342eeafc989a2c37c2b37ac00625ebb210:music_room_app/lib/views/login/widgets/reset.dart

class OldReset extends StatefulWidget {
  const OldReset({Key? key}) : super(key: key);

  @override
  _OldResetState createState() => _OldResetState();
}

class _OldResetState extends State<OldReset> {
  final formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  late String _email;

  @override
  Widget build(BuildContext context) {
    double sizeHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Music Room'),
        elevation: 2.0,
        backgroundColor: const Color(0XFF072BB8),
      ),
      body: Form(
        key: formKey,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Hero(
                        tag: '1',
                        child: Text(
                          "Reset password",
                          style: TextStyle(
                              fontSize: 30,
                              color: Color(0XFF072BB8),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          _email = value.toString().trim();
                        },
                        validator: (value) =>
                        (value!.isEmpty) ? ' Please enter email' : null,
                        textAlign: TextAlign.center,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Your Email',
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Color(0XFF072BB8),
                          ),
                        ),
                      ),
                      SizedBox(height: sizeHeight * 0.05),
                      LoginButton(
                        title: 'Send request',
                        onPressed: () async {
                          try {
                            _auth.sendPasswordResetEmail(email: _email);
                          } on FirebaseAuthException catch (e) {
                            showExceptionAlertDialog(
                                context,
                                title: 'Reset failed',
                                exception : e
                            );
                          }
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Color(0XFF072BB8),
                              content: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    'An email has been set, please check your mail inbox to recover your password.',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                    textAlign: TextAlign.center),
                              ),
                              duration: Duration(seconds: 5),
                            ),
                          );
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
