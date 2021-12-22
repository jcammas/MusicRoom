import 'package:music_room_app/home/models/room.dart';
import 'package:music_room_app/services/database.dart';

import 'device.dart';

class UserApp {
  UserApp({required this.name, required this.email, required this.id});
  final String id;
  String email;
  String name;
  List<UserApp> friends = [];
  List<Device> devices = [];
  String? avatarId;
  Room? currentRoom;
  String? defaultRoomPrivacySettings;
  String? defaultRoomVoteSystem;
  String? privacyLevel;

  factory UserApp.fromMap(Map<String, dynamic>? data, String id) {
    if (data != null) {
      final String userName = data['name'];
      final String email = data['email'];
      return UserApp(
        id: id,
        name: userName,
        email: email,
      );
    }
    else {
      return UserApp(
        id: id,
        name: "N/A",
        email: "N/A",
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'email': email,
    };
  }
}
