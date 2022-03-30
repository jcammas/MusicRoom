import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/spotify_library/widgets/list_items_builder.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import '../../constant_colors.dart';
import '../../spotify_library/library/playlist_tile.dart';
import '../../spotify_library/widgets/empty_content.dart';
import '../managers/create_room_manager.dart';

class ChoosePlaylistForm extends StatelessWidget {
  const ChoosePlaylistForm({Key? key, required this.manager}) : super(key: key);
  final CreateRoomManager manager;

  static Future<void> show(
      BuildContext context, CreateRoomManager manager) async {
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
                  : const Icon(Icons.circle_outlined),
            ),
          );
        });
  }
}
