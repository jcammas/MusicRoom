import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../home/models/playlist.dart';
import '../../home/models/room.dart';
import '../../home/models/track.dart';
import '../../services/database.dart';
import '../../services/spotify.dart';
import '../../spotify_library/widgets/list_items_manager.dart';
import '../../widgets/show_exception_alert_dialog.dart';

class RoomManager with ChangeNotifier implements ListItemsManager {
  Database db;
  Room room;
  bool isLoading = false;

  RoomManager({required this.db, required this.room}) {}

  void loadingState(bool value) {
    isLoading = value;
    notifyListeners();
  }

  bool isOwner() => db.uid == room.ownerId;

  Future<void> quitRoom(BuildContext context) async {
    loadingState(true);
    await db.updateUserRoom(null);
    await deleteGuest(context, db.uid);
    isOwner() ? await db.delete(room) : null;
  }

  Future<void> deleteGuest(BuildContext context, String naughtyGuestId) async {
    try {
      room.guests.removeWhere((guest) => guest == naughtyGuestId);
      await db.updateRoomGuests(room);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }
}

class RoomPlaylistManager extends RoomManager {
  RoomPlaylistManager(
      {required Database db, required Room room, required this.spotify})
      : super(db: db, room: room);

  Spotify spotify;

  roomTracksStream() => db.roomTracksStream(room);

  Playlist get sourcePlaylist => room.sourcePlaylist;

  Future<void> deleteTrack(BuildContext context, TrackApp item) async {
    try {
      await db.deleteInObject(room, item);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }
}

class RoomGuestsManager extends RoomManager {
  RoomGuestsManager({required Database db, required Room room})
      : super(db: db, room: room);

  roomGuestsStream() => db.usersStream(ids: room.guests);
}
