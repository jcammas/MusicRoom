import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify_sdk_static.dart';
import 'package:music_room_app/services/spotify_service_subscriber.dart';
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
  bool isStarting = true;
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

  int _findNextTrack() {
    int currentIndex = trackApp.indexApp ?? -1;
    List<int> indexes = tracksList.map((track) => track.indexApp ?? 0).toList();
    int maxIndex = indexes.reduce(max);
    int minIndex;
    while (++currentIndex <= maxIndex) {
      if (indexes.contains(currentIndex)) {
        return indexes[currentIndex] ?? 0;
      }
    }
    minIndex = indexes.keys.reduce(min);
    return indexes[minIndex] ?? 0;
  }

  Future<void> skipNext() async {
    isStarting = true;
    if (repeatMode != player_options.RepeatMode.off) {
      await SpotifySdkStatic.playTrack(trackApp);
    } else {
      int nextIndex = _findNextTrack();
      if (nextIndex >= 0) {
        await SpotifySdkStatic.skipToIndex(
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
    isStarting = true;
    if (isShuffling || repeatMode != player_options.RepeatMode.off) {
      await SpotifySdkStatic.skipPrevious();
    } else {
      if (position < const Duration(seconds: 4)) {
        int previousIndex = _findPreviousSpotifyIndex();
        if (previousIndex >= 0) {
          await SpotifySdkStatic.skipToIndex(
              playlist.id, _findPreviousSpotifyIndex());
        }
      } else {
        SpotifySdkStatic.playTrackInPlaylist(trackApp, playlist);
      }
    }
  }

  toggleShuffle() async => isShuffling = !isShuffling;

  togglePlay() async => await SpotifySdkStatic.togglePlay(!isPaused);

  toggleRepeat() async => await SpotifySdkStatic.toggleRepeat();

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
      SpotifySdkStatic.playTrack(trackApp);
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
