import 'package:flutter/material.dart';
import 'package:music_room_app/account/account.dart';
import 'package:music_room_app/home/widgets/drawer_tile.dart';
import 'package:music_room_app/landing.dart';
import 'package:music_room_app/spotify_library/library.dart';
import 'package:music_room_app/spotify_library/spotify_connection_monitor.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          if (ModalRoute.of(context)!.settings.name != LandingScreen.routeName)
            const DrawerHeader(
              margin: EdgeInsets.all(0),
              child: DrawerTile(
                  icon: Icons.home_outlined,
                  text: 'Home',
                  route: LandingScreen.routeName),
            ),
          const DrawerTile(
              icon: Icons.add_business_outlined, text: 'Room', route: null),
          const DrawerTile(
              icon: Icons.music_note_outlined,
              text: 'Library',
              // route: LibraryScreen.routeName),
              route: LibraryScreen.routeName),
          const DrawerTile(
              icon: Icons.settings_input_antenna,
              text: 'Spotify Connection Monitor (temporary)',
              // route: LibraryScreen.routeName),
              route: SpotifyConnectionMonitor.routeName),
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
