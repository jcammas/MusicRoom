import 'package:flutter/material.dart';
import 'package:music_room_app/room/managers/room_manager.dart';
import 'package:music_room_app/services/database.dart';
import 'package:provider/provider.dart';

class RoomForm extends StatefulWidget {
  const RoomForm({Key? key, required this.manager}) : super(key: key);
  final RoomManager manager;

  static Widget create(BuildContext context, {required Database db, required String roomId}) {
    return ChangeNotifierProvider<RoomManager>(
      create: (_) => RoomManager(db: db, roomId: roomId),
      child: Consumer<RoomManager>(
        builder: (_, model, __) => RoomForm(manager: model),
      ),
    );
  }

  @override
  State<RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  late Map<String, dynamic> settingsData;

  @override
  Widget build(BuildContext context) {
    // final double screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
          child: Center(),
        );
      }
}
