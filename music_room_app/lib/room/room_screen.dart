import 'package:flutter/material.dart';
import 'package:music_room_app/room/room_form.dart';
import 'package:music_room_app/room/room_join.dart';
import 'package:provider/provider.dart';
import '../home/models/user.dart';
import '../services/database.dart';

class RoomScreen extends StatelessWidget {
  const RoomScreen({Key? key}) : super(key: key);

  static const String routeName = '/room';

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return StreamBuilder<UserApp?>(
      stream: db.userStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final UserApp? user = snapshot.data;
          if (user != null) {
            if (user.room != null)
            {
              return RoomForm.create(context, roomId: user.room!, db: db);
            }
            return RoomJoin(db: db);
          }
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}