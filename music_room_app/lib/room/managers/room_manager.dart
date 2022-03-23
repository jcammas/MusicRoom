import 'package:flutter/cupertino.dart';
import '../../home/models/room.dart';
import '../../services/database.dart';
import '../../spotify_library/widgets/list_items_manager.dart';

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

  void stopLoading() {
    isLoading = false;
    notifyListeners();
  }

}
