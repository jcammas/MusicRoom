import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/services/database.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:music_room_app/widgets/spotify_constants.dart';

class LibraryModel with ChangeNotifier {
  LibraryModel({required this.db});

  final Database db;

  Stream<List<Playlist>> getPlaylistsStream() => db.playlistsStream();

  Future<void> playWithSpotify() async {
    await SpotifySdk.connectToSpotifyRemote(
        clientId: spotifyClientId, redirectUrl: spotifyRedirectUri);
  }

}
