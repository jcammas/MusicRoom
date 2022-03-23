import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/api_path.dart';
import 'database_model.dart';

enum SystemType { public, friends, guests }

class Room implements DatabaseModel {
  Room(
      {required this.guests,
      required this.originalPlaylist,
      required this.ownerId,
        required this.tracksList,
      this.voteSystem = SystemType.public,
      this.privacySystem = SystemType.public,
      this.name = ''});

  List<String> guests = [];
  Playlist? originalPlaylist;
  List<TrackApp> tracksList;
  Map<String, dynamic>? tracksData;
  String ownerId;
  String name;
  SystemType voteSystem;
  SystemType privacySystem;

  String get id => 'Room_of_' + ownerId;
  @override
  String get docId => DBPath.room(id);
  String get playlistId => originalPlaylist == null ? 'NA' : originalPlaylist!.id;

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
      List<TrackApp> tracksList = [];
      Map<String, dynamic>? tracksListData = data['tracks_list'];
      if (tracksListData != null) {
        tracksListData.updateAll((id, track) => TrackApp.fromMap(track, id));
        tracksList = tracksListData.values.toList().cast();
      }
      return Room(
        name: name,
        guests: guests,
        originalPlaylist: playlist,
        tracksList: tracksList,
        ownerId: owner,
        voteSystem: voteSystem,
        privacySystem: privacySystem,
      );
    } else {
      return Room(
        guests: [id],
        originalPlaylist: null,
        ownerId: getOwnerFromId(id),
        tracksList: [],
      );
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'guests': guests,
      'playlist': originalPlaylist?.toMap(),
      'owner_id': ownerId,
      'privacySystem': fromSystemType(privacySystem),
      'voteSystem': fromSystemType(voteSystem),
    };
  }
}
