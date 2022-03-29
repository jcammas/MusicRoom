import 'package:flutter/material.dart';

import '../../constant_colors.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {Key? key, required this.icon, required this.text, required this.route})
      : super(key: key);
  final IconData icon;
  final String text;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        if (route != null) {
          String? currentRoute = ModalRoute.of(context)?.settings.name;
          if (currentRoute == '/') {
            if (route != '/') {
              Navigator.of(context).pushNamed(route!);
            }
          } else {
            if (route == '/') Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed(route!);
          }
        }
      },
      icon: Icon(
        icon,
        color: primaryColor,
      ),
      label: Text(text),
    );
  }
}
