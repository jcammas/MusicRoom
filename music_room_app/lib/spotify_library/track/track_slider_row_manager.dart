import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/widgets/logger.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'library_static.dart';

class TrackSliderRowManager with ChangeNotifier {
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

//when ?
  initTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), updatePositionOneSecond);
  }

  void updatePositionOneSecond(Timer timer) {
    position += const Duration(seconds: 1);
    notifyListeners();
  }

  double? resetSlider() {
    try {
      seekTo(0);
      return 0.0;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> seekTo(int milliseconds) async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: milliseconds);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekToRelative(int milliseconds) async {
    try {
      await SpotifySdk.seekToRelativePosition(
          relativeMilliseconds: milliseconds);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void whenPlayerStateChange(PlayerState newState) {
    playerState = newState;
    trackSdk = newState.track;
    bool notify = false;
    if (trackSdk != null) {
      if (trackApp.id != trackSdkId!) {
        duration = Duration(milliseconds: trackSdk!.duration);
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
