import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/room.dart';
import 'package:music_room_app/home/models/spotify_profile.dart';
import 'device.dart';

class UserApp {
  UserApp({
    required this.name,
    required this.email,
    required this.uid,
    this.playlists,
    this.spotifyProfile,
  });

  final String uid;
  String email;
  String name;
  SpotifyProfile? spotifyProfile;
  List<UserApp> friends = [];
  List<Device> devices = [];
  Map<String, Playlist>? playlists;
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
      Map<String, dynamic>? playlistsData = data['playlists'];
      Map<String, Playlist> playlists = {};
      if (playlistsData != null) {
        playlistsData.updateAll((id, data) => Playlist.fromMap(data, id));
        playlists = playlistsData.cast();
      }
      return UserApp(
          uid: uid,
          name: userName,
          email: email,
          playlists: playlists,
          spotifyProfile: spotifyProfile);
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
