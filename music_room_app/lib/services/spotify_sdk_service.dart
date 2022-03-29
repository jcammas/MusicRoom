import 'dart:async';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify_constants.dart';
import 'package:music_room_app/widgets/logger.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifySdkService {
  static final _logger = LoggerApp.logger;

  static Future<bool> _connectToSpotifyRemote({String? token}) async =>
      SpotifySdk.connectToSpotifyRemote(
          clientId: spotifyClientId,
          redirectUrl: spotifyRedirectUri,
          accessToken: token);

  static Future<bool> checkConnection() async {
    try {
      return await _connectToSpotifyRemote();
    } on PlatformException {
      setStatus('not connected');
      return false;
    } on MissingPluginException {
      setStatus('not implemented');
      return false;
    }
  }

  static Future<String> _getTokenWithSdk() async {
    try {
      String token = await SpotifySdk.getAuthenticationToken(
          clientId: spotifyClientId,
          redirectUrl: spotifyRedirectUri,
          scope: spotifyScopes.toString());
      setStatus('Got a token: $token');
      return token;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      setStatus('not implemented on this platform');
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> _connectSpotifySdk(String? token) async {
    try {
      bool result = await _connectToSpotifyRemote(token: token);
      if (result) {
        setStatus('connection to spotify successful');
      } else {
        throw PlatformException(
            code: 'connection failed',
            message: 'Could not connect to your app Spotify');
      }
    } on MissingPluginException {
      setStatus('not implemented on this platform');
      rethrow;
    } catch (e) {
      setStatus('connection to spotify failed');
      rethrow;
    }
  }

  static Future<String?> connectSpotifySdk(String? token) async {
    try {
      await _connectSpotifySdk(token);
      return token;
    } on PlatformException {
      try {
        token = await _getTokenWithSdk();
        await _connectSpotifySdk(token);
        return token;
      } catch (e) {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> disconnect() async {
    try {
      await SpotifySdk.disconnect();
    } on PlatformException catch (e) {
      SpotifySdkService.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkService.setStatus('not implemented');
    }
  }

  static StreamSubscription<ConnectionStatus>? subscribeConnectionStatus(
      {required void onData(ConnectionStatus event),
      required void onError(Object error)}) {
    try {
      return SpotifySdk.subscribeConnectionStatus()
          .listen(onData, onError: onError);
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  static StreamSubscription<PlayerState>? subscribePlayerState(
      {required void onData(PlayerState event),
      void Function(Object error)? onError}) {
    try {
      return SpotifySdk.subscribePlayerState().listen(onData, onError: onError);
    } on PlatformException {
      return null;
    } on MissingPluginException {
      return null;
    }
  }

  static Future<String> getTokenWithSdk() async {
    try {
      String token = await SpotifySdk.getAuthenticationToken(
          clientId: spotifyClientId,
          redirectUrl: spotifyRedirectUri,
          scope: spotifyScopes.toString());
      SpotifySdkService.setStatus('Got a token: $token');
      return token;
    } on PlatformException catch (e) {
      SpotifySdkService.setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      SpotifySdkService.setStatus('not implemented on this platform');
      rethrow;
    }
  }

  static Future<void> playTrackInPlaylist(
      TrackApp trackApp, Playlist playlist) async {
    try {
      trackApp.indexSpotify == null
          ? await SpotifySdk.play(spotifyUri: 'spotify:track:' + trackApp.id)
          : await SpotifySdk.skipToIndex(
              spotifyUri: 'spotify:playlist:' + playlist.id,
              trackIndex: trackApp.indexSpotify!);
    } on PlatformException catch (e) {
      SpotifySdkService.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkService.setStatus('not implemented');
    }
  }

  static Future<void> playTrack(TrackApp trackApp) async {
    try {
      await SpotifySdk.play(spotifyUri: 'spotify:track:' + trackApp.id);
    } on PlatformException catch (e) {
      SpotifySdkService.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkService.setStatus('not implemented');
    }
  }

  static togglePlay(bool isPaused) async {
    try {
      isPaused ? await SpotifySdk.resume() : await SpotifySdk.pause();
    } on PlatformException catch (e) {
      SpotifySdkService.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkService.setStatus('not implemented');
    }
  }

  static Future<void> toggleShuffle() async {
    try {
      await SpotifySdk.toggleShuffle();
    } on PlatformException catch (e) {
      SpotifySdkService.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkService.setStatus('not implemented');
    }
  }

  static Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
      SpotifySdkService.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkService.setStatus('not implemented');
    }
  }

  static TrackApp updateTrackFromSdk(
      TrackApp trackApp, List<TrackApp> tracksList, String? newId) {
    if (newId != null) {
      return tracksList.firstWhere((track) => track.id == newId,
          orElse: () => trackApp);
    }
    return trackApp;
  }

  static TrackApp? loadOrUpdateTrackFromSdk(
      TrackApp? trackApp, List<TrackApp>? tracksList, String? newId) {
    if (newId != null && tracksList != null) {
      try {
        return tracksList.firstWhere((track) => track.id == newId);
      } catch (e) {
        return null;
      }
    }
    return trackApp;
  }

  static Future<Duration> seekTo(int milliseconds) async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: milliseconds);
    } on PlatformException catch (e) {
      SpotifySdkService.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkService.setStatus('not implemented');
    }
    return Duration(milliseconds: milliseconds);
  }

  static Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
    } on PlatformException catch (e) {
      SpotifySdkService.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkService.setStatus('not implemented');
    }
  }

  static Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
    } on PlatformException catch (e) {
      SpotifySdkService.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkService.setStatus('not implemented');
    }
  }

  static Future<void> skipToIndex(String playlistId, int nextIndex) async {
    try {
      await SpotifySdk.skipToIndex(
          spotifyUri: 'spotify:playlist:' + playlistId,
          trackIndex: nextIndex);
    } on PlatformException catch (e) {
      SpotifySdkService.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkService.setStatus('not implemented');
    }
  }


  static void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }
}
