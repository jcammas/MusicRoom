import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/track/library_static.dart';
import 'package:music_room_app/spotify_library/track/managers/track_manager.dart';
import 'package:spotify_sdk/models/player_options.dart' as player_options;
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
  bool isPaused = true;
  bool isShuffling = false;
  bool playback = false;
  Track? trackSdk;
  Timer? timer;
  Duration position = const Duration(milliseconds: 0);
  player_options.RepeatMode repeatMode = player_options.RepeatMode.off;

  String? get trackSdkId =>
      trackSdk == null ? null : trackSdk!.uri.split(':')[2];

  initTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(const Duration(seconds: 1), updatePositionOneSecond);
  }

  void updatePositionOneSecond(Timer timer) {
    position += const Duration(seconds: 1);
    notifyListeners();
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
      if (isShuffling || repeatMode != player_options.RepeatMode.off) {
        await SpotifySdk.skipNext();
      } else {
        await SpotifySdk.skipToIndex(
            spotifyUri: 'spotify:playlist:' + playlist.id,
            trackIndex: _findNextSpotifyIndex());
      }
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
      if (isShuffling || repeatMode != player_options.RepeatMode.off) {
        await SpotifySdk.skipPrevious();
      } else {
        if (position < const Duration(seconds: 4)) {
          await SpotifySdk.skipToIndex(
              spotifyUri: 'spotify:playlist:' + playlist.id,
              trackIndex: _findPreviousSpotifyIndex());
        } else {
          TrackStatic.playTrack(trackApp, playlist);
        }
      }
    } on PlatformException catch (e) {
      TrackStatic.setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      TrackStatic.setStatus('not implemented');
      rethrow;
    }
  }

  Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
      TrackStatic.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      TrackStatic.setStatus('not implemented');
    }
  }

  Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
      TrackStatic.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      TrackStatic.setStatus('not implemented');
    }
  }

  togglePlay() async {
    try {
      isPaused ? await SpotifySdk.resume() : await SpotifySdk.pause();
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
    bool notify = false;
    trackSdk = newState.track;
    position = Duration(milliseconds: newState.playbackPosition);
    if (isPaused != newState.isPaused) {
      timer != null ? timer!.cancel() : null;
      newState.isPaused == false ? initTimer() : null;
      isPaused = newState.isPaused;
      notify = true;
    }
    if (isShuffling != newState.playbackOptions.isShuffling) {
      isShuffling = newState.playbackOptions.isShuffling;
      notify = true;
    }
    if (repeatMode != newState.playbackOptions.repeatMode) {
      repeatMode = newState.playbackOptions.repeatMode;
      notify = true;
    }
    notify ? notifyListeners() : null;
    try {
      String? newId = trackSdkId;
      if (newId != null) {
        trackApp = tracksList.firstWhere((track) => track.id == newId);
      }
    } on Error {
      TrackStatic.playTrack(trackApp, playlist);
    }
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }
}
