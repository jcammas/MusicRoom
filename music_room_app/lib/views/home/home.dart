import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/views/home/widgets/drawer.dart';
import 'package:music_room_app/views/login/login.dart';
//import 'package:music_room_app/views/sign_in/sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);
  // final AuthBase auth;

  @override
  _HomeScreenState createState() => _HomeScreenState();

  // Future<void> _signOut(BuildContext context) async {
  //   try {
  //     await auth.signOut();
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e.toString());
  //   }
  // }
}

// final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF072BB8),
        title: const Text(
          "MusicRoom",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: <Widget>[
          // TextButton(
          //     child: const Text(
          //       'Logout',
          //       style: TextStyle(
          //         fontSize: 18.0,
          //         color: Colors.white,
          //       ),
          //     ),
          //     onPressed: () {
          //       auth.signOut();
          //       Navigator.of(context).pushReplacement(
          //           MaterialPageRoute(builder: (context) => LoginScreen()));
          //     }
          //     //() => widget._signOut(context),
          //     ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      drawer: MyDrawer(),
      body: const Center(),
    );
  }
}
