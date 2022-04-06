class DBPath {
  static String users() => 'user_info/';

  static String relationLinks() => 'relation_links/';

  static String playlists() => 'playlists/';

  static String tracks() => 'tracks_list/';

  static String spotifyProfiles() => 'spotify_profile/';

  static String devices() => 'devices/';

  static String rooms() => 'rooms/';

  static String chats() => 'chats/';

  static String messages() => 'messages/';

  static String user(String uid) => users() + uid;

  static String relationLink(String uid) => relationLinks() + uid;

  static String playlist(String playlistId) => playlists() + playlistId;

  static String track(String trackId) => tracks() + trackId;

  static String spotifyProfile(String spotifyProfileId) =>
      spotifyProfiles() + spotifyProfileId;

  static String device(String deviceId) => devices() + deviceId;

  static String room(String roomId) => rooms() + roomId;

  static String chatId(String uid1, String uid2) => concatOrdered(uid1, uid2);

  static String chat(String uid1, String uid2) => chats() + chatId(uid1, uid2);

  static String roomTracks(String roomId) => room(roomId) + '/' + tracks();

  static String userPlaylists(String uid) => user(uid) + '/' + playlists();

  static String userSpotifyProfiles(String uid) =>
      user(uid) + '/' + spotifyProfiles();

  static String playlistTracks(String playlistId) =>
      playlist(playlistId) + '/' + tracks();

  static String chatMessages(String uid1, String uid2) =>
      chat(uid1, uid2) + '/' + messages();

  static String userPlaylistTracks(String uid, String playlistId) =>
      userPlaylist(uid, playlistId) + '/' + tracks();

  static String userPlaylist(String uid, String playlistId) =>
      userPlaylists(uid) + playlistId;

  static String playlistTrack(String playlistId, String trackId) =>
      playlistTracks(playlistId) + trackId;

  static String roomTrack(String roomId, String trackId) =>
      roomTracks(roomId) + trackId;

  static String userPlaylistTrack(
          String uid, String playlistId, String trackId) =>
      userPlaylistTracks(uid, playlistId) + trackId;

  static String userSpotifyProfile(String uid, String spotifyProfileId) =>
      userSpotifyProfiles(uid) + spotifyProfileId;

  static String chatMessage(String senderId, String receiverId, String date) =>
      chatMessages(senderId, receiverId) + senderId + '_' + date;

  static String concatOrdered(String s1, String s2) {
    List<String> ls = [s1, s2];
    ls.sort();
    return ls.join('_');
  }
}

class StoragePath {
  static String userAvatars() => 'user_avatars/';

  static String userAvatar(String uid) => userAvatars() + uid + '.jpg';
}
