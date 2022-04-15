import 'dart:async';
import 'package:music_room_app/services/spotify_sdk_static.dart';
import 'package:music_room_app/services/spotify_service_subscriber.dart';
import 'package:music_room_app/services/spotify_web.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import '../home/models/room.dart';
import '../home/models/track.dart';
import 'database.dart';

class SpotifySdkService {
  SpotifySdkService({required this.db, required this.spotifyWeb});

  List<TrackApp>? _currentTracksList;
  TrackApp? _currentTrack;
  Room? _currentRoom;
  StreamSubscription<ConnectionStatus>? connStatusSubscription;
  StreamSubscription<PlayerState>? playerStateSubscription;
  SpotifyServiceSubscriber? _subscriber;
  bool isConnected = false;
  bool isStarting = true;
  SpotifyWebService spotifyWeb;
  Database db;
  String? token;

  set currentTracksList(List<TrackApp> ls) => _currentTracksList = ls;

  set currentRoom(Room room) => _currentRoom = room;

  set subscriber(SpotifyServiceSubscriber subscriber) {
    _subscriber = subscriber;
    _currentTracksList = subscriber.tracksList;
    _currentTrack = subscriber.trackApp;
  }

  void disposeSubscriber(SpotifyServiceSubscriber subscriber) =>
      _subscriber = null;

  Future<bool> init() async {
    try {
      if (!isConnected) {
        connStatusSubscription = SpotifySdkStatic.subscribeConnectionStatus(
            onData: whenConnStatusChange,
            onError: (error) => isConnected = false);
        isConnected = await SpotifySdkStatic.checkConnection();
      }
    } finally {
      return isConnected;
    }
  }

  Future<void> connectSpotifySdk() async {
    try {
      token = await spotifyWeb.getAccessToken();
      token = await SpotifySdkStatic.connectSpotifySdk(token);
      isConnected = true;
    } catch (e) {
      isConnected = false;
      rethrow;
    }
  }

  TrackApp? findNextTrack() {
    final currentTrack = _currentTrack;
    final tracksList = _currentTracksList;
    if (currentTrack == null || tracksList == null) return null;
    int currentIndex = currentTrack.indexApp ?? -1;
    List<int> indexes = tracksList.map((track) => track.indexApp ?? 0).toList();
    int maxIndex = indexes.reduce(max);
    int minIndex;
    while (++currentIndex <= maxIndex) {
      if (indexes.contains(currentIndex)) {
        return indexes[currentIndex] ?? 0;
      }
    }
    minIndex = indexes.keys.reduce(min);
    return indexes[minIndex] ?? 0;
  }

  void whenPlayerStateChange(PlayerState newState) {
    if (isStarting) {
      isStarting = newState.playbackPosition > 0 ? false : true;
    } else if (newState.playbackPosition == 0){
      isStarting = true;
      final nextTrack = findNextTrack();
      if (nextTrack != null) {
        SpotifySdkStatic.playTrack(nextTrack);
      }
    }
    Room? room = _currentRoom;
    SpotifyServiceSubscriber? subscriber = _subscriber;
    if (room != null) db.updateRoomPlayerState(room, newState);
    if (subscriber != null) {
      subscriber.whenPlayerStateChange(newState);
    }
  }

  void whenConnStatusChange(ConnectionStatus newStatus) {
    isConnected = newStatus.connected;
    SpotifyServiceSubscriber? subscriber = _subscriber;
    playerStateSubscription =
        SpotifySdkStatic.subscribePlayerState(onData: whenPlayerStateChange);
    if (subscriber != null) {
      subscriber.whenConnStatusChange(newStatus);
    }
  }

  void disconnect() {
    SpotifySdkStatic.disconnect();
    if (connStatusSubscription != null) {
      connStatusSubscription!.cancel();
    }
    if (playerStateSubscription != null) {
      playerStateSubscription!.cancel();
    }
  }
}
