import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:music_room_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/widgets/show_alert_dialog.dart';

import 'account_form.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  static const String routeName = '/home/account';

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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final String uid = ModalRoute.of(context)?.settings.arguments as String;
    return Provider<Database>(
      create: (_) => FirestoreDatabase(uid: uid),
      child: Scaffold(
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
              onPressed: () => _confirmSignOut(context),
            ),
          ],
        ),
        backgroundColor: Colors.grey[200],
        drawer: const MyDrawer(),
        body: const AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 120),
            child: AccountForm(),
          ),
        ),
      ),
    );
  }
}
