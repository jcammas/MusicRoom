import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {Key? key, required this.icon, required this.text, required this.route})
      : super(key: key);
  final IconData icon;
  final String text;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 36,
        color: const Color(0XFF072BB8),
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Color(0XFF434343),
          fontSize: 20,
        ),
      ),
      onTap: () {
        if (route != null) {
          if (ModalRoute.of(context)?.settings.name == '/') {
            if (route != '/') {
              Navigator.of(context).pushNamed(route!);
            }
          } else {
            Navigator.of(context).pushReplacementNamed(route!);
          }
        }
      },
    );
  }
}
