class DBPath {
  static String users() => 'user_info/';

  static String playlists() => 'playlists/';

  static String tracks() => 'tracks_list/';

  static String spotifyProfiles() => 'spotify_profile/';

  static String devices() => 'devices/';

  static String rooms() => 'rooms/';

  static String chats() => 'chats/';
  
  static String messages() => 'messages/';

  static String user(String uid) => users() + uid;

  static String playlist(String playlistId) => playlists() + playlistId;

  static String track(String trackId) => tracks() + trackId;

  static String spotifyProfile(String spotifyProfileId) =>
      spotifyProfiles() + spotifyProfileId;

  static String device(String deviceId) => devices() + deviceId;

  static String room(String roomId) => rooms() + roomId;

  static String chatId(String uid1, String uid2) =>
      concatOrdered(uid1, uid2);

  static String chat(String uid1, String uid2) =>
      chats() + chatId(uid1, uid2);

  static String userPlaylist(String uid, String playlistId) =>
      user(uid) + '/' + playlist(playlistId);

  static String userPlaylists(String uid) => user(uid) + '/' + playlists();

  static String playlistTrack(String playlistId, String trackId) =>
      playlist(playlistId) + '/' + track(trackId);

  static String playlistTracks(String playlistId) =>
      playlist(playlistId) + '/' + tracks();

  static String chatMessages(String senderId, String receiverId) =>
      chat(senderId, receiverId) + '/' + messages();

  static String userPlaylistTrack(
          String uid, String playlistId, String trackId) =>
      user(uid) + '/' + playlist(playlistId) + '/' + track(trackId);

  static String userPlaylistTracks(String uid, String playlistId) =>
      user(uid) + '/' + playlist(playlistId) + '/' + tracks();

  static String userSpotifyProfile(String uid, String spotifyProfileId) =>
      user(uid) + '/' + spotifyProfile(spotifyProfileId);
  
  static String chatMessage(String senderId, String receiverId, String date) =>
      chatMessages(senderId, receiverId) + '/' + senderId + '-' + date;

  static String concatOrdered(String s1, String s2) {
    List<String> ls = [s1, s2];
    ls.sort();
    return ls.join('-');
  }
}
