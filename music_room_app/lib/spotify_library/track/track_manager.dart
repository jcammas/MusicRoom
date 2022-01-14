import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/widgets/spotify_constants.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:logger/logger.dart';

class TrackManager with ChangeNotifier {
  TrackManager({required this.playlist, required this.track});

  final Playlist playlist;
  final Track track;
  bool isAdded = false;
  bool isPlayed = false;
  bool isConnected = false;
  bool isLoading = false;
  Duration duration = const Duration();
  Duration position = const Duration();
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

  Future<String> _getAuthenticationToken() async {
    try {
      var authenticationToken = await SpotifySdk.getAuthenticationToken(
          clientId: spotifyClientId,
          redirectUrl: spotifyRedirectUri,
          scope: 'app-remote-control, '
              'user-modify-playback-state, '
              'playlist-read-private, '
              'playlist-modify-public,user-read-currently-playing');
      setStatus('Got a token: $authenticationToken');
      return authenticationToken;
    } on PlatformException catch (e) {
      setStatus(e.code, message: e.message);
      rethrow;
    } on MissingPluginException {
      setStatus('not implemented on this platform');
      rethrow;
    }
  }

  Future<void> connectToSpotifyRemote() async {
    try {
      updateLoading(true);
      await _getAuthenticationToken();
      var result = await SpotifySdk.connectToSpotifyRemote(
          clientId: spotifyClientId, redirectUrl: spotifyRedirectUri);
      setStatus(result
          ? 'connect to spotify successful'
          : 'connect to spotify failed');
      updateLoading(false);
    } on PlatformException catch (e) {
      updateLoading(false);
      setStatus(e.code, message: e.message);
    } on MissingPluginException {
      updateLoading(false);
      setStatus('not implemented');
    }
  }

  toggleLike() => updateAdded(isAdded == true ? false : true);

  togglePlay() => updatePlayed(isPlayed == true ? false : true);

  Widget? returnImage() {
    if (track.album != null) {
      if (track.album!['images'] != null) {
        if (track.album!['images'].isNotEmpty) {
          if (track.album!['images'].first['url'] != null) {
            return Image.network(track.album!['images'].first['url']);
          }
        }
      }
    }
    return Image.asset('images/spotify-question-marks.jpeg');
  }

  String returnArtist() {
    if (track.artists != null) {
      if (track.artists!.isNotEmpty) {
        if (track.artists!.first['name'] != null) {
          return track.artists!.first['name'];
        }
      }
    }
    return 'Unknown';
  }

  double setChangedSlider() {
    // set to 0
    return 0.0;
  }

  void seekToSecond(int second) {
    // set to the received second
  }

  StreamBuilder<ConnectionStatus> getStreamBuilder(Widget child) {
    return StreamBuilder<ConnectionStatus>(
      stream: SpotifySdk.subscribeConnectionStatus(),
      builder: (context, snapshot) {
        isConnected= false;
        var data = snapshot.data;
        if (data != null) {
          isConnected = data.connected;
        }
        return child;
      },
    );
  }

  void updateAdded(bool isAdded) => _updateWith(isAdded: isAdded);

  void updatePlayed(bool isPlayed) => _updateWith(isPlayed: isPlayed);

  void updateConnected(bool isConnected) =>
      _updateWith(isConnected: isConnected);

  void updateLoading(bool isLoading) => _updateWith(isLoading: isLoading);

  void updatePosition(Duration position) => _updateWith(position: position);

  void updateDuration(Duration duration) => _updateWith(duration: duration);

  void _updateWith(
      {bool? isAdded, bool? isPlayed, bool? isConnected, bool? isLoading, Duration? position, Duration? duration}) {
    this.isAdded = isAdded ?? this.isAdded;
    this.isPlayed = isPlayed ?? this.isPlayed;
    this.isConnected = isConnected ?? this.isConnected;
    this.isLoading = isLoading ?? this.isLoading;
    this.position = position ?? this.position;
    this.duration = duration ?? this.duration;
    notifyListeners();
  }

  void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }
}
