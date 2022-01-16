class DBPath {
  static String users() => 'user_info/';

  static String playlists() => 'playlists/';

  static String tracks() => 'tracks_list/';

  static String spotifyProfiles() => 'spotify_profile/';

  static String devices() => 'devices/';

  static String rooms() => 'rooms/';

  static String user(String uid) => users() + uid;

  static String playlist(String playlistId) => playlists() + playlistId;

  static String track(String trackId) => tracks() + trackId;

  static String spotifyProfile(String spotifyProfileId) =>
      spotifyProfiles() + spotifyProfileId;

  static String device(String deviceId) => devices() + deviceId;

  static String room(String roomId) => rooms() + roomId;

  static String userPlaylist(String uid, String playlistId) =>
      user(uid) + '/' + playlist(playlistId);

  static String userPlaylists(String uid) => user(uid) + '/' + playlists();

  static String playlistTrack(String playlistId, String trackId) =>
      playlist(playlistId) + '/' + track(trackId);

  static String playlistTracks(String playlistId) =>
      playlist(playlistId) + '/' + tracks();

  static String userPlaylistTrack(
          String uid, String playlistId, String trackId) =>
      user(uid) + '/' + playlist(playlistId) + '/' + track(trackId);

  static String userPlaylistTracks(String uid, String playlistId) =>
      user(uid) + '/' + playlist(playlistId) + '/' + tracks();

  static String userSpotifyProfile(String uid, String spotifyProfileId) => user(uid) + '/' + spotifyProfile(spotifyProfileId);

}
