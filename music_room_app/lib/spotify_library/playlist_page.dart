import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/services/spotify.dart';
import 'package:music_room_app/spotify_library/empty_content.dart';
import 'package:music_room_app/spotify_library/list_items_manager.dart';
import 'package:music_room_app/spotify_library/widgets/track_tile.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'list_items_builder.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage(
      {Key? key,
      required this.db,
      required this.spotify,
      required this.playlist,
      required this.manager})
      : super(key: key);
  final Database db;
  final Spotify spotify;
  final Playlist playlist;
  final PlaylistManager manager;

  static Future<void> show(BuildContext context, Playlist playlist) async {
    final db = Provider.of<Database>(context, listen: false);
    final spotify = Provider.of<Spotify>(context, listen: false);
    PlaylistManager manager =
        PlaylistManager(spotify: spotify, db: db, playlist: playlist, isLoading: true);
    manager.fillIfEmpty(context);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => PlaylistPage(
            db: db, spotify: spotify, playlist: playlist, manager: manager),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Playlist>(
        stream: db.userPlaylistStream(playlist),
        builder: (context, snapshot) {
          final playlist = snapshot.data;
          final pName = playlist?.name ?? '';
          return Scaffold(
              appBar: customAppBar(
                  appText: pName,
                  context: context,
                  funcText: 'Refresh',
                  topRight: manager.refreshItems),
              backgroundColor: const Color(0xFFEFEFF4),
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: _buildPage(context, playlist)));
        });
  }

  Widget _buildPage(BuildContext context, Playlist? playlist) {
    if (playlist != null) {
      return _buildContents(context, playlist);
    } else {
      return const EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
  }

  Widget _buildContents(BuildContext context, Playlist playlist) {
    return StreamBuilder<List<Track>>(
      stream: db.userPlaylistTracksStream(playlist),
      builder: (context, snapshot) {
        return ChangeNotifierProvider<PlaylistManager>(
          create: (_) => manager,
          child: Consumer<PlaylistManager>(
            builder: (_, model, __) => ListItemsBuilder<Track>(
              snapshot: snapshot,
              manager: manager,
              emptyScreen: const EmptyContent(),
              itemBuilder: (context, track) => Dismissible(
                key: Key('playlist-${track.id}'),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => manager.deleteItem(context, track),
                child: TrackTile(
                  track: track,
                  onTap: () => {},
                  // onTap: () => PlaylistEntriesPage.show(context, playlist),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
