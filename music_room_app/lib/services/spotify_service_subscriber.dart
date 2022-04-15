import 'package:music_room_app/home/models/track.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';

abstract class TrackManager {
  whenPlayerStateChange(PlayerState newState);
}

abstract class SpotifyServiceSubscriber {
  TrackApp get trackApp;
  List<TrackApp> get tracksList;
  whenConnStatusChange(ConnectionStatus newStatus);
  whenPlayerStateChange(PlayerState newState);
}