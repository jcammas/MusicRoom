import 'package:music_room_app/home/models/database_model.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/home/models/user.dart';
import '../messenger/models/message.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Future<void> delete(DatabaseModel model);

  Future<void> deleteUser();

  Future<void> deleteInUser(DatabaseModel model);

  Future<void> deleteInObject(DatabaseModel parent, DatabaseModel child);

  Future<void> deleteInObjectInUser(DatabaseModel parent, DatabaseModel child);

  Future<void> set(DatabaseModel model, {bool mergeOption = false});

  Future<void> setInUser(DatabaseModel model, {bool mergeOption = false});

  Future<void> setInObject(DatabaseModel parent, DatabaseModel child,
      {bool mergeOption = false});

  Future<void> setInObjectInUser(DatabaseModel parent, DatabaseModel child,
      {bool mergeOption = false});

  Future<void> setList(List<DatabaseModel> models, {bool mergeOption = false});

  Future<void> setListInUser(List<DatabaseModel> models,
      {bool mergeOption = false});

  Future<void> setListInObject(
      DatabaseModel parent, List<DatabaseModel> children,
      {bool mergeOption = false});

  Future<void> setListInObjectInUser(
      DatabaseModel parent, List<DatabaseModel> children,
      {bool mergeOption = false});

  Future<void> update(DatabaseModel model);

  Future<UserApp> getUser();

  Future<List> getFriends();

  Future<UserApp> getUserById(String uid, {String field = ""});

  Future<List<UserApp>> getUsers({String nameQuery = ""});

  Future<bool> userExists({UserApp? user});

  Future<bool> userHasPlaylists({UserApp? user});

  Future<bool> userPlaylistHasTracks(Playlist playlist, {UserApp? user});

  Stream<UserApp> userStream({UserApp? user});

  Stream<UserApp> userStreamById(String uid);

  Stream<List<UserApp>> usersStream();

  Stream<Playlist> userPlaylistStream(Playlist playlist, {UserApp? user});

  Stream<List<Playlist>> userPlaylistsStream({UserApp? user});

  Stream<List<TrackApp>> userPlaylistTracksStream(Playlist playlist,
      {UserApp? user});

  Stream<List<Message>> chatMessagesStream(UserApp interlocutor,
      {UserApp? user});

  set uid(String uid);

  String get uid;
}

class FirestoreDatabase implements Database {
  FirestoreDatabase();

  late String _uid;

  final _service = FirestoreService.instance;

  @override
  set uid(String uid) => _uid = uid;

  @override
  get uid => _uid;

  @override
  Future<void> delete(DatabaseModel model) async =>
      await _service.deleteDocument(path: model.docId);

  @override
  Future<void> deleteUser() async =>
      await _service.deleteDocument(path: DBPath.user(_uid));

  @override
  Future<void> deleteInUser(DatabaseModel model) async => await _service
      .deleteDocument(path: DBPath.user(_uid) + '/' + model.docId);

  @override
  Future<void> deleteInObject(
          DatabaseModel parent, DatabaseModel child) async =>
      await _service.deleteDocument(path: parent.docId + '/' + child.docId);

  @override
  Future<void> deleteInObjectInUser(
          DatabaseModel parent, DatabaseModel child) async =>
      await _service.deleteDocument(
          path: DBPath.user(_uid) + '/' + parent.docId + '/' + child.docId);

  @override
  Future<void> set(DatabaseModel model, {bool mergeOption = false}) async =>
      await _service.setDocument(
          path: model.docId, data: model.toMap(), mergeOption: mergeOption);

  @override
  Future<void> setInUser(DatabaseModel model,
          {bool mergeOption = false}) async =>
      await _service.setDocument(
          path: DBPath.user(_uid) + '/' + model.docId,
          data: model.toMap(),
          mergeOption: mergeOption);

  @override
  Future<void> setInObject(DatabaseModel parent, DatabaseModel child,
          {bool mergeOption = false}) async =>
      await _service.setDocument(
          path: parent.docId + '/' + child.docId,
          data: child.toMap(),
          mergeOption: mergeOption);

  @override
  Future<void> setInObjectInUser(DatabaseModel parent, DatabaseModel child,
          {bool mergeOption = false}) async =>
      await _service.setDocument(
          path: DBPath.user(_uid) + '/' + parent.docId + '/' + child.docId,
          data: child.toMap(),
          mergeOption: mergeOption);

  @override
  Future<void> setList(List<DatabaseModel> models,
      {bool mergeOption = false}) async {
    for (var model in models) {
      await set(model, mergeOption: mergeOption);
    }
  }

  @override
  Future<void> setListInUser(List<DatabaseModel> models,
      {bool mergeOption = false}) async {
    for (var model in models) {
      await setInUser(model, mergeOption: mergeOption);
    }
  }

  @override
  Future<void> setListInObject(
      DatabaseModel parent, List<DatabaseModel> children,
      {bool mergeOption = false}) async {
    for (var child in children) {
      await setInObject(parent, child, mergeOption: mergeOption);
    }
  }

  @override
  Future<void> setListInObjectInUser(
      DatabaseModel parent, List<DatabaseModel> children,
      {bool mergeOption = false}) async {
    for (var child in children) {
      await setInObjectInUser(parent, child, mergeOption: mergeOption);
    }
  }

  @override
  Future<void> update(DatabaseModel model) async =>
      await _service.updateDocument(
        path: model.docId,
        data: model.toMap(),
      );

  @override
  Future<UserApp> getUser({UserApp? user}) async => await _service.getDocument(
        path: DBPath.user(user == null ? _uid : user.uid),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
      );

  @override
  Future<List> getFriends({UserApp? user}) async => await _service.getDocument(
        path: DBPath.user(user == null ? _uid : user.uid),
        builder: (data, documentId) =>
            UserApp.fromMap(data, documentId).friends,
      );

  @override
  Future<UserApp> getUserById(String uid, {String field = ""}) async =>
      await _service.getDocument(
        path: DBPath.user(uid),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
        field: field,
      );

  @override
  Future<List<UserApp>> getUsers({String nameQuery = ""}) async =>
      await _service.getCollection(
        path: DBPath.users(),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
        nameQuery: nameQuery,
      );

  @override
  Future<bool> userExists({UserApp? user}) async => await _service
      .documentExists(path: DBPath.user(user == null ? _uid : user.uid));

  @override
  Future<bool> userHasPlaylists({UserApp? user}) async =>
      await _service.collectionIsNotEmpty(
          path: DBPath.userPlaylists(user == null ? _uid : user.uid));

  @override
  Future<bool> userPlaylistHasTracks(Playlist playlist,
          {UserApp? user}) async =>
      await _service.collectionIsNotEmpty(
          path: DBPath.userPlaylistTracks(
              user == null ? _uid : user.uid, playlist.id));

  @override
  Stream<UserApp> userStream({UserApp? user}) => _service.documentStream(
        path: DBPath.user(user == null ? _uid : user.uid),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
      );

  @override
  Stream<UserApp> userStreamById(String uid) => _service.documentStream(
        path: DBPath.user(uid),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
      );

  @override
  Stream<List<UserApp>> usersStream() => _service.collectionStream(
        path: DBPath.users(),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
      );

  @override
  Stream<Playlist> userPlaylistStream(Playlist playlist, {UserApp? user}) =>
      _service.documentStream(
        path: DBPath.userPlaylist(user == null ? _uid : user.uid, playlist.id),
        builder: (data, documentId) => Playlist.fromMap(data, documentId),
      );

  @override
  Stream<List<Playlist>> userPlaylistsStream({UserApp? user}) =>
      _service.collectionStream(
        path: DBPath.userPlaylists(user == null ? _uid : user.uid),
        builder: (data, documentID) => Playlist.fromMap(data, documentID),
        sort: (lhs, rhs) => lhs.name.compareTo(rhs.name),
      );

  @override
  Stream<List<TrackApp>> userPlaylistTracksStream(Playlist playlist,
          {UserApp? user}) =>
      _service.collectionStream(
        path: DBPath.userPlaylistTracks(
            user == null ? _uid : user.uid, playlist.id),
        builder: (data, documentID) => TrackApp.fromMap(data, documentID),
        sort: (lhs, rhs) => lhs.indexApp != null
            ? rhs.indexApp != null
                ? lhs.indexApp!.compareTo(rhs.indexApp!)
                : 0
            : 0,
      );

  @override
  Stream<List<Message>> chatMessagesStream(UserApp interlocutor,
          {UserApp? user}) =>
      _service.collectionStream(
          path: DBPath.chatMessages(
              user == null ? _uid : user.uid, interlocutor.uid),
          builder: (data, documentID) => Message.fromMap(data, documentID),
          sort: (lhs, rhs) => rhs.createdAt.compareTo(lhs.createdAt),
  );
}
