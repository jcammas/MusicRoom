import 'package:flutter/material.dart';
import 'package:music_room_app/room/managers/room_manager.dart';
import 'package:music_room_app/room/views/choose_forms.dart';
import 'package:music_room_app/widgets/show_alert_dialog.dart';
import 'package:provider/provider.dart';
import '../../constant_colors.dart';
import '../../home/models/track.dart';
import '../../services/database.dart';
import '../../widgets/show_exception_alert_dialog.dart';
import '../managers/choose_form_manager.dart';

class AddTrackForm extends StatefulWidget {
  AddTrackForm({required this.manager});

  final AddTrackManager manager;

  @override
  State<AddTrackForm> createState() => _AddTrackFormState();

  static Widget create(BuildContext context, RoomPlaylistManager roomManager) {
    final db = Provider.of<Database>(context, listen: false);
    return ChangeNotifierProvider<AddTrackManager>(
      create: (_) => AddTrackManager(db: db, roomManager: roomManager),
      child: Consumer<AddTrackManager>(
        builder: (_, manager, __) => AddTrackForm(manager: manager),
      ),
    );
  }
}

class _AddTrackFormState extends State<AddTrackForm> {
  AddTrackManager get manager => widget.manager;
  TrackApp? get track => manager.selectedTrack;

  void _submit(BuildContext context) async {
    try {
      bool success = await manager.addTrack(context);
      if (success) {
        Navigator.pop(context);
      } else {
        await showAlertDialog(context,
            title: 'Error',
            content: const Text('Could not add track.'),
            defaultActionText: 'Ok');
      }
    } on Exception catch (e) {
      await showExceptionAlertDialog(context, title: 'ERROR', exception: e);
    }
  }

  @override
  Widget build(context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
            SizedBox(
              height: height * 0.04,
            ),
            ListTile(
              title: track == null ? Text('Choose a track') : Text(track!.name),
              trailing: const Icon(Icons.chevron_right),
              leading: track == null
                  ? Padding(padding: EdgeInsets.only(left: width * 0.17))
                  : track!.returnImage(),
              onTap: () => ChoosePlaylistForm.show(context, manager),
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
                      "Add !",
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
