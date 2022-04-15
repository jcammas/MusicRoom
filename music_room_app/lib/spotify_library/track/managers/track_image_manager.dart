import 'package:flutter/cupertino.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify_service_subscriber.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import '../../../services/spotify_sdk_static.dart';

class TrackImageManager with ChangeNotifier implements TrackManager {
  TrackImageManager({required this.trackApp, required this.tracksList});

  final List<TrackApp> tracksList;
  TrackApp trackApp;
  Track? trackSdk;
  String? get trackSdkId =>
      trackSdk == null ? null : trackSdk!.uri.split(':')[2];

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

  @override
  void whenPlayerStateChange(PlayerState newState) {
    trackSdk = newState.track;
    if (trackSdk != null) {
      String? newId = trackSdkId;
      if (trackApp.id != newId) {
        trackApp = SpotifySdkStatic.findNewTrackApp(trackApp, tracksList, newId);
        notifyListeners();
      }
    }
  }
}
