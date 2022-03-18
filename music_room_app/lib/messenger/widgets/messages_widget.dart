import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/messenger/models/message.dart';
import '../../services/database.dart';
import 'message_widget.dart';

class MessagesWidget extends StatelessWidget {
  final UserApp currentUser;
  final UserApp interlocutor;
  final Database db;

  const MessagesWidget({
    required this.currentUser,
    required this.interlocutor,
    required this.db,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
        stream: db.chatMessagesStream(interlocutor),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return buildText('Something Went Wrong Try later');
              } else {
                final messages = snapshot.data;

                return messages!.isEmpty
                    ? buildText('Say Hi..')
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          bool isMe = message.senderId == currentUser.uid;
                          return MessageWidget(
                            message: message,
                            isMe: isMe,
                            avatar: isMe
                                ? currentUser.getAvatar()
                                : interlocutor.getAvatar(),
                          );
                        },
                      );
              }
          }
        },
      );

  Widget buildText(String text) => Center(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
      );
}
