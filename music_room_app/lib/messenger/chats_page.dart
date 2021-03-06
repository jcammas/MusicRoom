import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'widgets/chat_body_widget.dart';
import 'widgets/chat_header_widget.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  static const String routeName = '/chatsPage';

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: customAppBar(appText: "Messenger", context: context),
      drawer: MyDrawer(),
      body: SafeArea(
        child: FutureBuilder<List<UserApp>>(
          future: db.getUsers(),
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
                    final currentUser =
                        users.firstWhere((user) => user.uid == db.uid);
                    users.removeWhere((user) => user.uid == db.uid);
                    return Column(
                      children: [
                        ChatHeaderWidget(
                            users: users, currentUser: currentUser),
                        ChatBodyWidget(users: users, currentUser: currentUser)
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
