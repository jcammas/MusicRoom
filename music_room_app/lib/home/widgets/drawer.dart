import 'package:flutter/material.dart';
import 'package:music_room_app/account/account.dart';
import 'package:music_room_app/friends/friends.dart';
import 'package:music_room_app/home/widgets/drawer_tile.dart';
import 'package:music_room_app/landing.dart';
import 'package:music_room_app/messenger/messenger.dart';
import 'package:music_room_app/spotify_library/library/library.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: SizedBox(
              child: Image.asset("assets/image/music.jpg"),
            ),
            decoration:
                BoxDecoration(color: Theme.of(context).secondaryHeaderColor),
          ),
          if (ModalRoute.of(context)!.settings.name != LandingScreen.routeName)
            const DrawerTile(
                icon: Icons.home_outlined,
                text: 'Home',
                route: LandingScreen.routeName),
          const DrawerTile(
              icon: Icons.add_business_outlined, text: 'Room', route: null),
          const DrawerTile(
              icon: Icons.music_note_outlined,
              text: 'Library',
              // route: LibraryScreen.routeName),
              route: LibraryScreen.routeName),
          const DrawerTile(
              icon: Icons.accessibility_new_outlined,
              text: 'Friends',
              route: FriendsScreen.routeName),
          const DrawerTile(
              icon: Icons.account_circle_outlined,
              text: 'My account',
              route: AccountScreen.routeName),
          const DrawerTile(
            icon: Icons.chat,
            text: "Messenger",
            route: MessengerScreen.routeName,
          )
        ],
      ),
    );
  }
}
