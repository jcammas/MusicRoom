import 'package:flutter/material.dart';
import 'package:music_room_app/friends/widgets/friend-card.dart';
import 'package:music_room_app/home/models/friend-link.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/database.dart';

class SearchFriendManager extends ChangeNotifier {
  SearchFriendManager({required this.db}) {}

  final Database db;
  UserApp? _selectedUser;
  List<FriendLink> toto = [];

  void set selectedUser(selected) {
    _selectedUser = selected as UserApp?;
    notifyListeners();
  }

  UserApp? get selectedUser => _selectedUser;

  List<Widget> getFriendListOrSelectedFriend(List<String> friends) {
    if (_selectedUser != null) {
      return [FriendCard(_selectedUser!.uid)];
    } else {
      return friends.map((friend) {
        return FriendCard(friend);
      }).toList();
    }
  }
}
