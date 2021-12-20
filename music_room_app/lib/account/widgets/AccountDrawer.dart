import 'package:flutter/material.dart';
import 'package:music_room_app/home/home.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:provider/provider.dart';

class AccountDrawer extends StatelessWidget {
  const AccountDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

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
              'Home',
              style: TextStyle(
                color: Color(0XFF434343),
                fontSize: 20,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, HomeScreen.routeName);
            },
          ),
        ],
      ),
    );
  }
}
