import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/room/views/room_form.dart';
import 'package:music_room_app/room/views/room_default.dart';
import 'package:provider/provider.dart';
import '../constant_colors.dart';
import '../home/models/user.dart';
import '../home/widgets/drawer.dart';
import '../services/database.dart';
import '../widgets/custom_appbar.dart';
import 'managers/room_scaffold_manager.dart';

class RoomScreen extends StatelessWidget {
  static const String routeName = '/room';

  const RoomScreen({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider<RoomScaffoldManager>(
      create: (_) => RoomScaffoldManager('Room'),
      child: const RoomScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final manager = Provider.of<RoomScaffoldManager>(context, listen: false);
    return Scaffold(
      appBar: roomAppBar(context: context),
      backgroundColor: backgroundColor,
      drawer: const MyDrawer(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: StreamBuilder<UserApp?>(
          stream: db.userStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              final UserApp? user = snapshot.data;
              if (user != null) {
                if (user.roomId != null) {
                  return RoomForm(roomId: user.roomId!, db: db);
                }
                return RoomDefault(scaffoldManager: manager);
              }
            }
            return Center(
              // child: CircularProgressIndicator(),
              child: CircularProgressIndicator(color: Colors.black87),
            );
          },
        ),
      ),
    );
  }
}
