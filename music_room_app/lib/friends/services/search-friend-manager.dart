import 'package:flutter/material.dart';
import 'package:music_room_app/friends/widgets/friend-card.dart';
import 'package:music_room_app/home/models/friend-link.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/database.dart';

class SearchFriendManager extends ChangeNotifier {
  SearchFriendManager({required this.db}) {
    // _friends = ["MGiZvhhCzwh3fLeVEILgHunDHY53", "TUCxbglpIAZ2fcKJZYS78iIljeD2"];
  }

  final Database db;
  UserApp? _selectedUser;
  List<String> _friends = [];
  List<FriendLink> toto = [];

  void set selectedUser(selected) {
    _selectedUser = selected as UserApp?;
    notifyListeners();
  }

  UserApp? get selectedUser => _selectedUser;

  List<String> get friends => _friends;

  List<Widget> getFriendListOrSelectedFriend() {
    if (_selectedUser != null) {
      return [FriendCard(_selectedUser!.uid)];
    } else {
      return _friends.map((friend) {
        return FriendCard(friend);
      }).toList();
    }
  }
}
