import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify_sdk_service.dart';
import 'package:music_room_app/spotify_library/track/managers/track_manager.dart';
import 'package:spotify_sdk/models/player_options.dart' as player_options;
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';

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
    int currentIndex = trackApp.indexApp ?? -1;
    Map<int, int?> indexMap = Map.fromIterable(tracksList,
        key: (track) => track.indexApp ?? 0,
        value: (track) => track.indexSpotify);
    int maxIndex = indexMap.keys.reduce(max);
    int minIndex;
    while (++currentIndex <= maxIndex) {
      if (indexMap.containsKey(currentIndex)) {
        return indexMap[currentIndex] ?? 0;
      }
    }
    minIndex = indexMap.keys.reduce(min);
    return indexMap[minIndex] ?? 0;
  }

  Future<void> skipNext() async {
    if (isShuffling || repeatMode != player_options.RepeatMode.off) {
      await SpotifySdkService.skipNext();
    } else {
      int nextIndex = _findNextSpotifyIndex();
      if (nextIndex >= 0) {
        await SpotifySdkService.skipToIndex(
            playlist.id, _findNextSpotifyIndex());
      }
    }
  }

  int _findPreviousSpotifyIndex() {
    int currentIndex = trackApp.indexApp ?? 0;
    Map<int, int?> indexMap = Map.fromIterable(tracksList,
        key: (track) => track.indexApp ?? 0,
        value: (track) => track.indexSpotify);
    int minIndex = indexMap.keys.reduce(min);
    int maxIndex;
    while (--currentIndex >= minIndex) {
      if (indexMap.containsKey(currentIndex)) {
        return indexMap[currentIndex] ?? 0;
      }
    }
    maxIndex = indexMap.keys.reduce(max);
    return indexMap[maxIndex] ?? 0;
  }

  Future<void> skipPrevious() async {
    if (isShuffling || repeatMode != player_options.RepeatMode.off) {
      await SpotifySdkService.skipPrevious();
    } else {
      if (position < const Duration(seconds: 4)) {
        int previousIndex = _findPreviousSpotifyIndex();
        if (previousIndex >= 0) {
          await SpotifySdkService.skipToIndex(
              playlist.id, _findPreviousSpotifyIndex());
        }
      } else {
        SpotifySdkService.playTrackInPlaylist(trackApp, playlist);
      }
    }
  }

  toggleShuffle() async => await SpotifySdkService.toggleShuffle();

  togglePlay() async => await SpotifySdkService.togglePlay(!isPaused);

  toggleRepeat() async => await SpotifySdkService.toggleRepeat();

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
      SpotifySdkService.playTrackInPlaylist(trackApp, playlist);
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
