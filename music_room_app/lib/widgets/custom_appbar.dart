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
    String? currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute != '/') {
      Navigator.of(context).pop();
    }
  }
}

PreferredSize customAppBar(
    {Key? key,
    required String appText,
    required BuildContext context,
    Future<void> Function(BuildContext context)? topRight,
    String? funcText}) {
  return PreferredSize(
      child: Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor,
                offset: Offset(0, 5.0),
                blurRadius: 6.0,
                spreadRadius: 1.0),
          ]),
          child: AppBar(
            title: Text(appText, style: Theme.of(context).textTheme.headline1),
            elevation: 2.0,
            backgroundColor: Theme.of(context).primaryColor,
            actions: <Widget>[
              TextButton(
                child: Text(funcText ?? 'Logout',
                    style: Theme.of(context).textTheme.headline6),
                onPressed: () => topRight != null
                    ? topRight(context)
                    : _confirmSignOut(context),
              ),
            ],
          )),
      preferredSize: Size.fromHeight(50));
}

AppBar customSignInAppBar({
  Key? key,
  required String appText,
  required BuildContext context,
  Future<void> Function(BuildContext context)? topRight,
}) {
  return AppBar(
    title: Text(appText, style: Theme.of(context).textTheme.headline1),
    elevation: 2.0,
    backgroundColor: Theme.of(context).primaryColor,
  );
}
