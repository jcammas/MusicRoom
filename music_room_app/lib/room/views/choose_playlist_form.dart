import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/spotify_library/widgets/list_items_builder.dart';
import 'package:music_room_app/spotify_library/widgets/list_items_manager.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class ChoosePlaylistForm extends StatelessWidget {
  const ChoosePlaylistForm(
      {Key? key,
        required this.db})
      : super(key: key);
  final Database db;

  static Future<void> show(BuildContext context, Playlist playlist) async {
    final db = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => ChoosePlaylistForm(
            db: db),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              appBar: customAppBar(
                  appText: 'Choose a playlist',
                  context: context,
                  funcText: '',
                  topRight: (context) async {}),
              backgroundColor: Theme.of(context).backgroundColor,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: Center()
                  // child: _buildContents(context),
              ),
    );
  }

//   Widget _buildContents(BuildContext context) {
//     return StreamBuilder<List<Playlist>>(
//       stream: db.userPlaylistsStream(),
//       builder: (context, snapshot) {
//         return ListItemsBuilder<Playlist>(
//               manager: ,
//               snapshot: snapshot,
//               emptyScreen: EmptyLibrary(refreshFunction: manager.refreshItems),
//               itemBuilder: (context, playlist) => Dismissible(
//                 key: Key('playlist-${playlist.id}'),
//                 background: Container(color: Colors.red),
//                 direction: DismissDirection.endToStart,
//                 onDismissed: (direction) =>
//                     manager.deleteItem(context, playlist),
//                 child: PlaylistTile(
//                   playlist: playlist,
//                   onTap: () => ChoosePlaylistForm.show(context, playlist),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
}
