import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/widgets/logger.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class LibraryStatic {
  static final _logger = LoggerApp.logger;

  static Future<void> playTrack(TrackApp trackApp, Playlist playlist) async {
    trackApp.indexSpotify == null
        ? await SpotifySdk.play(spotifyUri: 'spotify:track:' + trackApp.id)
        : await SpotifySdk.skipToIndex(
            spotifyUri: 'spotify:playlist:' + playlist.id,
            trackIndex: trackApp.indexSpotify!);
  }

  static void setStatus(String code, {String? message}) {
    var text = message ?? '';
    _logger.i('$code$text');
  }
}
