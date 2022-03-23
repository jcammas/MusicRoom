import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../home/models/room.dart';
import '../../home/models/track.dart';
import '../../services/database.dart';
import '../../spotify_library/widgets/list_items_manager.dart';
import '../../widgets/show_exception_alert_dialog.dart';

class RoomManager with ChangeNotifier implements ListItemsManager {
  Database db;
  String roomId;
  late Room room;
  bool isLoading = true;

  RoomManager({required this.db, required this.roomId}) {
    getRoom();
  }

  void getRoom() async {
    room = await db.getRoomById(roomId);
    stopLoading();
  }

  void triggerLoading() {
    isLoading = true;
    notifyListeners();
  }

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  roomPlaylistStream() => db.roomPlaylistStream(room);

  roomPlaylistTracksStream() => db.roomPlaylistTracksStream(room);

  Future<void> endRoom(BuildContext context) async {
    triggerLoading();
    await db.updateUserRoom(null);
    await db.delete(room);
    stopLoading();
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
