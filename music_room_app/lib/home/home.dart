import 'package:flutter/material.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:music_room_app/services/auth.dart';
import 'models/user.dart';
import 'widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _setUpUser(BuildContext context, AuthBase auth) async {
    final db = Provider.of<Database>(context, listen: false);
    final bool exist = await db.userExists();
    if (auth.currentUser != null) {
      if (!exist) {
        db.set(UserApp(
          name: auth.currentUser!.displayName ?? 'N/A',
          email: auth.currentUser!.email ?? 'N/A',
          uid: auth.currentUser!.uid,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    _setUpUser(context, auth);
    return Scaffold(
      appBar: customAppBar(appText: 'Music Room', context: context),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: const MyDrawer(),
      body: const Center(),
    );
  }
}
