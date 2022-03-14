import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/messenger/models/user.dart';
import '../chat_page.dart';

class ChatBodyWidget extends StatelessWidget {
  final List<UserApp> users;

  const ChatBodyWidget({
    required this.users,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: buildChats(),
        ),
      );

  Widget buildChats() => ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final user = users[index];
          return SizedBox(
            height: 75,
            child: ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ChatPage(user: user),
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