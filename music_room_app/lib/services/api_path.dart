class APIPath {
  static String user(String uid) => 'user_info/$uid';

  static String users() => 'user_info/';

  static String playlist(String playlistId) => 'playlists/$playlistId';

  static String playlists() => 'playlists/';

  static String userPlaylist(String uid, String playlistId) => 'user_info/$uid/playlists/$playlistId';

  static String userPlaylists(String uid) => 'user_info/$uid/playlists/';

  static String track(String trackId) => 'tracks/$trackId';

  static String tracks() => 'tracks/';

  static String playlistTrack(String playlistId, String trackId) => '/playlists/$playlistId/tracks_list/$trackId';

  static String playlistTracks(String playlistId) => '/playlists/$playlistId/tracks_list/';

  static String userPlaylistTrack(String uid, String playlistId, String trackId) => 'user_info/$uid/playlists/$playlistId/tracks_list/$trackId';

  static String userPlaylistTracks(String uid, String playlistId) => 'user_info/$uid/playlists/$playlistId/tracks_list/';

  static String spotifyProfile(String uid, String spotifyProfileId) =>
      'user_info/$uid/spotify_profile/$spotifyProfileId';

}
