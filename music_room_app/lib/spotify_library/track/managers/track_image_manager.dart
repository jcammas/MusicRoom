import 'package:flutter/cupertino.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify_service_subscriber.dart';
import 'package:spotify_sdk/models/player_state.dart';
import '../../../services/spotify_sdk_service.dart';

class TrackImageManager with ChangeNotifier implements TrackManager {
  TrackImageManager({required this.trackApp, required this.tracksList, required this.spotify});

  final List<TrackApp> tracksList;
  SpotifySdkService spotify;
  TrackApp trackApp;

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
    if (trackApp.id != spotify.getIdFromUri(newState.track?.uri)) {
        trackApp = spotify.getNewTrackApp(newState.track) ?? trackApp;
        notifyListeners();
      }
    }
}
