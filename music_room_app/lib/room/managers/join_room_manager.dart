import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/database_model.dart';
import '../../home/models/room.dart';
import '../../services/database.dart';
import '../../spotify_library/widgets/list_items_manager.dart';
import '../../widgets/utils.dart';

class JoinRoomManager with ChangeNotifier implements ListItemsManager {
  JoinRoomManager({required this.db, this.isLoading = false});

  final Database db;
  Room? selectedRoom;
  String? name;
  @override
  bool isLoading;

  String? get playlistId => selectedRoom == null ? null : selectedRoom!.id;

  void selectRoom(DatabaseModel room) {
    selectedRoom = room as Room?;
    notifyListeners();
  }

  void pageIsLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  bool isReady() => selectedRoom != null;

  Future<List<Room>> getRooms(dynamic name) async =>
      await db.getRooms(nameQuery: formatSearchParam(name));

  Future<bool> joinRoom(BuildContext context) async {
    if (selectedRoom == null) return false;
    try {
      pageIsLoading(true);
      await db.updateUserRoom(selectedRoom!.id);
      selectedRoom!.guests.add(db.uid);
      await db.updateRoomGuests(selectedRoom!);
      pageIsLoading(false);
      return true;
    } catch (e) {
      pageIsLoading(false);
      return false;
    }
  }
}
