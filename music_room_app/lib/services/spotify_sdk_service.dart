import 'dart:async';
import 'package:flutter/services.dart';
import 'package:music_room_app/services/spotify_constants.dart';
import 'package:music_room_app/services/spotify_service_subscriber.dart';
import 'package:music_room_app/services/spotify_web.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import '../home/models/room.dart';
import '../home/models/track.dart';
import '../widgets/logger.dart';
import 'database.dart';

class SpotifySdkService {
  SpotifySdkService({required this.db, required this.spotifyWeb});

  List<TrackApp>? _currentTracksList;
  TrackApp? _currentTrack;
  Room? currentRoom;
  StreamSubscription<ConnectionStatus>? connStatusSubscription;
  StreamSubscription<PlayerState>? playerStateSubscription;
  List<SpotifyServiceSubscriber> _subscribers = List.empty(growable: true);
  bool isConnected = false;
  bool isStarting = true;
  SpotifyWebService spotifyWeb;
  Database db;
  String? token;

  set currentTracksList(List<TrackApp> ls) => _currentTracksList = ls;

  TrackApp? get currentTrack => _currentTrack;

  Future<void> playTrack(TrackApp trackApp) async {
    isStarting = true;
    await SpotifySdkStatic.playTrack(trackApp);
  }

  Future<void> togglePlay(bool? pause) async =>
      await SpotifySdkStatic.togglePlay(pause);

  Future<Duration> seekTo(int? milliseconds) async =>
      await SpotifySdkStatic.seekTo(milliseconds);

  Future<void> playRoomCurrentTrack() async {
    isStarting = true;
    await SpotifySdkStatic.playTrackBySpotifyUri(
        currentRoom?.playerState?.track?.uri);
    SpotifySdkStatic.seekTo(currentRoom?.playerState?.track?.duration);
    SpotifySdkStatic.togglePlay(currentRoom?.playerState?.isPaused);
  }

  String? getIdFromUri(String? uri) {
    if (uri == null) return null;
    List split = uri.split(':');
    if (split.length != 3) return null;
    return split[2];
  }

  void addSubscriber(SpotifyServiceSubscriber subscriber) {
    _subscribers.add(subscriber);
    _currentTracksList = subscriber.tracksList;
  }

  void disposeSubscriber(SpotifyServiceSubscriber subscriber) =>
      _subscribers.remove(subscriber);

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

  List<TrackApp>? indexedTracksList() {
    List<TrackApp>? ls = _currentTracksList;
    if (ls == null) return null;
    int i = 0;
    int len = ls.length;
    while (++i < len) {
      if (ls[i - 1].indexApp > ls[i].indexApp) {
        ls.sort((t1, t2) => t1.indexApp.compareTo(t2.indexApp));
        break;
      }
      ;
    }
    i = -1;
    while (++i < len) {
      ls[i].indexApp = i;
    }
    return ls;
  }

  TrackApp? findNextTrack() {
    final currentTrack = _currentTrack;
    final tracksList = indexedTracksList();
    if (currentTrack == null || tracksList == null) return null;
    final len = tracksList.length;
    int i = -1;
    while (++i < len) {
      if (tracksList[i].id == currentTrack.id) {
        return i == len - 1 ? tracksList[0] : tracksList[i + 1];
      }
    }
    return null;
  }

  TrackApp? findPreviousTrack() {
    final currentTrack = _currentTrack;
    final tracksList = indexedTracksList();
    if (currentTrack == null || tracksList == null) return null;
    final len = tracksList.length;
    int i = -1;
    while (++i < len) {
      if (tracksList[i].id == currentTrack.id) {
        return i == 0 ? tracksList[len - 1] : tracksList[i - 1];
      }
    }
    return null;
  }

  TrackApp? getNewTrackApp(Track? track) {
    String? newId = getIdFromUri(track?.uri);
      try {
        return _currentTracksList?.where((track) => track.id == newId).first;
      } on StateError {
        SpotifySdkStatic.setStatus("could not get currentTrack in SpotifySdkService");
      }
    return _currentTrack;
  }

  void whenPlayerStateChange(PlayerState newState) {
    Track? newTrack = newState.track;
    if (newTrack != null && getIdFromUri(newTrack.uri) != _currentTrack?.id) {
      _currentTrack = getNewTrackApp(newTrack);
    }
    if (isStarting) {
      isStarting = 10 * newState.playbackPosition >
              (newTrack == null ? 0 : newTrack.duration) * 9
          ? false
          : true;
    } else if (newState.playbackPosition == 0) {
      isStarting = true;
      final nextTrack = findNextTrack();
      if (nextTrack != null) {
        SpotifySdkStatic.playTrack(nextTrack);
      }
    }
    Room? room = currentRoom;
    if (room != null) db.updateRoomPlayerState(room, newState);
    for (SpotifyServiceSubscriber subscriber in _subscribers) {
      subscriber.whenPlayerStateChange(newState);
    }
  }

  void whenConnStatusChange(ConnectionStatus newStatus) {
    isConnected = newStatus.connected;
    playerStateSubscription =
        SpotifySdkStatic.subscribePlayerState(onData: whenPlayerStateChange);
    for (SpotifyServiceSubscriber subscriber in _subscribers) {
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

  void cleanRoom() {
    currentRoom = null;
    _currentTracksList = null;
  }
}

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

  static Future<void> toggleRepeat() async {
    try {
      await SpotifySdk.toggleRepeat();
    } on PlatformException catch (e) {
      SpotifySdkStatic.setStatus(e.code, message: e.message);
    } on MissingPluginException {
      SpotifySdkStatic.setStatus('not implemented');
    }
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

  static void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }
}
