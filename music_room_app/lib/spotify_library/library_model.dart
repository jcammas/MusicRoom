import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/spotify_profile.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/services/spotify.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:music_room_app/widgets/spotify_constants.dart';

class LibraryModel with ChangeNotifier {
  LibraryModel({required this.db, required this.spotify});

  final Database db;
  final SpotifyService spotify;

  Stream<List<Playlist>> getPlaylistsStream() => db.playlistsStream();

  Future<void> playWithSpotify() async {
    await SpotifySdk.connectToSpotifyRemote(
        clientId: spotifyClientId, redirectUrl: spotifyRedirectUri);
  }

  Future<void> refreshPlaylists() async {
    try {
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
    } catch (e) {
      rethrow;
    }
  }
}
