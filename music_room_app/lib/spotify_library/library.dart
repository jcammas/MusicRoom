import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/spotify_profile.dart';
import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/services/spotify.dart';
import 'package:music_room_app/spotify_library/widgets/playlist_tile.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'list_items_builder.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  static const String routeName = '/library';

  Future<void> _delete(BuildContext context, Playlist playlist) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteUserPlaylist(playlist);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> refreshPlaylists(BuildContext context) async {
    try {
      final db = Provider.of<Database>(context, listen: false);
      final spotify = Provider.of<SpotifyService>(context, listen: false);
      final Map<String, dynamic>? profileMap =
          await spotify.getCurrentUserProfile();
      SpotifyProfile userProfile = SpotifyProfile.fromMap(profileMap);
      await db.setSpotifyProfile(userProfile);
      final List<dynamic> playlistsList =
          await spotify.getCurrentUserPlaylists();
      final List<Playlist> playlists = playlistsList
          .whereType<Map<String, dynamic>>()
          .map((playlist) => playlist['id'] != null
              ? Playlist.fromMap(playlist, playlist['id'])
              : null)
          .whereType<Playlist>()
          .toList();
      await db.savePlaylists(playlists);
      await db.setUserPlaylists(playlists);
    } on Exception catch (e) {
      showExceptionAlertDialog(context,
          title: 'Refreshing Failed', exception: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(
            appText: 'Library',
            context: context,
            funcText: 'Refresh',
            topRight: refreshPlaylists),
        backgroundColor: const Color(0xFFEFEFF4),
        drawer: const MyDrawer(),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light, child: _buildContents(context)));
  }

  Widget _buildContents(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Playlist>>(
      stream: db.playlistsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Playlist>(
          snapshot: snapshot,
          itemBuilder: (context, playlist) => Dismissible(
            key: Key('playlist-${playlist.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, playlist),
            child: PlaylistTile(
              playlist: playlist,
              onTap: () => {},
              // onTap: () => PlaylistEntriesPage.show(context, playlist),
            ),
          ),
        );
      },
    );
  }
}
