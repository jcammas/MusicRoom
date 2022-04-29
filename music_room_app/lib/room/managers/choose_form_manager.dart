import 'package:flutter/material.dart';
import 'package:music_room_app/room/managers/room_manager.dart';
import '../../home/models/playlist.dart';
import '../../home/models/room.dart';
import '../../home/models/track.dart';
import '../../services/database.dart';
import '../../services/spotify_web.dart';
import '../../spotify_library/widgets/list_items_manager.dart';
import '../views/choose_forms.dart';

class ChooseFormManager with ChangeNotifier implements ListItemsManager {
  ChooseFormManager({required this.db, this.isLoading = false});

  final Database db;
  Playlist? selectedPlaylist;
  @override
  bool isLoading;
  bool circleIcon = true;

  String? get playlistId =>
      selectedPlaylist == null ? null : selectedPlaylist!.id;

  Stream<List<Playlist>> userPlaylistsStream() => db.userPlaylistsStream();

  void selectPlaylist(BuildContext context, Playlist playlist) {
    selectedPlaylist = playlist;
    notifyListeners();
    Navigator.pop(context);
  }

  void pageIsLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }
}

class CreateRoomManager extends ChooseFormManager {
  CreateRoomManager(
      {required Database db, required this.spotify, bool isLoading = false})
      : super(db: db, isLoading: isLoading);

  final SpotifyWebService spotify;
  String? name;

  void updateName(String name) {
    this.name = name.isEmpty ? null : name;
    notifyListeners();
  }

  bool isReady() => selectedPlaylist != null && name != null;

  Future<bool> createRoom(BuildContext context) async {
    if (name == null || selectedPlaylist == null) return false;
    try {
      pageIsLoading(true);
      PlaylistManager manager = PlaylistManager(
          spotify: spotify,
          db: db,
          playlist: selectedPlaylist!,
          isLoading: true);
      await manager.fillIfEmpty(context, awaitRefresh: true);
      List<TrackApp> tracksList = await db.getPlaylistTracks(selectedPlaylist!);
      Room newRoom = Room(
          name: name!,
          ownerId: db.uid,
          guests: [db.uid],
          sourcePlaylist: selectedPlaylist!,
          tracksList: []);
      await db.set(newRoom);
      await db.setListInObject(newRoom, tracksList);
      await db.updateUserRoom(newRoom.id);
      pageIsLoading(false);
      return true;
    } catch (e) {
      pageIsLoading(false);
      rethrow;
    }
  }
}

class AddTrackManager extends ChooseFormManager {
  AddTrackManager({required Database db, required this.roomManager, bool isLoading = false})
      : super(db: db, isLoading: isLoading);

  TrackApp? selectedTrack;
  RoomPlaylistManager roomManager;
  String? get trackId => selectedTrack == null ? null : selectedTrack!.id;
  @override
  bool circleIcon = false;

  @override
  void selectPlaylist(BuildContext context, Playlist playlist) {
    selectedPlaylist = playlist;
    ChooseTrackForm.show(context, this);
  }

  bool isReady() => selectedTrack != null;

  Stream<List<TrackApp>> playlistTracksStream() =>
      db.userPlaylistTracksStream(selectedPlaylist!);

  void selectTrack(BuildContext context, TrackApp track) {
    selectedTrack = track;
    notifyListeners();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  Future<bool> addTrack(BuildContext context) async {
    TrackApp? track = selectedTrack;
    if (track == null) return false;
    try {
      pageIsLoading(true);
      await roomManager.addTrack(context, track);
      pageIsLoading(false);
      return true;
    } catch (e) {
      pageIsLoading(false);
      rethrow;
    }
  }
}
