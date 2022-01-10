import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/room.dart';
import 'package:music_room_app/home/models/spotify_profile.dart';
import 'device.dart';

class UserApp {
  UserApp({
    required this.name,
    required this.email,
    required this.uid,
    this.spotifyProfile,
  });

  final String uid;
  String email;
  String name;
  SpotifyProfile? spotifyProfile;
  List<UserApp> friends = [];
  List<Device> devices = [];
  List<Playlist> playlists = [];
  String? avatarId;
  Room? currentRoom;
  String? defaultRoomPrivacySettings;
  String? defaultRoomVoteSystem;
  String? privacyLevel;

  factory UserApp.fromMap(Map<String, dynamic>? data, String uid) {
    if (data != null) {
      final String userName = data['name'] ?? 'N/A';
      final String email = data['email'] ?? 'N/A';
      SpotifyProfile? spotifyProfile;
      if (data['spotify_profile'] != null) {
        spotifyProfile = SpotifyProfile.fromMap(data['spotify_profile']);
      }
      return UserApp(
        uid: uid,
        name: userName,
        email: email,
        spotifyProfile: spotifyProfile
      );
    } else {
      return UserApp(uid: uid, name: "N/A", email: "N/A");
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }
}
