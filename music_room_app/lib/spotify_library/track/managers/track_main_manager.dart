import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify_sdk_service.dart';
import 'package:music_room_app/spotify_library/track/managers/track_control_row_manager.dart';
import 'package:music_room_app/spotify_library/track/managers/track_image_manager.dart';
import 'package:music_room_app/services/spotify_service_subscriber.dart';
import 'package:music_room_app/spotify_library/track/managers/track_slider_row_manager.dart';
import 'package:music_room_app/spotify_library/track/managers/track_title_row_manager.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:music_room_app/services/spotify_sdk_static.dart';
import '../../../home/models/room.dart';

class TrackMainManager with ChangeNotifier implements SpotifyServiceSubscriber {
  TrackMainManager({
    required this.context,
    required this.playlist,
    required this.trackApp,
    required this.tracksList,
    required this.spotify,
    this.room,
  }) {
    _initManagers();
  }

  final BuildContext context;
  final Playlist playlist;
  final List<TrackApp> tracksList;
  TrackApp trackApp;
  bool isConnected = false;
  bool isLoading = false;
  SpotifySdkService spotify;
  Room? room;
  late List<TrackManager> managers;
  late TrackImageManager imageManager;
  late TrackControlRowManager controlRowManager;
  late TrackSliderRowManager sliderRowManager;
  late TrackTitleRowManager titleRowManager;

  Future<void> initManager() async {
    spotify.subscriber = this;
    isConnected = await spotify.init();
    if (isConnected) {
      SpotifySdkStatic.playTrack(trackApp);
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
      await spotify.connectSpotifySdk();
      await SpotifySdkStatic.playTrack(trackApp);
      updateWith(isLoading: false, isConnected: true);
    } catch (e) {
      updateWith(isLoading: false, isConnected: false);
      rethrow;
    }
  }

  void whenPlayerStateChange(PlayerState newState) {
    for (TrackManager manager in managers) {
      manager.whenPlayerStateChange(newState);
    }
  }

  void whenConnStatusChange(ConnectionStatus newStatus) {
    if (isConnected && newStatus.connected == false) {
      Navigator.of(context).pop();
    }
    updateConnected(newStatus.connected);
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
    spotify.disposeSubscriber(this);
    super.dispose();
  }
}
