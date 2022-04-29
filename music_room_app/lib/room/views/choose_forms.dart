import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/spotify_library/widgets/list_items_builder.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import '../../constant_colors.dart';
import '../../home/models/track.dart';
import '../../spotify_library/library/playlist_tile.dart';
import '../../spotify_library/playlist/track_tile.dart';
import '../../spotify_library/widgets/empty_content.dart';
import '../managers/choose_form_manager.dart';

class ChoosePlaylistForm extends StatelessWidget {
  const ChoosePlaylistForm({Key? key, required this.manager}) : super(key: key);
  final ChooseFormManager manager;

  static Future<void> show(
      BuildContext context, ChooseFormManager manager) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => ChoosePlaylistForm(manager: manager),
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
      backgroundColor: backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: _buildContents(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<Playlist>>(
        stream: manager.userPlaylistsStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<Playlist>(
            manager: manager,
            snapshot: snapshot,
            emptyScreen: EmptyContent(
                message: 'Go to Library and load your playlists !'),
            itemBuilder: (context, playlist) => PlaylistTile(
              playlist: playlist,
              onTap: () => manager.selectPlaylist(context, playlist),
              icon: manager.playlistId == playlist.id
                  ? const Icon(
                      Icons.check_circle,
                      color: primaryColor,
                    )
                  : manager.circleIcon
                      ? const Icon(Icons.circle_outlined)
                      : const Icon(Icons.chevron_right_outlined),
            ),
          );
        });
  }
}

class ChooseTrackForm extends StatelessWidget {
  const ChooseTrackForm({Key? key, required this.manager}) : super(key: key);
  final AddTrackManager manager;

  static Future<void> show(
      BuildContext context, AddTrackManager manager) async {
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => ChooseTrackForm(manager: manager),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
          appText: 'Choose a track',
          context: context,
          funcText: '',
          topRight: (context) async {}),
      backgroundColor: backgroundColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: _buildContents(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<TrackApp>>(
        stream: manager.playlistTracksStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<TrackApp>(
            manager: manager,
            snapshot: snapshot,
            emptyScreen:
                EmptyContent(message: 'Go to Library and load this playlist !'),
            itemBuilder: (context, track) => TrackTile(
              track: track,
              onTap: () => manager.selectTrack(context, track),
              icon: manager.trackId == track.id
                  ? const Icon(
                      Icons.check_circle,
                      color: primaryColor,
                    )
                  : const Icon(Icons.circle_outlined),
            ),
          );
        });
  }
}
