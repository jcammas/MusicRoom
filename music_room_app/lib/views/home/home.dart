import 'package:flutter/material.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/views/home/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  @override
  _HomeScreenState createState() => _HomeScreenState();

  Future<void> _signOut() async {
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}


// final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class _HomeScreenState extends State<HomeScreen> {

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
          TextButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: widget._signOut,
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      drawer: MyDrawer(auth: widget.auth),
      body: Center(),
    );
  }
}
