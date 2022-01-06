import 'package:flutter/material.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/widgets/show_alert_dialog.dart';
import 'package:provider/provider.dart';

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
  String? currentRoute = ModalRoute.of(context)?.settings.name;
  if (currentRoute != '/') {
    Navigator.of(context).pop();
  }
}

AppBar customAppBar(
    {Key? key, required String appText, required BuildContext context}) {
  return AppBar(
    title: Text(appText,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        )),
    elevation: 2.0,
    backgroundColor: const Color(0XFF072BB8),
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
  );
}

AppBar customSignInAppBar({Key? key, required String appText}) {
  return AppBar(
    title: Text(appText,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        )),
    elevation: 2.0,
    backgroundColor: const Color(0XFF072BB8),
  );
}
