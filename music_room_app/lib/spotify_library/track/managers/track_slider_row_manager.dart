import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/track/managers/track_manager.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import '../library_static.dart';

class TrackSliderRowManager with ChangeNotifier implements TrackManager {
  TrackSliderRowManager({required this.trackApp, required this.tracksList});

  final List<TrackApp> tracksList;
  TrackApp trackApp;
  bool isPaused = true;
  Duration duration = const Duration();
  Duration position = const Duration();
  Track? trackSdk;
  Timer? timer;

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

  Future<void> seekTo(int milliseconds) async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: milliseconds);
      position = Duration(milliseconds: milliseconds);
    } on PlatformException catch (e) {
      TrackStatic.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      TrackStatic.setStatus('not implemented');
    }
  }

  Future<void> seekToRelative(int milliseconds) async {
    try {
      position += Duration(milliseconds: milliseconds);
      await SpotifySdk.seekToRelativePosition(
          relativeMilliseconds: milliseconds);
    } on PlatformException catch (e) {
      TrackStatic.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      TrackStatic.setStatus('not implemented');
    }
  }

  @override
  void whenPlayerStateChange(PlayerState newState) {
    trackSdk = newState.track;
    bool notify = false;
    if (trackSdk != null) {
      String? newId = trackSdkId;
      if (trackApp.id != newId) {
        duration = Duration(milliseconds: trackSdk!.duration);
        position = const Duration(milliseconds: 0);
        trackApp = TrackStatic.updateTrackFromSdk(trackApp, tracksList, newId);
        notify = true;
      }
    }
    if (isPaused != newState.isPaused) {
      timer != null ? timer!.cancel() : null;
      position = Duration(milliseconds: newState.playbackPosition);
      newState.isPaused == false ? initTimer() : null;
      isPaused = newState.isPaused;
      notify = true;
    }
    notify ? notifyListeners() : null;
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }
}
