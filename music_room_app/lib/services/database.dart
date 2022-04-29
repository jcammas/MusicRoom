import 'package:music_room_app/home/models/database_model.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:spotify_sdk/models/player_state.dart';
import '../home/models/room.dart';
import '../messenger/models/message.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  deleteById(String docId, List<String>? collIds);

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

  Future<void> updateUserRoom(String? roomId);

  Future<void> updateRoomGuests(Room room);

  Future<void> updateRoomPlayerState(Room room, PlayerState playerState);

  Future<UserApp> getUser({UserApp? user});

  Future<Room> getRoomById(String roomId);

  Future<UserApp> getUserById(String uid, {String field = ""});

  Future<List<UserApp>> getUsers({String nameQuery = ""});

  Future<List<Room>> getRooms({String nameQuery = ""});

  Future<List<TrackApp>> getPlaylistTracks(Playlist playlist);

  Future<List<TrackApp>> getRoomTracks(Room room);

  Future<bool> userExists({UserApp? user});

  Future<bool> userPlaylistHasTracks(Playlist playlist, {UserApp? user});

  Stream<UserApp> userStream({UserApp? user});

  Stream<List<UserApp>> usersStream({List<String>? ids});

  Stream<UserApp> userStreamById(String uid);

  Stream<Room> roomStream(Room room);

  Stream<Room> roomStreamById(String roomId);

  Stream<Playlist> userPlaylistStream(Playlist playlist, {UserApp? user});

  Stream<List<Playlist>> userPlaylistsStream({UserApp? user});

  Stream<List<TrackApp>> userPlaylistTracksStream(Playlist playlist,
      {UserApp? user});

  Stream<List<Message>> chatMessagesStream(UserApp interlocutor,
      {UserApp? user});

  Stream<List<TrackApp>> roomTracksStream(Room room);

  set uid(String uid);

  String get uid;
}

class FirestoreDatabase implements Database {

  late String _uid;

  final _service = FirestoreService.instance;

  @override
  set uid(String uid) => _uid = uid;

  @override
  get uid => _uid;

  @override
  Future<void> deleteById(String docId, List<String>? collIds) async {
    if (collIds != null) {
      for (String id in collIds) {
        await _service.deleteCollection(path: id);
      }
    }
    await _service.deleteDocument(path: docId);
  }

  @override
  Future<void> delete(DatabaseModel model) async =>
      await deleteById(model.docId, model.wrappedCollectionsIds);

  @override
  Future<void> deleteUser() async => await deleteById(DBPath.user(_uid),
      [_uid, DBPath.userPlaylists(_uid), DBPath.userSpotifyProfiles(_uid)]);

  @override
  Future<void> deleteInUser(DatabaseModel model) async => await deleteById(
      DBPath.user(_uid) + '/' + model.docId,
      model.wrappedCollectionsIds
          .map((id) => DBPath.user(_uid) + '/' + id)
          .toList());

  @override
  Future<void> deleteInObject(
          DatabaseModel parent, DatabaseModel child) async =>
      await deleteById(
          parent.docId + '/' + child.docId,
          child.wrappedCollectionsIds
              .map((id) => parent.docId + '/' + id)
              .toList());

  @override
  Future<void> deleteInObjectInUser(
          DatabaseModel parent, DatabaseModel child) async =>
      await deleteById(
          DBPath.user(_uid) + '/' + parent.docId + '/' + child.docId,
          child.wrappedCollectionsIds
              .map((id) => DBPath.user(_uid) + '/' + parent.docId + '/' + id)
              .toList());

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
  Future<void> updateUserRoom(String? roomId) async =>
      await _service.updateDocument(
        path: DBPath.user(_uid),
        data: {'room_id': roomId},
      );

  @override
  Future<void> updateRoomGuests(Room room) async =>
      await _service.updateDocument(
        path: room.docId,
        data: {'guests': room.guests},
      );

  @override
  Future<void> updateRoomPlayerState(Room room, PlayerState playerState) async {
    Map<String, dynamic> data = playerState.toJson();
    if (playerState.track != null) {
      Map<String, dynamic> track = playerState.track!.toJson();
      List<Map<String, dynamic>> artists =
          playerState.track!.artists.map((artist) => artist.toJson()).toList();
      Map<String, dynamic> album = playerState.track!.album.toJson();
      Map<String, dynamic> artist = playerState.track!.artist.toJson();
      Map<String, dynamic> imageUri = playerState.track!.imageUri.toJson();
      track['artists'] = artists;
      track['artist'] = artist;
      track['image_id'] = imageUri;
      track['album'] = album;
      data['track'] = track;
    } else {
      data['track'] = null;
    }
    data['playback_options'] = playerState.playbackOptions.toJson();
    data['playback_restrictions'] = playerState.playbackRestrictions.toJson();

    await _service.updateDocument(
      path: room.docId,
      data: {'player_state': data},
    );
  }

  @override
  Future<UserApp> getUser({UserApp? user}) async => await _service.getDocument(
        path: DBPath.user(user == null ? _uid : user.uid),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
      );

  @override
  Future<UserApp> getUserById(String uid, {String field = ""}) async =>
      await _service.getDocument(
        path: DBPath.user(uid),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
        field: field,
      );

  @override
  Future<Room> getRoomById(String roomId) async => await _service.getDocument(
        path: DBPath.room(roomId),
        builder: (data, documentId) => Room.fromMap(data, documentId),
      );

  @override
  Future<List<UserApp>> getUsers({String nameQuery = ""}) async =>
      await _service.getCollectionList(
        path: DBPath.users(),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
        queryBuilder: (query) => nameQuery != ""
            ? query.where("user_search", arrayContains: nameQuery)
            : query,
      );

  @override
  Future<List<Room>> getRooms({String nameQuery = ""}) async =>
      await _service.getCollectionList(
        path: DBPath.rooms(),
        builder: (data, documentId) => Room.fromMap(data, documentId),
        queryBuilder: (query) => nameQuery != ""
            ? query.where("room_search", arrayContains: nameQuery)
            : query,
      );

  @override
  Future<List<TrackApp>> getPlaylistTracks(Playlist playlist) async =>
      await _service.getCollectionList(
        path: DBPath.playlistTracks(playlist.id),
        builder: (data, documentId) => TrackApp.fromMap(data, documentId),
      );

  @override
  Future<List<TrackApp>> getRoomTracks(Room room) async =>
      await _service.getCollectionList(
        path: DBPath.roomTracks(room.id),
        builder: (data, documentId) => TrackApp.fromMap(data, documentId),
      );

  @override
  Future<bool> userExists({UserApp? user}) async => await _service
      .documentExists(path: DBPath.user(user == null ? _uid : user.uid));

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
  Stream<Room> roomStream(Room room) => _service.documentStream(
        path: room.docId,
        builder: (data, documentId) => Room.fromMap(data, documentId),
      );

  @override
  Stream<Room> roomStreamById(String roomId) => _service.documentStream(
        path: DBPath.room(roomId),
        builder: (data, documentId) => Room.fromMap(data, documentId),
      );

  @override
  Stream<UserApp> userStreamById(String uid) => _service.documentStream(
        path: DBPath.user(uid),
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
  Stream<List<UserApp>> usersStream({List<String>? ids}) =>
      _service.collectionStream(
        path: DBPath.users(),
        builder: (data, documentId) => UserApp.fromMap(data, documentId),
        queryBuilder: (query) =>
            ids == null ? query : query.where('uid', whereIn: ids),
      );

  @override
  Stream<List<TrackApp>> userPlaylistTracksStream(Playlist playlist,
          {UserApp? user}) =>
      _service.collectionStream(
        path: DBPath.userPlaylistTracks(
            user == null ? _uid : user.uid, playlist.id),
        builder: (data, documentID) => TrackApp.fromMap(data, documentID),
          sort: (lhs, rhs) => lhs.indexApp.compareTo(rhs.indexApp)
      );

  @override
  Stream<List<TrackApp>> roomTracksStream(Room room) =>
      _service.collectionStream(
        path: DBPath.roomTracks(room.id),
        builder: (data, documentID) => TrackApp.fromMap(data, documentID),
        sort: (lhs, rhs) => lhs.indexApp.compareTo(rhs.indexApp)
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
