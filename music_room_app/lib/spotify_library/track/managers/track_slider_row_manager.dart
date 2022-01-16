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
  TrackSliderRowManager({required this.trackApp, required this.tracksList}) {
    initManager();
  }

  final List<TrackApp> tracksList;
  TrackApp trackApp;
  StreamSubscription<PlayerState>? playerStateSubscription;
  bool isPaused = true;
  Duration duration = const Duration();
  Duration position = const Duration();
  PlayerState? playerState;
  Track? trackSdk;
  Timer? timer;

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

//when ?
  initTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), updatePositionOneSecond);
  }

  void updatePositionOneSecond(Timer timer) {
    position += const Duration(seconds: 1);
    notifyListeners();
  }

  // double? resetSlider() {
  //   try {
  //     seekTo(0);
  //     return 0.0;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<void> seekTo(int milliseconds) async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: milliseconds);
      position = Duration(milliseconds: milliseconds);
    } on PlatformException catch (e) {
      LibraryStatic.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      LibraryStatic.setStatus('not implemented');
    }
  }

  Future<void> seekToRelative(int milliseconds) async {
    try {
      position += Duration(milliseconds: milliseconds);
      await SpotifySdk.seekToRelativePosition(
          relativeMilliseconds: milliseconds);
    } on PlatformException catch (e) {
      LibraryStatic.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      LibraryStatic.setStatus('not implemented');
    }
  }

  void updateTrackFromSdk(String? newId) {
    if (newId != null) {
      trackApp = tracksList.firstWhere((track) => track.id == newId,
          orElse: () => trackApp);
    }
  }

  @override
  void whenPlayerStateChange(PlayerState newState) {
    playerState = newState;
    trackSdk = newState.track;
    bool notify = false;
    if (trackSdk != null) {
      String newId = trackSdkId!;
      if (trackApp.id != newId) {
        duration = Duration(milliseconds: trackSdk!.duration);
        position = const Duration(milliseconds : 0);
        updateTrackFromSdk(newId);
        notify = true;
      }
    }
    if (isPaused != playerState!.isPaused) {
      timer != null ? timer!.cancel() : null;
      position = Duration(milliseconds: playerState!.playbackPosition);
      playerState!.isPaused == false ? initTimer() : null;
      isPaused = playerState!.isPaused;
      notify = true;
    }
    notify ? notifyListeners() : null;
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    if (playerStateSubscription != null) {
      playerStateSubscription!.cancel();
    }
    super.dispose();
  }
}
