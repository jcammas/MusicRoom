import 'package:flutter/material.dart';
import 'package:spotify_sdk/models/player_state.dart';
import '../../home/models/playlist.dart';
import '../../home/models/room.dart';
import '../../home/models/track.dart';
import '../../services/database.dart';
import '../../services/spotify.dart';
import '../../spotify_library/widgets/list_items_manager.dart';

class CreateRoomManager with ChangeNotifier implements ListItemsManager {
  CreateRoomManager(
      {required this.db, required this.spotify, this.isLoading = false});

  final Database db;
  final Spotify spotify;
  Playlist? selectedPlaylist;
  String? name;
  @override
  bool isLoading;

  String? get playlistId =>
      selectedPlaylist == null ? null : selectedPlaylist!.id;

  void selectPlaylist(BuildContext context, Playlist playlist) {
    selectedPlaylist = playlist;
    notifyListeners();
    Navigator.pop(context);
  }

  void updateName(String name) {
    this.name = name.isEmpty ? null : name;
    notifyListeners();
  }

  void pageIsLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  bool isReady() => selectedPlaylist != null && name != null;

  Stream<List<Playlist>> userPlaylistsStream() => db.userPlaylistsStream();

  Future<bool> createRoom(BuildContext context) async {
    if (name == null || selectedPlaylist == null) return false;
    try {
      pageIsLoading(true);
      PlaylistManager manager = PlaylistManager(
          spotify: spotify, db: db, playlist: selectedPlaylist!, isLoading: true);
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
