import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/messenger/widgets/profile_header_widget.dart';
import '../services/database.dart';
import 'widgets/messages_widget.dart';
import 'widgets/new_message_widget.dart';
import 'widgets/profile_header_widget.dart';

class ChatPage extends StatefulWidget {
  final UserApp interlocutor;
  final UserApp currentUser;
  final Database db;

  const ChatPage({
    required this.interlocutor,
    required this.currentUser,
    required this.db,
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.blue[900],
        body: SafeArea(
          child: Column(
            children: [
              ProfileHeaderWidget(name: widget.interlocutor.name),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  child: MessagesWidget(
                    currentUser: widget.currentUser,
                    interlocutor: widget.interlocutor,
                    db: widget.db,
                  ),
                ),
              ),
              NewMessageWidget(
                currentUser: widget.currentUser,
                interlocutor: widget.interlocutor,
                db: widget.db,
              )
            ],
          ),
        ),
      );
}
