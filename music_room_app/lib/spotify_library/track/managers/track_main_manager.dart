import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify.dart';
import 'package:music_room_app/services/spotify_constants.dart';
import 'package:music_room_app/spotify_library/track/managers/track_control_row_manager.dart';
import 'package:music_room_app/spotify_library/track/managers/track_image_manager.dart';
import 'package:music_room_app/spotify_library/track/managers/track_manager.dart';
import 'package:music_room_app/spotify_library/track/managers/track_slider_row_manager.dart';
import 'package:music_room_app/spotify_library/track/managers/track_title_row_manager.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:music_room_app/spotify_library/track/library_static.dart';

class TrackMainManager with ChangeNotifier {
  TrackMainManager(
      {required this.context,
        required this.playlist,
      required this.trackApp,
      required this.tracksList,
      required this.spotify}){
    _initManagers();
  }

  final BuildContext context;
  final Playlist playlist;
  final List<TrackApp> tracksList;
  TrackApp trackApp;
  String? token;
  bool isConnected = false;
  bool isLoading = false;
  ConnectionStatus? connStatus;
  StreamSubscription<ConnectionStatus>? connStatusSubscription;
  StreamSubscription<PlayerState>? playerStateSubscription;
  Spotify spotify;
  late List<TrackManager> managers;
  late TrackImageManager imageManager;
  late TrackControlRowManager controlRowManager;
  late TrackSliderRowManager sliderRowManager;
  late TrackTitleRowManager titleRowManager;

  Future<void> initManager() async {
    try {
      connStatusSubscription =
          SpotifySdk.subscribeConnectionStatus().listen(whenConnStatusChange);
      await checkConnection();
      playIfConnected();
    } on PlatformException {
      connStatusSubscription = null;
    } on MissingPluginException {
      connStatusSubscription = null;
    }
  }

  void _initManagers() {
    imageManager =
        TrackImageManager(trackApp: trackApp, tracksList: tracksList);
    titleRowManager =
        TrackTitleRowManager(trackApp: trackApp, tracksList: tracksList);
    controlRowManager = TrackControlRowManager(
        trackApp: trackApp, playlist: playlist, tracksList: tracksList);
    sliderRowManager =
        TrackSliderRowManager();
    managers = [
      imageManager,
      titleRowManager,
      controlRowManager,
      sliderRowManager
    ];
  }

  _tryConnectToSpotify({String? token}) async =>
      SpotifySdk.connectToSpotifyRemote(
          clientId: spotifyClientId,
          redirectUrl: spotifyRedirectUri,
          accessToken: token);

  Future<void> checkConnection() async {
    try {
      if (await _tryConnectToSpotify()) {
        isConnected = true;
      }
    } on PlatformException {
      isConnected = false;
      TrackStatic.setStatus('not connected');
    } on MissingPluginException {
      isConnected = false;
      TrackStatic.setStatus('not implemented');
    }
  }

  Future<void> playIfConnected() async {
    if (isConnected) {
      TrackStatic.playTrack(trackApp, playlist);
    // } else {
    //   await Future.delayed(const Duration(seconds: 1));
    //   if (isConnected) {
    //     TrackStatic.playTrack(trackApp, playlist);
    //   }
    }
  }

  Future<void> _getTokenWithSdk() async {
    try {
      token = await SpotifySdk.getAuthenticationToken(
          clientId: spotifyClientId,
          redirectUrl: spotifyRedirectUri,
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
      TrackStatic.setStatus('Got a token: $token');
    } on PlatformException catch (e) {
      TrackStatic.setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      TrackStatic.setStatus('not implemented on this platform');
      rethrow;
    }
  }

  Future<void> _connectSpotifySdk() async {
    try {
      bool result = await _tryConnectToSpotify(token: token);
      TrackStatic.setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
      if (result) {
        await TrackStatic.playTrack(trackApp, playlist);
      } else {
        throw Exception('Could not connect to your app Spotify');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> connectSpotifySdk() async {
    try {
      updateLoading(true);
      token = await spotify.getAccessToken();
      await _connectSpotifySdk();
      updateWith(isLoading: false, isConnected: true);
    } on PlatformException catch (e) {
      if (e.code == 'NotLoggedInException') {
        try {
          await _getTokenWithSdk();
          await _connectSpotifySdk();
          updateWith(isLoading: false, isConnected: true);
        } on PlatformException catch (e) {
          updateWith(isLoading: false, isConnected: false);
          TrackStatic.setStatus(e.code, message: e.message);
          rethrow;
        } catch (e) {
          updateWith(isLoading: false, isConnected: false);
          rethrow;
        }
      } else {
        updateWith(isLoading: false, isConnected: false);
        rethrow;
      }
    } on MissingPluginException {
      updateWith(isLoading: false, isConnected: false);
      TrackStatic.setStatus('not implemented');
      rethrow;
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
    playerStateSubscription =
        SpotifySdk.subscribePlayerState().listen(whenPlayerStateChange);
  }

  void updateConnected(bool isConnected) =>
      updateWith(isConnected: isConnected);

  void updateLoading(bool isLoading) => updateWith(isLoading: isLoading);

  void updateWith({bool? isConnected, bool? isLoading, TrackApp? trackApp}) {
    this.isConnected = isConnected ?? this.isConnected;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }

  Future<void> disconnect() async {
    try {
      await SpotifySdk.disconnect();
    } on PlatformException catch (e) {
      TrackStatic.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      TrackStatic.setStatus('not implemented');
    }
  }

  @override
  void dispose() {
    disconnect();
    if (connStatusSubscription != null) {
      connStatusSubscription!.cancel();
    }
    if (playerStateSubscription != null) {
      playerStateSubscription!.cancel();
    }
    super.dispose();
  }
}
