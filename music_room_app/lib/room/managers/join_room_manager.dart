import 'package:flutter/material.dart';
import '../../home/models/room.dart';
import '../../services/database.dart';
import '../../spotify_library/widgets/list_items_manager.dart';

class JoinRoomManager with ChangeNotifier implements ListItemsManager {
  JoinRoomManager({required this.db, this.isLoading = false});

  final Database db;
  Room? selectedRoom;
  List<Room> visibleRooms = List.empty();
  String? name;
  @override
  bool isLoading;

  String? get playlistId =>
      selectedRoom == null ? null : selectedRoom!.id;

  void selectRoom(BuildContext context, Room room) {
    selectedRoom = room;
    notifyListeners();
    Navigator.pop(context);
  }

  void pageIsLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  void updateName(String name) async {
    this.name = name.isEmpty ? null : name;
    visibleRooms = await getRooms(name);
    notifyListeners();
  }

  bool isReady() => selectedRoom != null;

  Future<List<Room>> getRooms(String name) async => db.getRooms(nameQuery: name);

  Future<bool> joinRoom(BuildContext context) async {
    if (selectedRoom == null) return false;
    try {
      pageIsLoading(true);
      await db.updateUserRoom(selectedRoom!.id);
      pageIsLoading(false);
      return true;
    } catch (e) {
      pageIsLoading(false);
      rethrow;
    }
  }
}