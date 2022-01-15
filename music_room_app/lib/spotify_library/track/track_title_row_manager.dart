import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class TrackTitleRowManager with ChangeNotifier {
  TrackTitleRowManager({required this.trackApp, required this.tracksList}) {
    initManager();
  }

  final List<TrackApp> tracksList;
  TrackApp trackApp;
  Track? trackSdk;
  StreamSubscription<PlayerState>? playerStateSubscription;
  bool isAdded = false;

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
    }
  }

  toggleAdded() => updateAdded(isAdded == true ? false : true);

  void updateAdded(bool isAdded) {
    this.isAdded = isAdded;
    notifyListeners();
  }

  String returnArtist() {
    if (trackApp.artists != null) {
      if (trackApp.artists!.isNotEmpty) {
        if (trackApp.artists!.first['name'] != null) {
          return trackApp.artists!.first['name'];
        }
      }
    }
    return 'Unknown';
  }

  void updateTrackFromSdk(String? newId) {
    if (newId != null) {
      trackApp = tracksList.firstWhere((track) => track.id == newId,
          orElse: () => trackApp);
      notifyListeners();
    }
  }

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
