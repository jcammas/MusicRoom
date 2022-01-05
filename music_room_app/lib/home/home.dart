import 'package:flutter/material.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/widgets/show_alert_dialog.dart';
import 'models/user.dart';
import 'widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();

  Future<void> _confirmSignOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);

    final didRequestSignOut = await showAlertDialog(
      context,
      title: 'Logout',
      content: const Text('Are you sure that you want to logout?'),
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
  Future<void> _setUpUser(BuildContext context, AuthBase auth) async {
    final db = Provider.of<Database>(context, listen: false);
    final bool exist = await db.currentUserExists();
    if (auth.currentUser != null) {
      if (!exist) {
        db.setUser(UserApp(
            name: auth.currentUser!.displayName ?? 'N/A',
            email: auth.currentUser!.email ?? 'N/A',
            uid: auth.currentUser!.uid));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    _setUpUser(context, auth);
    return Scaffold(
      appBar: customAppBar(appText: 'Music Room', context: context),
      backgroundColor: Colors.grey[200],
      drawer: const MyDrawer(),
      body: const Center(),
    );
  }
}
