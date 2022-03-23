import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/api_path.dart';
import 'database_model.dart';

enum SystemType { public, friends, guests }

class Room implements DatabaseModel {
  Room({
    required this.name,
    required this.guests,
    required this.sourcePlaylist,
    required this.ownerId,
    required this.tracksList,
    this.voteSystem = SystemType.public,
    this.privacySystem = SystemType.public,
  });

  List<String> guests;
  Playlist sourcePlaylist;
  List<TrackApp> tracksList;
  String ownerId;
  String name;
  SystemType voteSystem;
  SystemType privacySystem;

  String get id => 'Room_of_' + ownerId;
  static String emptyRoomName = 'Room is empty';


  @override
  String get docId => DBPath.room(id);

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
      final List<dynamic> dataGuests = data['guests'] ?? [id];
      final List<String> guests = dataGuests.cast();
      final Map<dynamic, dynamic> playlistData = data['source_playlist'];
      final Playlist sourcePlaylist =
          Playlist.fromMap(playlistData.values.first, playlistData.keys.first);
      final String name = data['name'] ?? sourcePlaylist.name;
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
        sourcePlaylist: sourcePlaylist,
        tracksList: tracksList,
        ownerId: owner,
        voteSystem: voteSystem,
        privacySystem: privacySystem,
      );
    } else {
      return Room(
        name: emptyRoomName,
        guests: [id],
        sourcePlaylist: Playlist.fromMap(null, 'N/A'),
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
      'source_playlist': sourcePlaylist.toMap(),
      'owner_id': ownerId,
      'privacySystem': fromSystemType(privacySystem),
      'voteSystem': fromSystemType(voteSystem),
    };
  }
}
