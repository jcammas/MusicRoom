import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../home/models/room.dart';
import '../../home/models/track.dart';
import '../../services/database.dart';
import '../../spotify_library/widgets/list_items_manager.dart';
import '../../widgets/show_exception_alert_dialog.dart';

class RoomPlaylistManager with ChangeNotifier implements ListItemsManager {
  Database db;
  Room room;
  bool isLoading = false;

  RoomPlaylistManager(
      {required this.db, required this.room}) {}

  void loadingState(bool value) {
    isLoading = value;
    notifyListeners();
  }

  roomTracksStream() => db.roomTracksStream(room);

  Future<void> endRoom(BuildContext context) async {
    loadingState(true);
    await db.updateUserRoom(null);
    await db.delete(room);
  }

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
