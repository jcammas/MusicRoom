import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/track/library_static.dart';
import 'package:music_room_app/widgets/logger.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class TrackControlRowManager with ChangeNotifier {
  TrackControlRowManager(
      {required this.trackApp,
      required this.playlist,
      required this.tracksList}) {
    initManager();
  }

  final List<TrackApp> tracksList;
  TrackApp trackApp;
  Playlist playlist;
  StreamSubscription<PlayerState>? playerStateSubscription;
  bool isPlayed = false;
  PlayerState? playerState;
  Track? trackSdk;
  final _logger = LoggerApp.logger;

  String? get trackSdkId =>
      trackSdk == null ? null : trackSdk!.uri.split(':')[2];

  void initManager() {
    try {
      playerStateSubscription =
          SpotifySdk.subscribePlayerState().listen(whenPlayerStateChange);
    } on PlatformException {
      playerStateSubscription = null;
    } on MissingPluginException {
      playerStateSubscription = null;
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }

  togglePlay() async {
    try {
      isPlayed = isPlayed ? false : true;
      isPlayed ? await SpotifySdk.resume() : await SpotifySdk.pause();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      setStatus('not implemented');
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
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      setStatus('not implemented');
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
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      setStatus('not implemented');
      rethrow;
    }
  }

  void whenPlayerStateChange(PlayerState newState) {
    playerState = newState;
    trackSdk = newState.track;
    isPlayed = !playerState!.isPaused;
    notifyListeners();
    try {
      String? newId = trackSdkId;
      if (newId != null) {
        trackApp = tracksList.firstWhere((track) => track.id == newId);
      }
    } on Error {
      LibraryStatic.playTrack(trackApp, playlist);
    }
  }

  @override
  void dispose() {
    if (playerStateSubscription != null) {
      playerStateSubscription!.cancel();
    }
    super.dispose();
  }
}
