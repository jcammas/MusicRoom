class APIPath {
  static String user(String uid) => 'user_info/$uid';

  static String users() => 'user_info/';

  static String playlist(String playlistId) => 'playlists/$playlistId';

  static String playlists() => 'playlists/';

  static String userPlaylist(String uid, String playlistId) => 'user_info/$uid/playlists/$playlistId';

  static String userPlaylists(String uid) => 'user_info/$uid/playlists/';

  static String spotifyProfile(String uid, String spotifyProfileId) =>
      'user_info/$uid/spotify_profile/$spotifyProfileId';

}
