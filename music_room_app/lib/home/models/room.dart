import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/services/api_path.dart';
import 'database_model.dart';

enum SystemType { public, friends, guests }

class Room implements DatabaseModel {
  Room(
      {required this.guests,
      required this.playlist,
      required this.ownerId,
      this.voteSystem = SystemType.public,
      this.privacySystem = SystemType.public,
      this.name = ''});

  List<String> guests = [];
  Playlist? playlist;
  String ownerId;
  String name;
  SystemType voteSystem;
  SystemType privacySystem;

  String get id => 'Room_of_' + ownerId;
  @override
  get docId => DBPath.room(id);

  static SystemType toSystemType(String? str) {
    switch (str) {
      case 'friends':
        return SystemType.friends;
      case 'guests':
        return SystemType.guests;
      default:
        return SystemType.public;
    }
  }

  static String fromSystemType(SystemType type) {
    switch (type) {
      case SystemType.friends:
        return 'friends';
      case SystemType.guests:
        return 'guests';
      default:
        return 'public';
    }
  }

  static getOwnerFromId(String id) {
    List<String> split = id.split('_');
    return split[split.length - 1];
  }

  factory Room.fromMap(Map<String, dynamic>? data, String id) {
    if (data != null) {
      final List<String> guests = data['guests'] ?? [id];
      final Playlist? playlist = data['playlist'];
      final String name = data['owner_id'] ?? '';
      final String owner = data['owner_id'] ?? getOwnerFromId(id);
      final SystemType voteSystem = toSystemType(data['voteSystem']);
      final SystemType privacySystem = toSystemType(data['privacySystem']);
      return Room(
        name: name,
        guests: guests,
        playlist: playlist,
        ownerId: owner,
        voteSystem: voteSystem,
        privacySystem: privacySystem,
      );
    } else {
      return Room(
        guests: [id],
        playlist: null,
        ownerId: getOwnerFromId(id)
      );
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'guests': guests,
      'playlist': playlist?.toMap(),
      'owner_id': ownerId,
      'privacySystem': fromSystemType(privacySystem),
      'voteSystem': fromSystemType(voteSystem),
    };
  }
}
