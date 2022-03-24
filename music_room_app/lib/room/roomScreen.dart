import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/room/views/room_form.dart';
import 'package:music_room_app/room/views/room_default.dart';
import 'package:provider/provider.dart';
import '../home/models/user.dart';
import '../home/widgets/drawer.dart';
import '../services/database.dart';
import '../widgets/custom_appbar.dart';

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
            if (user.roomId != null) {
              return RoomForm(roomId: user.roomId!, db: db);
            }
            return RoomDefault();
          }
        }
        return Scaffold(
          appBar: customAppBar(
            appText: 'Room',
            context: context,
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          drawer: const MyDrawer(),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Center(
              // child: CircularProgressIndicator(),
              child: CircularProgressIndicator(color: Colors.black87),
            ),
          ),
        );
      },
    );
  }
}
