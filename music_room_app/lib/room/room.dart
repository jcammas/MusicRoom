import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/room/managers/join_manager.dart';
import 'package:music_room_app/room/views/room_form.dart';
import 'package:music_room_app/room/views/room_join.dart';
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
    return Scaffold(
      appBar: customAppBar(
        appText: 'Room',
        context: context,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: const MyDrawer(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: _buildContents(context)),
    );
  }

  Widget _buildContents(BuildContext context) {
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
            return RoomJoin(manager: JoinManager(db: db));
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