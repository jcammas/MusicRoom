class APIPath {
  static String user(String uid) => 'user_info/$uid';
  static String users(String uid) => 'user_info/';
  static String playlist(String uid, String playlistId) =>
      'user_info/$uid/playlists/$playlistId';
  static String playlists(String uid) => 'user_info/$uid/playlists';
}