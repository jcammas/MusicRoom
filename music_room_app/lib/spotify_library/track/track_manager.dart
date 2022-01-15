import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify.dart';
import 'package:music_room_app/services/spotify_constants.dart';
import 'package:music_room_app/widgets/logger.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'library_static.dart';

class TrackManager with ChangeNotifier {
  TrackManager(
      {required this.playlist,
      required this.trackApp,
      required this.tracksList,
      required this.spotify}) {
    initManager();
  }

  final Playlist playlist;
  final List<TrackApp> tracksList;
  TrackApp trackApp;
  String? token;
  bool isConnected = false;
  bool isLoading = false;
  ConnectionStatus? connStatus;
  StreamSubscription<ConnectionStatus>? connStatusSubscription;
  Spotify spotify;
  final _logger = LoggerApp.logger;

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }

  void initManager() {
    checkConnection();
    try {
      connStatusSubscription =
          SpotifySdk.subscribeConnectionStatus().listen(whenConnStatusChange);
    } on PlatformException {
      connStatusSubscription = null;
    } on MissingPluginException {
      connStatusSubscription = null;
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
      }
    } on PlatformException {
      isConnected = false;
      setStatus('not connected');
    } on MissingPluginException {
      isConnected = false;
      setStatus('not implemented');
    }
  }

  void playIfConnected() {
    if (isConnected) {
      LibraryStatic.playTrack(trackApp, playlist);
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
      setStatus('Got a token: $token');
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      setStatus('not implemented on this platform');
      rethrow;
    }
  }

  Future<void> _connectSpotifySdk() async {
    try {
      bool result = await _tryConnectToSpotify(token: token);
      setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
      if (result) {
        updateWith(isLoading: false, isConnected: true);
        await LibraryStatic.playTrack(trackApp, playlist);
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
    } on PlatformException catch (e) {
      if (e.code == 'NotLoggedInException') {
        try {
          await _getTokenWithSdk();
          await _connectSpotifySdk();
        } on PlatformException catch (e) {
          updateWith(isLoading: false, isConnected: false);
          setStatus(e.code, message: e.message);
          rethrow;
        } catch (e) {
          updateWith(isLoading: false, isConnected: false);
          rethrow;
        }
      } else {
        rethrow;
      }
    } on MissingPluginException {
      updateWith(isLoading: false, isConnected: false);
      setStatus('not implemented');
      rethrow;
    } catch (e) {
      updateWith(isLoading: false, isConnected: false);
      rethrow;
    }
  }

  void whenConnStatusChange(ConnectionStatus newStatus) =>
      updateConnected(newStatus.connected);

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
    if (connStatusSubscription != null) {
      connStatusSubscription!.cancel();
    }
    super.dispose();
  }
}
