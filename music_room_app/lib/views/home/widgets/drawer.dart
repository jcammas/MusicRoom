import 'package:flutter/material.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

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
          ListTile(
            leading: const Icon(
              Icons.account_circle_outlined,
              size: 36,
              color: Color(0XFF072BB8),
            ),
            title: const Text(
              'Mon compte',
              style: TextStyle(
                color: Color(0XFF434343),
                fontSize: 20,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              size: 36,
              color: Color(0XFF072BB8),
            ),
            title: const Text(
              'Déconnexion',
              style: TextStyle(
                color: Color(0XFF434343),
                fontSize: 20,
              ),
            ),
            onTap: () => _signOut(context),
          ),
        ],
      ),
    );
  }
}
