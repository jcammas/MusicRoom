import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/widgets/spotify_constants.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:logger/logger.dart';

class TrackManager with ChangeNotifier {
  TrackManager(
      {required this.playlist, required this.trackApp, this.tracksList});

  final Playlist playlist;
  final List<TrackApp>? tracksList;
  TrackApp trackApp;
  Track? trackSdk;
  String? token;
  bool isAdded = false;
  bool isPlayed = false;
  bool isConnected = false;
  bool isLoading = false;
  Duration duration = const Duration();
  Duration position = const Duration();
  ConnectionStatus? previousConnStatus;
  PlayerState? playerState;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late Timer _timer;
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

  initTimer() {
    _timer = Timer.periodic(
    const Duration(seconds: 1),
    updatePositionOneSecond
    );
  }

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

  _tryConnectToSpotify({String? token}) async =>
      SpotifySdk.connectToSpotifyRemote(
          clientId: spotifyClientId,
          redirectUrl: spotifyRedirectUri,
          accessToken: token);

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

  Future<void> checkConnection() async {
    try {
      initTimer();
      if (await _tryConnectToSpotify()) {
        isConnected = true;
        await playTrack();
      } else {
        isConnected = false;
      }
    } catch (e) {
      isConnected = false;
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
        isPlayed = true;
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

  toggleAdded() => updateAdded(isAdded == true ? false : true);

  togglePlay() async {
    try {
      isPlayed = isPlayed ? false : true;
      isPlayed ? await SpotifySdk.resume() : await SpotifySdk.pause();
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      setStatus('not implemented');
      rethrow;
    }
  }

  Widget? returnImage() {
    if (trackApp.album != null) {
      if (trackApp.album!['images'] != null) {
        if (trackApp.album!['images'].isNotEmpty) {
          if (trackApp.album!['images'].first['url'] != null) {
            return Image.network(trackApp.album!['images'].first['url']);
          }
        }
      }
    }
    return Image.asset('images/spotify-question-marks.jpeg');
  }

  String returnArtist() {
    if (trackApp.artists != null) {
      if (trackApp.artists!.isNotEmpty) {
        if (trackApp.artists!.first['name'] != null) {
          return trackApp.artists!.first['name'];
        }
      }
    }
    return 'Unknown';
  }

  String returnName() => trackApp.name;


  Stream<ConnectionStatus> subscribeConnection() =>
      SpotifySdk.subscribeConnectionStatus();

  void whenConnStatusChange(AsyncSnapshot snapshot) {
    isLoading = false;
    var data = snapshot.data;
    if (data != null) {
      isConnected = data.connected;
    }
  }

  void updatePositionOneSecond(Timer timer) {
    position += const Duration(seconds: 1);
    // notifyListeners();
  }

  void updateTrackFromSdk(String? newId) {
    try {
      if (tracksList != null && newId != null) {
        trackApp = tracksList!.firstWhere((track) => track.id == newId);
      }
    } on Error {
      isPlayed = true;
      isLoading = true;
      isConnected = true;
      playTrack();
    }
  }

  Stream<PlayerState> subscribePlayerState() =>
      SpotifySdk.subscribePlayerState();

  void whenPlayerStateChange(AsyncSnapshot snapshot) {
    trackSdk = snapshot.data?.track;
    if (playerState != snapshot.data) {
      if (snapshot.data == null || trackSdk == null) {
        isLoading = true;
      } else {
        isLoading = false;
      }
    }
    if (trackSdk != null) {
      duration = Duration(milliseconds: trackSdk!.duration);
      if (trackApp.id != trackSdkId) {
        updateTrackFromSdk(trackSdkId);
      }
    }
    playerState = snapshot.data;
    if (playerState != null) {
      isPlayed = !playerState!.isPaused;
      position = Duration(milliseconds: playerState!.playbackPosition);
    }
  }

  Future<void> playTrack() async {
    trackApp.indexSpotify == null
        ? await SpotifySdk.play(spotifyUri: 'spotify:track:' + trackApp.id)
        : await SpotifySdk.skipToIndex(
            spotifyUri: 'spotify:playlist:' + playlist.id,
            trackIndex: trackApp.indexSpotify!);
    initTimer();
  }

  int _findNextSpotifyIndex() {
    int? indexSpotify;
    if (tracksList != null && trackApp.indexApp != null) {
      if (trackApp.indexApp! + 1 == tracksList!.length) {
        indexSpotify =
            tracksList!.firstWhere((track) => track.indexApp == 0).indexSpotify;
      } else {
        indexSpotify = tracksList!
            .firstWhere((track) => track.indexApp == trackApp.indexApp! + 1)
            .indexSpotify;
      }
      return indexSpotify ?? 0;
    } else {
      return 0;
    }
  }

  Future<void> skipNext() async {
    try {
      await SpotifySdk.skipNext();
      // await SpotifySdk.skipToIndex(
      //     spotifyUri: 'spotify:playlist:' + playlist.id,
      //     trackIndex: _findNextSpotifyIndex());
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      setStatus('not implemented');
      rethrow;
    }
  }

  int _findPreviousSpotifyIndex() {
    int? indexSpotify;
    if (tracksList != null && trackApp.indexApp != null) {
      if (trackApp.indexApp! == 0) {
        indexSpotify = tracksList!
            .firstWhere((track) => track.indexApp! + 1 == tracksList!.length)
            .indexSpotify;
      } else {
        indexSpotify = tracksList!
            .firstWhere((track) => track.indexApp == trackApp.indexApp! - 1)
            .indexSpotify;
      }
      return indexSpotify ?? 0;
    } else {
      return 0;
    }
  }

  Future<void> skipPrevious() async {
    try {
      await SpotifySdk.skipPrevious();
      // await SpotifySdk.skipToIndex(
      //     spotifyUri: 'spotify:playlist:' + playlist.id,
      //     trackIndex: _findPreviousSpotifyIndex());
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      setStatus('not implemented');
      rethrow;
    }
  }

  double? resetSlider() {
    try {
      seekTo(0);
      return 0.0;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekTo(int milliseconds) async {
    try {
      await SpotifySdk.seekTo(positionedMilliseconds: milliseconds);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  Future<void> seekToRelative(int milliseconds) async {
    try {
      await SpotifySdk.seekToRelativePosition(relativeMilliseconds: milliseconds);
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      setStatus('not implemented');
    }
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }

  void updateAdded(bool isAdded) => _updateWith(isAdded: isAdded);

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
      {bool? isAdded,
      bool? isPlayed,
      bool? isConnected,
      bool? isLoading,
      Duration? position,
      Duration? duration,
      TrackApp? trackApp}) {
    this.isAdded = isAdded ?? this.isAdded;
    this.isPlayed = isPlayed ?? this.isPlayed;
    this.isConnected = isConnected ?? this.isConnected;
    this.isLoading = isLoading ?? this.isLoading;
    this.position = position ?? this.position;
    this.duration = duration ?? this.duration;
    this.trackApp = trackApp ?? this.trackApp;
    notifyListeners();
  }

  exitPage(BuildContext context) {
    _timer.cancel();
    Navigator.of(context).pop();
  }
}
