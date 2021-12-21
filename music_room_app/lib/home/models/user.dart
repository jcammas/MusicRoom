import 'package:meta/meta.dart';
import 'package:music_room_app/home/models/room.dart';

import 'device.dart';

class User {
  User({required this.userName, required this.email});
  final String email;
  String userName;
  List<User> friends = [];
  List<Device> devices = [];
  String? avatarId;
  Room? currentRoom;
  String? defaultRoomPrivacySettings;
  String? defaultRoomVoteSystem;
  String? privacyLevel;

  factory User.fromMap(Map<String?, dynamic> data) {
    final String userName = data['name'];
    final String email = data['email'];
    return User(
        userName: userName,
        email: email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': userName,
      'email': email,
    };
  }
}
