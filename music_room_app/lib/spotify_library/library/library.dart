import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/services/spotify_web.dart';
import 'package:music_room_app/widgets/connect_spotify_form.dart';
import 'package:music_room_app/spotify_library/playlist/playlist_page.dart';
import 'package:music_room_app/spotify_library/library/playlist_tile.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../constant_colors.dart';
import '../widgets/list_items_manager.dart';
import '../widgets/list_items_builder.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  static const String routeName = '/library';

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final spotify = Provider.of<SpotifyWebService>(context, listen: false);
    LibraryManager manager = LibraryManager(spotify: spotify, db: db);
    return Scaffold(
      appBar: customAppBar(
        appText: 'Library',
        context: context,
        funcText: 'Refresh',
        topRight: manager.refreshItems,
      ),
      backgroundColor: backgroundColor,
      drawer: const MyDrawer(),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: _buildContents(context, manager, db)),
    );
  }

  Widget _buildContents(
      BuildContext context, LibraryManager manager, Database db) {
    return StreamBuilder<List<Playlist>>(
      stream: db.userPlaylistsStream(),
      builder: (context, snapshot) {
        return ChangeNotifierProvider<LibraryManager>(
          create: (_) => manager,
          child: Consumer<LibraryManager>(
            builder: (_, __, ___) => ListItemsBuilder<Playlist>(
              manager: manager,
              snapshot: snapshot,
              emptyScreen: ConnectSpotifyForm(refreshFunction: manager.refreshItems),
              itemBuilder: (context, playlist) => Dismissible(
                key: Key('playlist-${playlist.id}'),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) =>
                    manager.deleteItem(context, playlist),
                child: PlaylistTile(
                  playlist: playlist,
                  onTap: () => PlaylistPage.show(context, playlist),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
