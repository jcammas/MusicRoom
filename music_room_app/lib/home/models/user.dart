import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/room.dart';
import 'package:music_room_app/home/models/spotify_profile.dart';
import 'package:music_room_app/services/api_path.dart';
import 'package:music_room_app/services/constants.dart';
import 'database_model.dart';
import 'device.dart';

class UserApp implements DatabaseModel {
  UserApp(
      {required this.name,
      required this.email,
      required this.uid,
      this.playlists,
      this.spotifyProfile,
      required this.imageUrl});

  final String uid;
  String email;
  String name;
  String imageUrl;
  SpotifyProfile? spotifyProfile;
  List<UserApp> friends = [];
  List<Device> devices = [];
  Map<String, Playlist>? playlists;
  String? avatarId;
  Room? currentRoom;
  String? defaultRoomPrivacySettings;
  String? defaultRoomVoteSystem;
  String? privacyLevel;

  @override
  get docId => DBPath.user(uid);

  factory UserApp.fromMap(Map<String, dynamic>? data, String uid) {
    if (data != null) {
      final String userName = data['name'] ?? 'N/A';
      final String email = data['email'] ?? 'N/A';
      SpotifyProfile? spotifyProfile;
      if (data['spotify_profile'] != null) {
        spotifyProfile = SpotifyProfile.fromMap(data['spotify_profile']);
      }
      String imageUrl = data['image_url'] ?? defaultAvatarUrl;
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
          imageUrl: imageUrl,
          playlists: playlists,
          spotifyProfile: spotifyProfile);
    } else {
      return UserApp(uid: uid, name: "N/A", email: "N/A", imageUrl: defaultAvatarUrl);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {'uid': uid, 'name': name, 'email': email, 'image_url': imageUrl};
  }
}
