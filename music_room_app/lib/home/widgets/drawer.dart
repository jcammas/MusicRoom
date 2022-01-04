import 'package:flutter/material.dart';
import 'package:music_room_app/account/account.dart';
import 'package:music_room_app/home/widgets/drawer_tile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: const Text(
              'MusicRoom',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0XFF072BB8),
                  const Color(0XFF072BB8).withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          const DrawerTile(
              icon: Icons.add_business_outlined, text: 'Room', route: null),
          const DrawerTile(
              icon: Icons.music_note_outlined, text: 'Library', route: null),
          const DrawerTile(
              icon: Icons.accessibility_new_outlined,
              text: 'Friends',
              route: null),
          const DrawerTile(
              icon: Icons.account_circle_outlined,
              text: 'My account',
              route: AccountScreen.routeName),
        ],
      ),
    );
  }
}
