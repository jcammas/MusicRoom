import 'package:flutter/material.dart';
import 'package:music_room_app/room/views/choose_forms.dart';
import 'package:music_room_app/widgets/custom_text_field.dart';
import 'package:music_room_app/widgets/show_alert_dialog.dart';
import 'package:provider/provider.dart';
import '../../constant_colors.dart';
import '../../home/models/playlist.dart';
import '../../services/database.dart';
import '../../services/spotify_web.dart';
import '../../widgets/show_exception_alert_dialog.dart';
import '../managers/choose_form_manager.dart';

class CreateRoomForm extends StatefulWidget {
  CreateRoomForm({required this.manager});

  final CreateRoomManager manager;

  @override
  State<CreateRoomForm> createState() => _CreateRoomFormState();

  static Widget create(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final spotify = Provider.of<SpotifyWebService>(context, listen: false);
    return ChangeNotifierProvider<CreateRoomManager>(
      create: (_) => CreateRoomManager(db: db, spotify: spotify),
      child: Consumer<CreateRoomManager>(
        builder: (_, manager, __) => CreateRoomForm(manager: manager),
      ),
    );
  }
}

class _CreateRoomFormState extends State<CreateRoomForm> {
  CreateRoomManager get manager => widget.manager;

  Playlist? get playlist => manager.selectedPlaylist;

  void _submit(BuildContext context) async {
    try {
      bool success = await manager.createRoom(context);
      if (success) {
        Navigator.pop(context);
      } else {
        await showAlertDialog(context,
            title: 'Error',
            content: const Text(
                'Could not load event. Check name and playlist and try again.'),
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
        child:  Column(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back)),
              ),
              CustomTextField(
                title: "Event name :",
                onFieldSubmitted: manager.updateName,
              ),
              SizedBox(
                height: height * 0.04,
              ),
              ListTile(
                title: playlist == null
                    ? Text('Choose a playlist')
                    : Text(playlist!.name),
                trailing: const Icon(Icons.chevron_right),
                leading: playlist == null
                    ? Padding(padding: EdgeInsets.only(left: width * 0.17))
                    : playlist!.returnImage(),
                onTap: () => ChoosePlaylistForm.show(context, widget.manager),
              ),
              SizedBox(
                height: height * 0.05,
              ),
              manager.isLoading ? const Center(child: CircularProgressIndicator()) : ElevatedButton(
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
                  onPressed: manager.isReady()
                      ? () => _submit(context) : () {},
                  child: Text(
                    "Create !",
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
