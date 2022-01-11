import 'package:music_room_app/home/models/spotify_profile.dart';

import '../utils.dart';

class UserField {
  static const String lastMessageTime = 'lastMessageTime';
}

class User {
  final String? uid;
  final String name;
  final DateTime? lastMessageTime;

  const User({
    this.uid,
    required this.name,
    this.lastMessageTime,
    SpotifyProfile? spotifyProfile,
  });

  User copyWith({
    String? uid,
    String? name,
    DateTime? lastMessageTime,
  }) =>
      User(
        uid: uid ?? this.uid,
        name: name ?? this.name,
        lastMessageTime: lastMessageTime,
      );

  // static User fromJson(Map<String, dynamic> json) => User(
  //       uid: json['uid'],
  //       name: json['name'],
  //       lastMessageTime: Utils.toDateTime(json['lastMessageTime']),
  //     );

  static User fromJson(Map<String, dynamic> json) {
    if (json != null) {
      final String userName = json['name'] ?? 'N/A';

      SpotifyProfile? spotifyProfile;
      if (json['spotify_profile'] != null) {
        spotifyProfile = SpotifyProfile.fromMap(json['spotify_profile']);
      }
      return User(
          uid: json['uid'],
          name: userName,
          spotifyProfile: spotifyProfile,
          lastMessageTime: Utils.toDateTime(json['lastMessageTime']));
    } else {
      return User(
          uid: json['uid'],
          name: "N/A",
          lastMessageTime: Utils.toDateTime(json['lastMessageTime']));
    }
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'lastMessageTime': Utils.fromDateTimeToJson(lastMessageTime!),
      };
}
