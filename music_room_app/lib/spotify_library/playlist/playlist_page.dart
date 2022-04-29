import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/services/spotify_sdk_service.dart';
import 'package:music_room_app/services/spotify_web.dart';
import 'package:music_room_app/spotify_library/widgets/empty_content.dart';
import 'package:music_room_app/spotify_library/widgets/list_items_builder.dart';
import 'package:music_room_app/spotify_library/widgets/list_items_manager.dart';
import 'package:music_room_app/spotify_library/playlist/track_tile.dart';
import 'package:music_room_app/spotify_library/track/views/track_page.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

import '../../constant_colors.dart';
import '../../widgets/show_alert_dialog.dart';

class PlaylistPage extends StatelessWidget {
  const PlaylistPage(
      {Key? key,
      required this.db,
      required this.spotify,
      required this.playlist,
      required this.manager})
      : super(key: key);
  final Database db;
  final SpotifySdkService spotify;
  final Playlist playlist;
  final PlaylistManager manager;

  static Future<void> show(BuildContext context, Playlist playlist) async {
    final db = Provider.of<Database>(context, listen: false);
    final spotifyWeb = Provider.of<SpotifyWebService>(context, listen: false);
    final spotifySdk = Provider.of<SpotifySdkService>(context, listen: false);
    if (spotifySdk.currentRoom == null) {
      spotifySdk.currentTracksList = playlist.tracksList.values.toList();
    }
    PlaylistManager manager = PlaylistManager(
        spotify: spotifyWeb, db: db, playlist: playlist, isLoading: true);
    manager.fillIfEmpty(context);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => PlaylistPage(
            db: db, spotify: spotifySdk, playlist: playlist, manager: manager),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Playlist>(
        stream: db.userPlaylistStream(playlist),
        builder: (context, snapshot) {
          final playlist = snapshot.data;
          if (spotify.currentRoom == null) {
            spotify.currentTracksList = playlist == null
                ? List.empty()
                : playlist.tracksList.values.toList();
          }
          final pName = playlist?.name ?? '';
          return Scaffold(
              appBar: customAppBar(
                  appText: pName,
                  context: context,
                  funcText: 'Refresh',
                  topRight: manager.refreshItems),
              backgroundColor: backgroundColor,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: _buildPage(context, playlist)));
        });
  }

  Widget _buildPage(BuildContext context, Playlist? playlist) {
    if (playlist != null) {
      return _buildContents(context, playlist);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  void showTrackPage(BuildContext context, Playlist playlist, TrackApp track,
      List<TrackApp> tracksList) async {
    if (await manager.checkIfRoomActive()) {
      await showAlertDialog(context,
          title: 'Can\'t access track',
          content: const Text(
              'You have an active Room. Quit it to play songs on your library.'),
          defaultActionText: 'Ok');
    } else {
      TrackPage.show(context, playlist, track, tracksList, spotify, db);
    }
  }

  Widget _buildContents(BuildContext context, Playlist playlist) {
    return StreamBuilder<List<TrackApp>>(
      stream: db.userPlaylistTracksStream(playlist),
      builder: (context, snapshot) {
        return ChangeNotifierProvider<PlaylistManager>(
          create: (_) => manager,
          child: Consumer<PlaylistManager>(
            builder: (_, __, ___) => ListItemsBuilder<TrackApp>(
              snapshot: snapshot,
              manager: manager,
              emptyScreen: const EmptyContent(),
              itemBuilder: (context, track) => Dismissible(
                key: Key('track-${track.id}'),
                background: Container(color: Colors.red),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => manager.deleteItem(context, track),
                child: TrackTile(
                  track: track,
                  onTap: () =>
                      showTrackPage(context, playlist, track, snapshot.data!),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
