import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/widgets/show_alert_dialog.dart';
import 'widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();

  Future<void> _confirmSignOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    );
    if (didRequestSignOut == true) {
      auth.signOut();
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
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
            onPressed: () => widget._confirmSignOut(context),
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      drawer: const MyDrawer(),
      body: const Center(),
    );
  }
}
