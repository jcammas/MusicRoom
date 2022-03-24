import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../home/models/room.dart';
import '../../services/database.dart';
import '../../spotify_library/widgets/list_items_manager.dart';
import '../../widgets/show_exception_alert_dialog.dart';

class RoomGuestsManager with ChangeNotifier implements ListItemsManager {
  Database db;
  Room room;
  bool isLoading = false;

  RoomGuestsManager(
      {required this.db, required this.room}) {}

  void loadingState(bool value) {
    isLoading = value;
    notifyListeners();
  }

  roomGuestsStream() => db.usersStream(ids: room.guests);

  Future<void> endRoom(BuildContext context) async {
    loadingState(true);
    await db.updateUserRoom(null);
    await db.delete(room);
  }

  Future<void> deleteGuest(BuildContext context, String naughtyGuest) async {
    try {
      room.guests.removeWhere((guest) => guest == naughtyGuest);
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
