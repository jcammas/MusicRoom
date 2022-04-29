import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify_sdk_service.dart';
import 'package:music_room_app/services/spotify_service_subscriber.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';

class TrackControlRowManager with ChangeNotifier implements TrackManager {
  TrackControlRowManager(
      {required this.trackApp,
      required this.playlist,
      required this.tracksList,
      required this.spotify});

  final List<TrackApp> tracksList;
  final SpotifySdkService spotify;
  TrackApp trackApp;
  Playlist playlist;
  bool isPaused = true;
  bool playback = false;
  bool isStarting = true;
  Track? trackSdk;
  Timer? timer;
  Duration position = const Duration(milliseconds: 0);

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

  Future<void> skipNext() async {
    isStarting = true;
      TrackApp? nextTrack = spotify.findNextTrack();
      if (nextTrack != null) {
        await spotify.playTrack(nextTrack);
      }
  }

  Future<void> skipPrevious() async {
    isStarting = true;
      if (position < const Duration(seconds: 4)) {
        TrackApp? previousTrack = spotify.findPreviousTrack();
        if (previousTrack != null) {
          await spotify.playTrack(previousTrack);
        }
      } else {
        await spotify.playTrack(trackApp);
      }
  }

  togglePlay() async => await spotify.togglePlay(!isPaused);

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
    notify ? notifyListeners() : null;
    try {
      String? newId = trackSdkId;
      if (newId != null) {
        trackApp = tracksList.firstWhere((track) => track.id == newId);
      }
    } on Error {
      spotify.playTrack(trackApp);
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
