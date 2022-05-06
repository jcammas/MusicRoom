import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/friend-link.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/database.dart';

class FriendLinksManager extends ChangeNotifier {
  FriendLinksManager({required this.db}) {
    instantiateFriendLinksStream();
  }

  final Database db;
  UserApp? _selectedUser;
  List<FriendLink> _friendLinks = [];
  String _userMode = "friends";

  void switchUserMode() {
    switch (_userMode) {
      case "friends":
        _userMode = "users";
        break;
      case "users":
        _userMode = "friends";
        break;
    }
    notifyListeners();
  }

  String get userMode => _userMode;

  void set selectedUser(selected) {
    _selectedUser = selected as UserApp?;
    notifyListeners();
  }

  void instantiateFriendLinksStream() {
    db.getFriendLinks().listen(((friendsLinks) {
      _friendLinks = friendsLinks;
      notifyListeners();
    }));
  }

  List<String> get friendIds =>
      _friendLinks.map((FriendLink friendLink) => friendLink.linkedTo).toList();

  List<String> get friendIdsIfNoSelected => _selectedUser != null
      ? [_selectedUser!.uid]
      : _friendLinks
          .map((FriendLink friendLink) => friendLink.linkedTo)
          .toList();

  List<FriendLink> get friendLinks => _friendLinks;

  UserApp? get selectedUser => _selectedUser;
}
