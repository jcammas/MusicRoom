import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/spotify_profile.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/home/models/user.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Future<void> setUser(UserApp user);

  Future<void> deleteUser({UserApp user});

  Stream<List<UserApp>> usersStream();

  Stream<UserApp> userStream({UserApp? user});

  Future<List<UserApp>> getUsersList();

  Future<UserApp> getUser();

  Future<bool> userExists({UserApp? user});

  Future<void> updateUser(UserApp user);

  Future<void> savePlaylist(Playlist playlist);

  Future<void> savePlaylists(List<Playlist> playlists);

  Future<void> deleteUserPlaylist(Playlist playlist, {UserApp? user});

  Future<void> setUserPlaylist(Playlist playlist, {UserApp? user});

  Future<void> setUserPlaylists(List<Playlist> playlists, {UserApp? user});

  Future<void> setSpotifyProfile(SpotifyProfile profile);

  Stream<List<Playlist>> playlistsStream({UserApp? user});

  Future<List<Playlist>> getUserPlaylists({UserApp? user});

  Future<void> saveTrack(Track track);

  Future<void> saveTracks(List<Track> tracks);

  Future<void> setPlaylistTrack(Track track, Playlist playlist);

  Future<void> setPlaylistTracks(List<Track> tracks, Playlist playlist);

  Future<void> setUserPlaylistTrack(Track track, Playlist playlist,
      {UserApp? user});

  Future<void> setUserPlaylistTracks(List<Track> tracks, Playlist playlist,
      {UserApp? user});

  set uid(String uid);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase();

  late String _uid;

  final _service = FirestoreService.instance;

  @override
  set uid(String uid) => _uid = uid;

  @override
  Future<void> setUser(UserApp user) async => await _service.setDocument(
        path: APIPath.user(_uid),
        data: user.toMap(),
      );

  @override
  Future<void> updateUser(UserApp user) async => await _service.updateDocument(
        path: APIPath.user(_uid),
        data: user.toMap(),
      );

  @override
  Future<void> setSpotifyProfile(SpotifyProfile profile) async =>
      await _service.setDocumentWithMergeOption(
        path: APIPath.spotifyProfile(_uid, profile.id),
        data: profile.toMap(),
      );

  @override
  Future<bool> userExists({UserApp? user}) async => await _service
      .documentExists(path: APIPath.user(user == null ? _uid : user.uid));

  @override
  Future<void> deleteUser({UserApp? user}) async {
    await _service.deleteDocument(
        path: APIPath.user(user == null ? _uid : user.uid));
  }

  @override
  Stream<UserApp> userStream({UserApp? user}) => _service.documentStream(
        path: APIPath.user(user == null ? _uid : user.uid),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
      );

  @override
  Stream<List<UserApp>> usersStream() => _service.collectionStream(
        path: APIPath.users(),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
      );

  @override
  Future<List<UserApp>> getUsersList() async => await _service.getCollection(
        path: APIPath.users(),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
      );

  @override
  Future<UserApp> getUser({UserApp? user}) async => await _service.getDocument(
        path: APIPath.user(user == null ? _uid : user.uid),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
      );

  @override
  Future<void> savePlaylist(Playlist playlist) async =>
      await _service.setDocumentWithMergeOption(
          path: APIPath.playlist(playlist.id), data: playlist.toMap());

  @override
  Future<void> savePlaylists(List<Playlist> playlists) async {
    for (var playlist in playlists) {
      await savePlaylist(playlist);
    }
  }

  @override
  Future<void> deleteUserPlaylist(Playlist playlist, {UserApp? user}) async {
    await _service.deleteDocument(
        path:
            APIPath.userPlaylist(user == null ? _uid : user.uid, playlist.id));
  }

  @override
  Future<void> setUserPlaylist(Playlist playlist, {UserApp? user}) async {
    await _service.setDocumentWithMergeOption(
      path: APIPath.userPlaylist(user == null ? _uid : user.uid, playlist.id),
      data: playlist.toMap(),
    );
  }

  @override
  Future<void> setUserPlaylists(List<Playlist> playlists,
      {UserApp? user}) async {
    for (var playlist in playlists) {
      await setUserPlaylist(playlist, user: user);
    }
  }

  @override
  Stream<List<Playlist>> playlistsStream({UserApp? user}) =>
      _service.collectionStream(
        path: APIPath.userPlaylists(user == null ? _uid : user.uid),
        builder: (data, documentID) => Playlist.fromMap(data, documentID),
        sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
      );

  @override
  Future<List<Playlist>> getUserPlaylists({UserApp? user}) async =>
      await _service.getCollection<Playlist>(
        path: APIPath.userPlaylists(user == null ? _uid : user.uid),
        builder: (data, documentID) => Playlist.fromMap(data, documentID),
        sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
      );

  @override
  Future<void> saveTrack(Track track) async =>
      await _service.setDocumentWithMergeOption(
          path: APIPath.track(track.id), data: track.toMap());

  @override
  Future<void> saveTracks(List<Track> tracks) async {
    for (var track in tracks) {
      await saveTrack(track);
    }
  }

  @override
  Future<void> setPlaylistTrack(Track track, Playlist playlist) async {
    await _service.setDocumentWithMergeOption(
      path: APIPath.playlistTrack(playlist.id, track.id),
      data: track.toMap(),
    );
  }

  @override
  Future<void> setPlaylistTracks(List<Track> tracks, Playlist playlist) async {
    for (var track in tracks) {
      await setPlaylistTrack(track, playlist);
    }
  }

  @override
  Future<void> setUserPlaylistTrack(Track track, Playlist playlist,
      {UserApp? user}) async {
    await _service.setDocumentWithMergeOption(
      path: APIPath.userPlaylistTrack(
          user == null ? _uid : user.uid, playlist.id, track.id),
      data: track.toMap(),
    );
  }

  @override
  Future<void> setUserPlaylistTracks(List<Track> tracks, Playlist playlist,
      {UserApp? user}) async {
    for (var track in tracks) {
      await setUserPlaylistTrack(track, playlist, user: user);
    }
  }
}
