import 'package:flutter/cupertino.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';

class TrackManager with ChangeNotifier {
  TrackManager({
    required this.playlist,
    required this.track});

  Playlist playlist;
  Track track;
  bool isLiked = false;
  bool isPlayed = false;
  Duration duration = const Duration();
  Duration position = const Duration();

  toggleLike() {
    isLiked = isLiked == true ? false : true;
    notifyListeners();
  }

  togglePlay() {
    isPlayed = isPlayed == true ? false : true;
    notifyListeners();
  }

  Widget? returnImage() {
    if (track.album != null) {
      if (track.album!['images'] != null) {
        if (track.album!['images'].isNotEmpty) {
          if (track.album!['images'].first['url'] != null) {
            return Image.network(track.album!['images'].first['url']);
          }
        }
      }
    }
    return Image.asset('images/spotify-question-marks.jpeg');
  }

  String returnArtist() {
    if (track.artists != null) {
      if (track.artists!.isNotEmpty) {
        if (track.artists!.first['name'] != null) {
          return track.artists!.first['name'];
        }
      }
    }
    return 'Unknown';
  }

  double setChangedSlider() {
    // set to 0
    return 0.0;
  }

  void seekToSecond(int second) {
    // set to the received second
  }


}