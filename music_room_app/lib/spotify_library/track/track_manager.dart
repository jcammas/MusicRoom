import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/widgets/spotify_constants.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/image_uri.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:logger/logger.dart';

class TrackManager with ChangeNotifier {
  TrackManager({required this.playlist, required this.trackApp, this.tracksList});

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
  ImageUri? trackImage;
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

  String? get trackSdkId => trackSdk == null ? null : trackSdk!.uri.split(':')[2];

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
      Platform.isIOS
          ? await secureStorage.write(key: 'SpotifySDKToken', value: newToken)
          : null;
      return newToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      setStatus('not implemented on this platform');
      rethrow;
    }
  }

  Future<bool> _connectToSpotifyIOS() async {
    try {
      token = token ?? await secureStorage.read(key: 'SpotifySDKToken');
      token = token ?? await _getAuthenticationToken();
      bool result = await SpotifySdk.connectToSpotifyRemote(
          clientId: spotifyClientId,
          redirectUrl: spotifyRedirectUri,
          accessToken: token);
      if (result == false) {
        return await _connectToSpotify();
      }
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _connectToSpotify() async {
    try {
      await _getAuthenticationToken();
      return await SpotifySdk.connectToSpotifyRemote(
          clientId: spotifyClientId, redirectUrl: spotifyRedirectUri);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      updateLoading(true);
      bool result = Platform.isIOS
          ? await _connectToSpotifyIOS()
          : await _connectToSpotify();
      setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
      if (result) {
        await SpotifySdk.play(spotifyUri: 'spotify:track:' + trackApp.id);
        _updateWith(isPlayed: true, isLoading: false, isConnected: true);
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
      isPlayed ? await SpotifySdk.pause() : await SpotifySdk.resume();
      updatePlayed(isPlayed ? false : true);
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

  double setChangedSlider() {
    // set to 0
    return 0.0;
  }

  void seekToSecond(int second) {
    // set to the received second
  }

  StreamBuilder<ConnectionStatus> getConnectionStreamBuilder(Widget child) {
    return StreamBuilder<ConnectionStatus>(
      stream: SpotifySdk.subscribeConnectionStatus(),
      builder: (context, snapshot) {
        isConnected = false;
        var data = snapshot.data;
        if (data != null) {
          isConnected = data.connected;
        }
        return child;
      },
    );
  }

  StreamBuilder<PlayerState> getPlayerStateStreamBuilder(Widget child) {
    return StreamBuilder<PlayerState>(
      stream: SpotifySdk.subscribePlayerState(),
      builder: (context, snapshot) {
        trackSdk = snapshot.data?.track;
        trackImage = trackSdk?.imageUri;
        if (playerState != snapshot.data) {
          if (snapshot.data == null || trackSdk == null) {
            updateLoading(true);
          } else {
            updateLoading(false);
          }
        }
        playerState = snapshot.data;
        return child;
      },
    );
  }

  Future<void> skipNext() async {
    try {
      bool takeNext = false;
      if (tracksList != null) {
        tracksList!.sort((lhs, rhs) => lhs.name.compareTo(rhs.name));
        for (TrackApp pTrack in tracksList!) {
          trackApp = takeNext ? pTrack : trackApp;
          if (takeNext) {
            _updateWith(trackApp :trackApp, isPlayed: true);
            await SpotifySdk.queue(spotifyUri: 'spotify:track:' + trackApp.id);
            await SpotifySdk.skipNext();
            break;
          }
          takeNext = pTrack.id == trackApp.id ? true : false;
        }
      }
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      setStatus('not implemented');
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> skipPrevious() async {
    try {
      bool takeNext = false;
      await SpotifySdk.skipPrevious();
      if (trackSdk != null) {
        if (trackSdkId != trackApp.id) {
          if (tracksList != null) {
            tracksList!.sort((lhs, rhs) => rhs.name.compareTo(lhs.name));
            for (TrackApp pTrack in tracksList!) {
              trackApp = takeNext ? pTrack : trackApp;
              if (takeNext) {
                _updateWith(trackApp: trackApp, isPlayed: true);
                break;
              }
              takeNext = pTrack.id == trackApp.id ? true : false;
            }
          }
        }
      }
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      setStatus('not implemented');
      rethrow;
    }
  }

  void updateAdded(bool isAdded) => _updateWith(isAdded: isAdded);

  void updatePlayed(bool isPlayed) => _updateWith(isPlayed: isPlayed);

  void updateConnected(bool isConnected) =>
      _updateWith(isConnected: isConnected);

  void updateLoading(bool isLoading) => _updateWith(isLoading: isLoading);

  void updatePosition(Duration position) => _updateWith(position: position);

  void updateDuration(Duration duration) => _updateWith(duration: duration);

  void updateTrack(TrackApp trackApp) => _updateWith(trackApp: trackApp);

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

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }
}
