import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class LibraryStatic {

  static Future<void> playTrack(TrackApp trackApp, Playlist playlist) async {
    trackApp.indexSpotify == null
        ? await SpotifySdk.play(spotifyUri: 'spotify:track:' + trackApp.id)
        : await SpotifySdk.skipToIndex(
        spotifyUri: 'spotify:playlist:' + playlist.id,
        trackIndex: trackApp.indexSpotify!);
  }
}
