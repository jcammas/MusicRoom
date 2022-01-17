import 'package:flutter/cupertino.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/database.dart';

class SearchManager with ChangeNotifier {
  SearchManager({required this.db});

  Database db;
  bool isLoading = true;
  List<UserApp> users = [];

  Future<void> getUsers() async {
    users = await db.getAllUsers();
    isLoading = false;
    notifyListeners();
  }

  List<UserApp> getFilteredByName(String userName) =>
      users.where((user) => user.name == userName).toList();

}