import 'package:flutter/cupertino.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify_service_subscriber.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import '../../../services/spotify_sdk_static.dart';

class TrackTitleRowManager with ChangeNotifier implements TrackManager {
  TrackTitleRowManager({required this.trackApp, required this.tracksList});

  final List<TrackApp> tracksList;
  TrackApp trackApp;
  Track? trackSdk;
  bool isAdded = false;

  String? get trackSdkId =>
      trackSdk == null ? null : trackSdk!.uri.split(':')[2];

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

  @override
  void whenPlayerStateChange(PlayerState newState) {
    trackSdk = newState.track;
    if (trackSdk != null) {
      String? newId = trackSdkId;
      if (trackApp.id != newId) {
        trackApp =
            SpotifySdkStatic.findNewTrackApp(trackApp, tracksList, newId);
        notifyListeners();
      }
    }
  }
}
