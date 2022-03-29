import 'package:flutter/material.dart';
import 'package:music_room_app/widgets/search-bar.dart';
import 'package:music_room_app/widgets/show_alert_dialog.dart';
import 'package:provider/provider.dart';
import '../../constant_colors.dart';
import '../../home/models/room.dart';
import '../../services/database.dart';
import '../../widgets/show_exception_alert_dialog.dart';
import '../managers/join_room_manager.dart';
import '../widgets/tiles.dart';

class JoinRoomForm extends StatefulWidget {
  JoinRoomForm({required this.manager});

  final JoinRoomManager manager;

  @override
  State<JoinRoomForm> createState() => _JoinRoomFormState();

  static Widget create(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return ChangeNotifierProvider<JoinRoomManager>(
      create: (_) => JoinRoomManager(db: db),
      child: Consumer<JoinRoomManager>(
        builder: (_, manager, __) => JoinRoomForm(manager: manager),
      ),
    );
  }
}

class _JoinRoomFormState extends State<JoinRoomForm> {
  JoinRoomManager get manager => widget.manager;

  Room? get selectedRoom => manager.selectedRoom;

  void _submit(BuildContext context) async {
    try {
      bool success = await manager.joinRoom(context);
      if (success) {
        Navigator.pop(context);
      } else {
        await showAlertDialog(context,
            title: 'Error',
            content: const Text('Could not load event. Try again.'),
            defaultActionText: 'Ok');
      }
    } on Exception catch (e) {
      await showExceptionAlertDialog(context, title: 'ERROR', exception: e);
    }
  }

  @override
  Widget build(context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back)),
            ),
            SearchBar(
                getItemList: manager.getRooms, onSelected: manager.selectRoom),
            SizedBox(
              height: height * 0.04,
            ),
            selectedRoom == null
                ? SizedBox(
                    height: height * 0.03,
                  )
                : RoomTile(
                    room: selectedRoom!,
                    onTap: () => {},
                  ),
            SizedBox(
              height: height * 0.05,
            ),
            manager.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        manager.isReady()
                            ? primaryColor
                            : const Color(0XFF434343),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    onPressed:
                        manager.isReady() ? () => _submit(context) : () {},
                    child: Text(
                      "Join !",
                    )),
            SizedBox(
              height: height * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
