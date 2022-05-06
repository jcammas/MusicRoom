import 'package:flutter/material.dart';
import 'package:music_room_app/account/account.dart';
import 'package:music_room_app/friends/friends.dart';
import 'package:music_room_app/home/widgets/info_card.dart';
import 'package:music_room_app/messenger/chats_page.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/spotify_library/library/library.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:music_room_app/services/auth.dart';
import '../constant_colors.dart';
import '../room/room_screen.dart';
import 'models/user.dart';
import 'widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _setUpUser(BuildContext context, AuthBase auth) async {
    final db = Provider.of<Database>(context, listen: false);
    final bool exist = await db.userExists();
    if (auth.currentUser != null) {
      if (!exist) {
        db.set(UserApp(
          name: auth.currentUser!.displayName ?? 'N/A',
          email: auth.currentUser!.email ?? 'N/A',
          uid: auth.currentUser!.uid,
          avatarUrl: auth.currentUser!.photoURL ?? defaultAvatarUrl,
        ));
      } else {
        //On setup l'utilisateur courant dans la db pour uniformiser la base.
        final current = await db.getUserById(auth.currentUser!.uid);
        db.set(current);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    _setUpUser(context, auth);
    return Scaffold(
      appBar: customAppBar(appText: 'Music Room', context: context),
      backgroundColor: backgroundColor,
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Wrap(
          spacing: 10,
          alignment: WrapAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 25.0, bottom: 25.0),
                child: Text(
                  "Welcome Home ${auth.currentUser!.displayName}",
                  style: TextStyle(
                    color: Color(0XFF434343),
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            InfoCard(
              cardName: "Room",
              icon: Icons.add_business_outlined,
              route: RoomScreen.routeName,
            ),
            InfoCard(
              cardName: "Library",
              icon: Icons.music_note_outlined,
              route: LibraryScreen.routeName,
            ),
            InfoCard(
              cardName: "Friends",
              icon: Icons.accessibility_new_outlined,
              route: FriendsScreen.routeName,
            ),
            InfoCard(
              cardName: "Messenger",
              icon: Icons.chat,
              route: ChatsPage.routeName,
            ),
            InfoCard(
              cardName: "${auth.currentUser!.displayName}",
              icon: Icons.account_circle_outlined,
              route: AccountScreen.routeName,
            ),
            SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
