import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify_web.dart';
import 'package:music_room_app/spotify_library/track/managers/track_control_row_manager.dart';
import 'package:music_room_app/spotify_library/track/managers/track_image_manager.dart';
import 'package:music_room_app/spotify_library/track/managers/track_manager.dart';
import 'package:music_room_app/spotify_library/track/managers/track_slider_row_manager.dart';
import 'package:music_room_app/spotify_library/track/managers/track_title_row_manager.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:music_room_app/services/spotify_sdk_service.dart';
import '../../../home/models/room.dart';
import '../../../services/database.dart';

class TrackMainManager with ChangeNotifier implements TrackManager {
  TrackMainManager({
    required this.context,
    required this.playlist,
    required this.trackApp,
    required this.tracksList,
    required this.spotify,
    required this.db,
    this.room,
  }) {
    _initManagers();
  }

  final BuildContext context;
  final Playlist playlist;
  final List<TrackApp> tracksList;
  TrackApp trackApp;
  String? token;
  bool isConnected = false;
  bool isLoading = false;
  StreamSubscription<ConnectionStatus>? connStatusSubscription;
  StreamSubscription<PlayerState>? playerStateSubscription;
  SpotifyWeb spotify;
  Database db;
  Room? room;
  late List<TrackManager> managers;
  late TrackImageManager imageManager;
  late TrackControlRowManager controlRowManager;
  late TrackSliderRowManager sliderRowManager;
  late TrackTitleRowManager titleRowManager;

  Future<void> initManager() async {
    connStatusSubscription = SpotifySdkService.subscribeConnectionStatus(
        onData: whenConnStatusChange, onError: (error) => isConnected = false);
    isConnected = await SpotifySdkService.checkConnection();
    if (isConnected) {
      SpotifySdkService.playTrackInPlaylist(trackApp, playlist);
    }
  }

  void _initManagers() {
    imageManager =
        TrackImageManager(trackApp: trackApp, tracksList: tracksList);
    titleRowManager =
        TrackTitleRowManager(trackApp: trackApp, tracksList: tracksList);
    controlRowManager = TrackControlRowManager(
        trackApp: trackApp, playlist: playlist, tracksList: tracksList);
    sliderRowManager = TrackSliderRowManager();
    managers = [
      imageManager,
      titleRowManager,
      controlRowManager,
      sliderRowManager
    ];
  }

  Future<void> connectSpotifySdk() async {
    try {
      updateLoading(true);
      token = await spotify.getAccessToken();
      token = await SpotifySdkService.connectSpotifySdk(token);
      await SpotifySdkService.playTrackInPlaylist(trackApp, playlist);
      updateWith(isLoading: false, isConnected: true);
    } catch (e) {
      updateWith(isLoading: false, isConnected: false);
      rethrow;
    }
  }

  void whenPlayerStateChange(PlayerState newState) {
    if (room != null) db.updateRoomPlayerState(room!, newState);
    for (TrackManager manager in managers) {
      manager.whenPlayerStateChange(newState);
    }
  }

  void whenConnStatusChange(ConnectionStatus newStatus) {
    if (isConnected && newStatus.connected == false) {
      Navigator.of(context).pop();
    }
    updateConnected(newStatus.connected);
    playerStateSubscription =
        SpotifySdkService.subscribePlayerState(onData: whenPlayerStateChange);
  }

  void updateConnected(bool isConnected) =>
      updateWith(isConnected: isConnected);

  void updateLoading(bool isLoading) => updateWith(isLoading: isLoading);

  void updateWith({bool? isConnected, bool? isLoading, TrackApp? trackApp}) {
    this.isConnected = isConnected ?? this.isConnected;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }

  @override
  void dispose() {
    SpotifySdkService.disconnect();
    if (connStatusSubscription != null) {
      connStatusSubscription!.cancel();
    }
    if (playerStateSubscription != null) {
      playerStateSubscription!.cancel();
    }
    super.dispose();
  }

}
