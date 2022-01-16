import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/track/managers/track_manager.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class TrackImageManager with ChangeNotifier implements TrackManager {
  TrackImageManager({required this.trackApp, required this.tracksList}) {
    initManager();
  }

  final List<TrackApp> tracksList;
  TrackApp trackApp;
  Track? trackSdk;
  StreamSubscription<PlayerState>? playerStateSubscription;

  String? get trackSdkId =>
      trackSdk == null ? null : trackSdk!.uri.split(':')[2];

  void initManager() {
    try {
      playerStateSubscription =
          SpotifySdk.subscribePlayerState().listen(whenPlayerStateChange);
    } on PlatformException {
      playerStateSubscription = null;
    }  on MissingPluginException {
      playerStateSubscription = null;
    } catch (e) {
      rethrow;
    }
  }

  Widget? returnImage() {
    if (trackApp.album != null) {
      if (trackApp.album!['images'] != null) {
        if (trackApp.album!['images'].isNotEmpty) {
          if (trackApp.album!['images'].first['url'] != null) {
            return Image.network(trackApp.album!['images'].first['url']);
          }
        }
      }
    }
    return Image.asset('images/spotify-question-marks.jpeg');
  }

  void updateTrackFromSdk(String? newId) {
    if (newId != null) {
      trackApp = tracksList.firstWhere((track) => track.id == newId,
          orElse: () => trackApp);
      notifyListeners();
    }
  }

  @override
  void whenPlayerStateChange(PlayerState newState) {
    trackSdk = newState.track;
    if (trackSdk != null) {
      if (trackApp.id != trackSdkId) {
        updateTrackFromSdk(trackSdkId);
      }
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
