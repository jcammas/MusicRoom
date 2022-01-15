import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify.dart';
import 'package:music_room_app/widgets/spotify_constants.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:logger/logger.dart';

class TrackManager with ChangeNotifier {
  TrackManager(
      {required this.playlist, required this.trackApp, required this.tracksList, required this.spotify}) {
    checkConnection();
  }

  final Playlist playlist;
  final List<TrackApp> tracksList;
  TrackApp trackApp;
  Track? trackSdk;
  String? token;
  bool isConnected = false;
  bool isLoading = false;
  ConnectionStatus? previousConnStatus;
  PlayerState? playerState;
  Spotify spotify;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      // number of method calls to be displayed
      errorMethodCount: 8,
      // number of method calls if stacktrace is provided
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  String? get trackSdkId =>
      trackSdk == null ? null : trackSdk!.uri.split(':')[2];

  Future<String> _getAuthenticationToken() async {
    try {
      String newToken = await SpotifySdk.getAuthenticationToken(
          clientId: spotifyClientId,
          redirectUrl: spotifyRedirectUri,
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
      setStatus('Got a token: $newToken');
      await secureStorage.write(key: 'SpotifySDKToken', value: newToken);
      return newToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      setStatus('not implemented on this platform');
      rethrow;
    }
  }

  Future<bool> _connectWithToken() async {
    try {
      token = token ?? await secureStorage.read(key: 'SpotifySDKToken');
      token = token ?? await secureStorage.read(key: 'accessToken');
      token = token ?? await _getAuthenticationToken();
      bool result = await _tryConnectToSpotify(token: token);
      if (result == false) {
        await _getAuthenticationToken();
        return await _tryConnectToSpotify();
      }
      return result;
    } on PlatformException {
      try {
          await _getAuthenticationToken();
          return await _tryConnectToSpotify();
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
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
        await playTrack();
      }
      } on PlatformException catch (e) {
      isConnected = false;
    } on MissingPluginException {
      isConnected = false;
      setStatus('not implemented');
    }
  }

  Future<void> connectSpotifySdk() async {
    try {
      updateLoading(true);
      bool result = await _connectWithToken();
      setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
      if (result) {
        isLoading = false;
        isConnected = true;
        await playTrack();
      } else {
        updateLoading(false);
        throw Exception('Could not connect to your app Spotify');
      }
    } on PlatformException catch (e) {
      updateLoading(false);
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      updateLoading(false);
      setStatus('not implemented');
      rethrow;
    }
  }

  Stream<ConnectionStatus> subscribeConnection() =>
      SpotifySdk.subscribeConnectionStatus();

  void whenConnStatusChange(AsyncSnapshot snapshot) {
    isLoading = false;
    var data = snapshot.data;
    if (data != null) {
      isConnected = data.connected;
    }
  }

  void updateTrackFromSdk(String? newId) {
    try {
      if (newId != null) {
        trackApp = tracksList.firstWhere((track) => track.id == newId);
      }
    } on Error {
      isLoading = true;
      isConnected = true;
      playTrack();
    }
  }

  Stream<PlayerState> subscribePlayerState() =>
      SpotifySdk.subscribePlayerState();

  Future<void> playTrack() async {
    trackApp.indexSpotify == null
        ? await SpotifySdk.play(spotifyUri: 'spotify:track:' + trackApp.id)
        : await SpotifySdk.skipToIndex(
            spotifyUri: 'spotify:playlist:' + playlist.id,
            trackIndex: trackApp.indexSpotify!);
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }

//
// void updatePlayed(bool isPlayed) => _updateWith(isPlayed: isPlayed);
//
// void updateConnected(bool isConnected) =>
//     _updateWith(isConnected: isConnected);
//
  void updateLoading(bool isLoading) => _updateWith(isLoading: isLoading);

//
// void updatePosition(Duration position) => _updateWith(position: position);
//
// void updateDuration(Duration duration) => _updateWith(duration: duration);
//
// void updateTrack(TrackApp trackApp) => _updateWith(trackApp: trackApp);

  void _updateWith(
      {bool? isConnected,
      bool? isLoading,
      TrackApp? trackApp}) {
    this.isConnected = isConnected ?? this.isConnected;
    this.isLoading = isLoading ?? this.isLoading;
    this.trackApp = trackApp ?? this.trackApp;
    notifyListeners();
  }
}
