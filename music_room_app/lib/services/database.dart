import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/spotify_profile.dart';
import 'package:music_room_app/home/models/user.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Future<void> setUser(UserApp user);

  Future<void> deleteUser(UserApp user);

  Stream<List<UserApp>> usersStream();

  Stream<UserApp> userStream({UserApp? user});

  Future<List<UserApp>> usersList();

  Future<UserApp> getUser();

  Stream<List<Playlist>> playlistsStream({UserApp? user});

  Future<bool> userExists({UserApp? user});

  Future<void> updateUser(UserApp user);

  Future<void> savePlaylist(Playlist playlist);

  Future<void> savePlaylists(List<Playlist> playlists);

  Future<void> setUserPlaylist(Playlist playlist, {UserApp? user});

  Future<void> setUserPlaylists(List<Playlist> playlists, {UserApp? user});

  Future<void> setSpotifyProfile(SpotifyProfile profile);

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
  Future<void> deleteUser(UserApp user) async {
    await _service.deleteDocument(path: APIPath.user(_uid));
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
  Future<List<UserApp>> usersList() async => await _service.getCollection(
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
  Future<void> savePlaylists(List<Playlist> playlists) async =>
      playlists.forEach(savePlaylist);

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
      setUserPlaylist(playlist, user: user);
    }
  }

  @override
  Stream<List<Playlist>> playlistsStream({UserApp? user}) =>
      _service.collectionStream<Playlist>(
        path: APIPath.userPlaylists(user == null ? _uid : user.uid),
        builder: (data, documentID) => Playlist.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.name.compareTo(lhs.name),
      );
}
