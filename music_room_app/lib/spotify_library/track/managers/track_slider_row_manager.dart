import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:music_room_app/services/spotify_service_subscriber.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import '../../../services/spotify_sdk_service.dart';

class TrackSliderRowManager with ChangeNotifier implements TrackManager {
  TrackSliderRowManager({required this.spotify});

  bool isPaused = true;
  Duration duration = const Duration(milliseconds: 0);
  Duration position = const Duration(milliseconds: 0);
  Timer? timer;
  SpotifySdkService spotify;

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

  Future<void> seekTo(int milliseconds) async =>
      position = await spotify.seekTo(milliseconds);

  @override
  void whenPlayerStateChange(PlayerState newState) {
    Track? trackSdk = newState.track;
    if (trackSdk != null) {
      position = Duration(milliseconds: newState.playbackPosition);
      duration = Duration(milliseconds: trackSdk.duration);
    }
    if (isPaused != newState.isPaused) {
      timer != null ? timer!.cancel() : null;
      newState.isPaused == false ? initTimer() : null;
      isPaused = newState.isPaused;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }
}
