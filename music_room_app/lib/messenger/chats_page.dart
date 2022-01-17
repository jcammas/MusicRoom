import 'package:music_room_app/messenger/api/firebase_api.dart';
import 'package:flutter/material.dart';
import 'models/user.dart';
import 'widgets/chat_body_widget.dart';
import 'widgets/chat_header_widget.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  static const String routeName = '/chatsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: StreamBuilder<List<User>>(
          stream: FirebaseApi.getUsers(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  // ignore: avoid_print
                  print(snapshot.error);
                  return const Text('Something Went Wrong Try later');
                } else {
                  final users = snapshot.data;

                  if (users!.isEmpty) {
                    return const Text('No Users Found');
                  } else {
                    return Column(
                      children: [
                        ChatHeaderWidget(users: users),
                        ChatBodyWidget(users: users)
                      ],
                    );
                  }
                }
            }
          },
        ),
      ),
    );
  }
}
