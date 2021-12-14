import 'package:flutter/material.dart';
import 'package:music_room_app/services/auth.dart';
//import 'package:music_room_app/views/component/custom_appbar.dart';
import 'package:music_room_app/views/login/login.dart';
import 'package:music_room_app/views/sign_in/sign_in_button.dart';
import 'package:music_room_app/views/sign_in/social_sign_in_button.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key, this.auth}) : super(key: key);
  final AuthBase? auth;

  Future<void> _signInWithEmailAndPassword(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      await auth!.signInWithGoogle();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      await auth!.signInWithFacebook();
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Music Room',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 2.0,
        backgroundColor: const Color(0XFF072BB8),
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    //double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text('Sign in',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 50,
                color: Color(0XFF072BB8),
                fontWeight: FontWeight.w700,
              )),
          SizedBox(height: screenHeight * 0.08),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: _signInWithGoogle,
          ),
          SizedBox(height: screenHeight * 0.02),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: const Color(0xFF334D92),
            onPressed: _signInWithFacebook,
          ),
          SizedBox(height: screenHeight * 0.02),
          SignInButton(
            text: 'Sign in with email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: () => _signInWithEmailAndPassword(context),
          ),
        ],
      ),
    );
  }
}
