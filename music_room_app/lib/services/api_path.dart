class APIPath {
  static String user(String uid) => 'users/$uid';
  static String users(String uid) => 'users/';
  static String playlist(String uid, String playlistId) =>
      'users/$uid/playlists/$playlistId';
  static String playlists(String uid) => 'users/$uid/playlists';
}