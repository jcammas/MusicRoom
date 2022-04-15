import 'dart:async';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify_constants.dart';
import 'package:music_room_app/widgets/logger.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class SpotifySdkStatic {
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
      SpotifySdkStatic.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkStatic.setStatus('not implemented');
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
      SpotifySdkStatic.setStatus('Got a token: $token');
      return token;
    } on PlatformException catch (e) {
      SpotifySdkStatic.setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      SpotifySdkStatic.setStatus('not implemented on this platform');
      rethrow;
    }
  }

  // static Future<void> playTrackInPlaylist(
  //     TrackApp trackApp, Playlist playlist) async {
  //   trackApp.indexSpotify == null
  //       ? await playTrackBySpotifyUri('spotify:track:' + trackApp.id)
  //       : await skipToIndex(playlist.id, trackApp.indexSpotify!);
  // }

  static Future<void> playTrack(TrackApp trackApp) async =>
      await playTrackBySpotifyUri('spotify:track:' + trackApp.id);

  static Future<void> playTrackBySpotifyUri(String? spotifyUri) async {
    if (spotifyUri != null) {
      try {
        await SpotifySdk.play(spotifyUri: spotifyUri);
      } on PlatformException catch (e) {
        SpotifySdkStatic.setStatus(e.code, message: e.message);
      } on MissingPluginException {
        SpotifySdkStatic.setStatus('not implemented');
      }
    }
  }

  static togglePlay(bool? pause) async {
    try {
      pause = pause ?? false;
      pause ? await SpotifySdk.pause() : await SpotifySdk.resume();
    } on PlatformException catch (e) {
      SpotifySdkStatic.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkStatic.setStatus('not implemented');
    }
  }

  // static Future<void> toggleShuffle() async {
  //   try {
  //     await SpotifySdk.toggleShuffle();
  //   } on PlatformException catch (e) {
  //     SpotifySdkService.setStatus(e.code, message: e.message);
  //   } on MissingPluginException {
  //     SpotifySdkService.setStatus('not implemented');
  //   }
  // }

  static Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
      SpotifySdkStatic.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkStatic.setStatus('not implemented');
    }
  }

  static TrackApp findNewTrackApp(
      TrackApp trackApp, List<TrackApp> tracksList, String? newId) {
    if (newId != null) {
      return tracksList.firstWhere((track) => track.id == newId,
          orElse: () => trackApp);
    }
    return trackApp;
  }

  static Future<Duration> seekTo(int? milliseconds) async {
    milliseconds = milliseconds ?? 0;
    try {
    await SpotifySdk.seekTo(positionedMilliseconds: milliseconds);
    } on PlatformException catch (e) {
      SpotifySdkStatic.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkStatic.setStatus('not implemented');
    }
    return Duration(milliseconds: milliseconds);
  }

  // static Future<void> skipNext() async {
  //   try {
  //     await SpotifySdk.skipNext();
  //   } on PlatformException catch (e) {
  //     SpotifySdkService.setStatus(e.code, message: e.message);
  //   } on MissingPluginException {
  //     SpotifySdkService.setStatus('not implemented');
  //   }
  // }

  // static Future<void> skipPrevious() async {
  //   try {
  //     await SpotifySdk.skipPrevious();
  //   } on PlatformException catch (e) {
  //     SpotifySdkService.setStatus(e.code, message: e.message);
  //   } on MissingPluginException {
  //     SpotifySdkService.setStatus('not implemented');
  //   }
  // }

  // static Future<void> skipToIndex(String playlistId, int nextIndex) async {
  //   try {
  //     await SpotifySdk.skipToIndex(
  //         spotifyUri: 'spotify:playlist:' + playlistId, trackIndex: nextIndex);
  //   } on PlatformException catch (e) {
  //     SpotifySdkService.setStatus(e.code, message: e.message);
  //   } on MissingPluginException {
  //     SpotifySdkService.setStatus('not implemented');
  //   }
  // }

  static void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }
}