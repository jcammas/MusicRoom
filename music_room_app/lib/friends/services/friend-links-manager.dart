import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/friend-link.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/database.dart';

class FriendLinksManagerService extends ChangeNotifier {
  FriendLinksManagerService() {}

  late Database _db;
  List<FriendLink> _friendLinks = [];
  List<FriendLink> _pendingLinks = [];
  List<UserApp> _users = [];
  late Stream<List<FriendLink>> _friendLinksStream;
  late Stream<List<FriendLink>> _pendingLinksStream;
  late Stream<List<UserApp>> _usersStream;
  bool _userMode = false;
  UserApp? _selectedUser;

  void initService() {
    _friendLinksStream = _db.getFriendLinks();
    _pendingLinksStream = _db.getPendingLinks();
    _usersStream = _db.usersStream();
    _friendLinksStream.listen((friendLinks) {
      _friendLinks = friendLinks;
      notifyListeners();
    });
    _pendingLinksStream.listen((friendLinks) {
      _pendingLinks = friendLinks;
      notifyListeners();
    });
    _db.usersStream().listen((users) {
      _users = users;
      notifyListeners();
    });
  }

  bool get userMode => _userMode;

  List<String> get userIds {
    List<String> list = [];
    if (_selectedUser != null) {
      list = [_selectedUser!.uid];
    } else if (_userMode == true) {
      list = _users.map((UserApp user) => user.uid).toList();
    } else {
      list = _friendLinks
          .map((FriendLink friendLink) => friendLink.linkedTo)
          .toList();
    }
    return list;
  }

  List<String> get pendingLinks => _pendingLinks
      .map((FriendLink pendingLink) => pendingLink.linkedTo)
      .toList();

  List<FriendLink> get friendLinks => _friendLinks;

  Stream<List<FriendLink>> get friendLinksStream => _friendLinksStream;

  Stream<List<UserApp>> get usersStream => _usersStream;

  UserApp? get selectedUser => _selectedUser;

  void switchUserMode() {
    _userMode = !_userMode;
    notifyListeners();
  }

  void set selectedUser(UserApp? selected) {
    _selectedUser = selected;
    notifyListeners();
  }

  void set db(Database db) {
    _db = db;
  }
}
