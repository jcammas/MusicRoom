import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:provider/provider.dart';
import '../../services/database.dart';
import '../chat_page.dart';

class ChatBodyWidget extends StatelessWidget {
  final List<UserApp> users;
  final UserApp currentUser;

  const ChatBodyWidget({
    required this.users,
    required this.currentUser,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: buildChats(db),
      ),
    );
  }

  Widget buildChats(Database db) => ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final user = users[index];
          return SizedBox(
            height: 75,
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatPage(
                      interlocutor: user, currentUser: currentUser, db: db),
                ));
              },
              leading: const CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage("images/avatar_random.png"),
              ),
              title: Text(user.name),
            ),
          );
        },
        itemCount: users.length,
      );
}
