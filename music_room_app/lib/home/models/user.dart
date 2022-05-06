import 'package:flutter/cupertino.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/spotify_profile.dart';
import 'package:music_room_app/services/api_path.dart';
import 'package:music_room_app/widgets/utils.dart';
import 'database_model.dart';

const String defaultAvatarUrl =
    "https://firebasestorage.googleapis.com/v0/b/musicroom-27d72.appspot.com/o/user_avatars%2Favatar_random.png?alt=media&token=cd472ae6-1d58-4e3a-9051-390f772392f6";

class UserApp implements DatabaseModel {
  UserApp(
      {required this.name,
      required this.email,
      required this.uid,
      this.playlists,
      this.spotifyProfile,
      this.roomId,
      required this.avatarUrl}) {
    this.userSearch = setSearchParams(name);
  }

  late List<String> userSearch;
  final String uid;
  String email;
  String name;
  String? roomId;
  String avatarUrl;
  SpotifyProfile? spotifyProfile;
  Map<String, Playlist>? playlists;
  String? defaultRoomPrivacySettings;
  String? defaultRoomVoteSystem;
  String? privacyLevel;

  ImageProvider getAvatar() => NetworkImage(avatarUrl);

  @override
  get docId => DBPath.user(uid);

  @override
  get wrappedCollectionsIds {
    List<String> res = [
      DBPath.userPlaylists(uid),
      DBPath.userSpotifyProfiles(uid)
    ];
    if (playlists != null) {
      playlists!.forEach((key, playlist) => res.addAll(playlist
          .wrappedCollectionsIds
          .map((id) => DBPath.user(uid) + '/' + id)
          .toList()));
    }
    return res;
  }

  factory UserApp.fromMap(Map<String, dynamic>? data, String uid) {
    if (data != null) {
      final String userName = data['name'] ?? 'N/A';
      final String email = data['email'] ?? 'N/A';
      SpotifyProfile? spotifyProfile;
      if (data['spotify_profile'] != null) {
        spotifyProfile = SpotifyProfile.fromMap(data['spotify_profile']);
      }
      String avatarUrl = data['image_url'] ?? defaultAvatarUrl;
      String? roomId = data['room_id'];
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
          spotifyProfile: spotifyProfile,
          roomId: roomId);
    } else {
      return UserApp(
          uid: uid, name: "N/A", email: "N/A", avatarUrl: defaultAvatarUrl);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'user_search': userSearch,
      'email': email,
      'image_url': avatarUrl,
      'room_id': roomId
    };
  }
}
