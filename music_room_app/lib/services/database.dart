import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/user.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Future<void> setUser(UserApp user);

  Future<void> deleteUser(UserApp user);

  Stream<List<UserApp>> usersStream();

  Stream<UserApp> userStream();

  Future<void> setPlaylist(Playlist playlist);

  Future<void> deletePlaylist(Playlist playlist);

  Stream<List<Playlist>> playlistsStream({UserApp user});

  Future<bool> currentUserExists();

  Future<void> updateUser(UserApp user);

  set uid(String uid);
}

class FirestoreDatabase implements Database {
  FirestoreDatabase();

  late String _uid;

  final _service = FirestoreService.instance;


  @override
  set uid(String uid) => _uid = uid;

  @override
  Future<void> setUser(UserApp user) => _service.setData(
        path: APIPath.user(_uid),
        data: user.toMap(),
      );

  @override
  Future<void> updateUser(UserApp user) =>
      _service.updateData(
        path: APIPath.user(_uid),
        data: user.toMap(),
      );

  @override
  Future<bool> currentUserExists() async {
    return _service.documentExists(path: APIPath.user(_uid));
  }

  @override
  Future<void> deleteUser(UserApp user) async {
    // delete where playlist.userId == user.userId
    final allPlaylists = await playlistsStream(user: user).first;
    for (Playlist playlist in allPlaylists) {
      if (playlist.owner == user.uid) {
        await deletePlaylist(playlist);
      }
    }
    // delete user
    await _service.deleteData(path: APIPath.user(_uid));
  }

  @override
  Stream<UserApp> userStream() => _service.documentStream(
        path: APIPath.user(_uid),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
      );

  @override
  Stream<List<UserApp>> usersStream() => _service.collectionStream(
        path: APIPath.users(_uid),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
      );

  @override
  Future<void> setPlaylist(Playlist playlist) => _service.setData(
        path: APIPath.playlist(_uid, playlist.id),
        data: playlist.toMap(),
      );

  @override
  Future<void> deletePlaylist(Playlist playlist) => _service.deleteData(
        path: APIPath.playlist(_uid, playlist.id),
      );

  @override
  Stream<List<Playlist>> playlistsStream({UserApp? user}) =>
      _service.collectionStream<Playlist>(
        path: APIPath.playlists(_uid),
        queryBuilder: user != null
            ? (query) => query.where('userId', isEqualTo: user.uid)
            : null,
        builder: (data, documentID) => Playlist.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.name.compareTo(lhs.name),
      );
}