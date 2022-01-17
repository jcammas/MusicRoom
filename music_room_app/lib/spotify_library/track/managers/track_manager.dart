import 'package:spotify_sdk/models/player_state.dart';

abstract class TrackManager {
  whenPlayerStateChange(PlayerState newState);
}