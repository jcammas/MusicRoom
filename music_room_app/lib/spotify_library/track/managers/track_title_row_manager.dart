import 'package:flutter/cupertino.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify_sdk_service.dart';
import 'package:music_room_app/services/spotify_service_subscriber.dart';
import 'package:spotify_sdk/models/player_state.dart';

class TrackTitleRowManager with ChangeNotifier implements TrackManager {
  TrackTitleRowManager(
      {required this.trackApp,
      required this.tracksList,
      required this.spotify});

  final List<TrackApp> tracksList;
  TrackApp trackApp;
  SpotifySdkService spotify;
  bool isAdded = false;

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
    if (trackApp.id != spotify.getIdFromUri(newState.track?.uri)) {
      trackApp = spotify.getNewTrackApp(newState.track)?? trackApp;
      notifyListeners();
    }
  }
}
