import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/track/library_static.dart';
import 'package:music_room_app/spotify_library/track/managers/track_manager.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class TrackControlRowManager with ChangeNotifier implements TrackManager {
  TrackControlRowManager(
      {required this.trackApp,
      required this.playlist,
      required this.tracksList});

  final List<TrackApp> tracksList;
  TrackApp trackApp;
  Playlist playlist;
  bool isPlayed = false;
  Track? trackSdk;

  String? get trackSdkId =>
      trackSdk == null ? null : trackSdk!.uri.split(':')[2];
  
  togglePlay() async {
    try {
      isPlayed = isPlayed ? false : true;
      isPlayed ? await SpotifySdk.resume() : await SpotifySdk.pause();
    } on PlatformException catch (e) {
      TrackStatic.setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      TrackStatic.setStatus('not implemented');
      rethrow;
    }
  }

  int _findNextSpotifyIndex() {
    int? indexSpotify;
    if (trackApp.indexApp != null) {
      if (trackApp.indexApp! + 1 == tracksList.length) {
        indexSpotify =
            tracksList.firstWhere((track) => track.indexApp == 0).indexSpotify;
      } else {
        indexSpotify = tracksList
            .firstWhere((track) => track.indexApp == trackApp.indexApp! + 1)
            .indexSpotify;
      }
      return indexSpotify ?? 0;
    } else {
      return 0;
    }
  }

  Future<void> skipNext() async {
    try {
      // await SpotifySdk.skipNext();
      await SpotifySdk.skipToIndex(
          spotifyUri: 'spotify:playlist:' + playlist.id,
          trackIndex: _findNextSpotifyIndex());
    } on PlatformException catch (e) {
      TrackStatic.setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      TrackStatic.setStatus('not implemented');
      rethrow;
    }
  }

  int _findPreviousSpotifyIndex() {
    int? indexSpotify;
    if (trackApp.indexApp != null) {
      if (trackApp.indexApp! == 0) {
        indexSpotify = tracksList
            .firstWhere((track) => track.indexApp! + 1 == tracksList.length)
            .indexSpotify;
      } else {
        indexSpotify = tracksList
            .firstWhere((track) => track.indexApp == trackApp.indexApp! - 1)
            .indexSpotify;
      }
      return indexSpotify ?? 0;
    } else {
      return 0;
    }
  }

  Future<void> skipPrevious() async {
    try {
      // await SpotifySdk.skipPrevious();
      await SpotifySdk.skipToIndex(
          spotifyUri: 'spotify:playlist:' + playlist.id,
          trackIndex: _findPreviousSpotifyIndex());
    } on PlatformException catch (e) {
      TrackStatic.setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      TrackStatic.setStatus('not implemented');
      rethrow;
    }
  }

  @override
  void whenPlayerStateChange(PlayerState newState) {
    trackSdk = newState.track;
    isPlayed = !newState.isPaused;
    notifyListeners();
    try {
      String? newId = trackSdkId;
      if (newId != null) {
        trackApp = tracksList.firstWhere((track) => track.id == newId);
      }
    } on Error {
      TrackStatic.playTrack(trackApp, playlist);
    }
  }
}
