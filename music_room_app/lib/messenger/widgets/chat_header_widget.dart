import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:provider/provider.dart';
import '../../services/database.dart';
import '../chat_page.dart';

class ChatHeaderWidget extends StatelessWidget {
  final List<UserApp> users;
  final UserApp currentUser;

  const ChatHeaderWidget({
    required this.users,
    required this.currentUser,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                if (index == 0) {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: const CircleAvatar(
                      radius: 24,
                      child: Icon(Icons.search),
                    ),
                  );
                } else {
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ChatPage(
                              interlocutor: user,
                              currentUser: currentUser,
                              db: db),
                        ));
                      },
                      child: const CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage('images/avatar_random.png'),
                      ),
                    ),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
