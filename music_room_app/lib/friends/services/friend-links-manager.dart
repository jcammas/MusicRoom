import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/friend-link.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/database.dart';
import 'package:provider/provider.dart';

abstract class FriendLinksManager {
  bool get userMode;
  List<String> get friendIds;
  List<FriendLink> get friendLinks;
  Stream<List<FriendLink>> get friendLinksStream;
  UserApp? get selectedUser;
  void switchUserMode();

  void set selectedUser(UserApp? selected);
  void set db(Database db);
}

class FriendLinksManagerService extends ChangeNotifier
    implements FriendLinksManager {
  FriendLinksManagerService() {}

  late Database _db;
  late List<FriendLink> _friendLinks;
  late Stream<List<FriendLink>> _friendLinksStream;
  bool _userMode = false;
  UserApp? _selectedUser;

  void initFriendLinks() {
    _db.getFriendLinks().listen((friendLinks) {
      _friendLinks = friendLinks;
      notifyListeners();
    });
  }

  @override
  bool get userMode => _userMode;

  @override
  List<String> get friendIds => _selectedUser != null
      ? [_selectedUser!.uid]
      : _friendLinks
          .map((FriendLink friendLink) => friendLink.linkedTo)
          .toList();

  @override
  List<FriendLink> get friendLinks => _friendLinks;

  @override
  Stream<List<FriendLink>> get friendLinksStream => _friendLinksStream;

  @override
  UserApp? get selectedUser => _selectedUser;

  @override
  void switchUserMode() {
    _userMode = !_userMode;
    notifyListeners();
  }

  @override
  void set selectedUser(UserApp? selected) {
    _selectedUser = selected;
    notifyListeners();
  }

  void set db(Database db) {
    _db = db;
  }
}
