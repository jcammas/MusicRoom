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
      required this.friends,
      this.playlists,
      this.spotifyProfile,
      required this.avatarUrl}) {
    this.userSearch = this.setSearchParams(name);
  }

  late List<String> userSearch;
  final String uid;
  String email;
  String name;
  String avatarUrl;
  SpotifyProfile? spotifyProfile;
  List<String> friends = [];
  List<Device> devices = [];
  Map<String, Playlist>? playlists;
  Room? currentRoom;
  String? defaultRoomPrivacySettings;
  String? defaultRoomVoteSystem;
  String? privacyLevel;

  List<String> setSearchParams(String str) {
    List<String> searchParams = [];
    String temp = "";

    str = str.toLowerCase();
    str = str.replaceAll(new RegExp(r'[^a-zA-Z]+'), '');
    for (int i = 0; i < str.length; i++) {
      temp = temp + str[i];
      searchParams.add(temp);
    }
    return searchParams;
  }

  @override
  get docId => DBPath.user(uid);

  factory UserApp.fromMap(Map<String, dynamic>? data, String uid) {
    if (data != null) {
      final String userName = data['name'] ?? 'N/A';
      final String email = data['email'] ?? 'N/A';
      final List<String> friends = new List<String>.from(data['friends'] ?? []);
      if (data['friends'] != null) {}
      SpotifyProfile? spotifyProfile;
      if (data['spotify_profile'] != null) {
        spotifyProfile = SpotifyProfile.fromMap(data['spotify_profile']);
      }
      String avatarUrl = data['image_url'] ?? defaultAvatarUrl;
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
          avatarUrl: avatarUrl,
          playlists: playlists,
          friends: friends,
          spotifyProfile: spotifyProfile);
    } else {
      return UserApp(
          uid: uid,
          name: "N/A",
          email: "N/A",
          avatarUrl: defaultAvatarUrl,
          friends: []);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'userSearch': userSearch,
      'email': email,
      'image_url': avatarUrl,
      'friends': friends,
    };
  }
}
