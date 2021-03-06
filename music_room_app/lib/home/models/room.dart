import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/api_path.dart';
import 'package:music_room_app/widgets/utils.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'database_model.dart';

enum SystemType { public, friends, guests }

class Room implements DatabaseModel {
  Room({
    required this.name,
    required this.guests,
    required this.sourcePlaylist,
    required this.ownerId,
    required this.tracksList,
    this.playerState,
    this.voteSystem = SystemType.public,
    this.privacySystem = SystemType.public,
  }) {
    this.roomSearch = setSearchParams(name);
  }

  late List<String> roomSearch;
  List<String> guests;
  Playlist sourcePlaylist;
  List<TrackApp> tracksList;
  String ownerId;
  String name;
  SystemType voteSystem;
  SystemType privacySystem;
  PlayerState? playerState;

  String get id => 'Room_of_' + ownerId;
  static String emptyRoomName = 'Room is empty';

  @override
  String get docId => DBPath.room(id);

  @override
  get wrappedCollectionsIds => [DBPath.roomTracks(id)];

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
      final String uid = getOwnerFromId(id);
      final List<dynamic> dataGuests = data['guests'] ?? [uid];
      final List<String> guests = dataGuests.cast();
      final Map<dynamic, dynamic> playlistData = data['source_playlist'];
      final Playlist sourcePlaylist =
          Playlist.fromMap(playlistData.cast(), playlistData['id']);
      final String name = data['name'] ?? sourcePlaylist.name;
      final String owner = data['owner_id'] ?? uid;
      final SystemType voteSystem = toSystemType(data['vote_system']);
      final SystemType privacySystem = toSystemType(data['privacy_system']);
      List<TrackApp> tracksList = [];
      Map<String, dynamic>? tracksListData = data['tracks_list'];
      if (tracksListData != null) {
        tracksListData.updateAll((id, track) => TrackApp.fromMap(track, id));
        tracksList = tracksListData.values.toList().cast();
      }
      final PlayerState? playerState = data['player_state'] == null
          ? null
          : _playerStateFromJson(data['player_state']);
      return Room(
          name: name,
          guests: guests,
          sourcePlaylist: sourcePlaylist,
          tracksList: tracksList,
          ownerId: owner,
          voteSystem: voteSystem,
          privacySystem: privacySystem,
          playerState: playerState);
    } else {
      return emptyRoom(getOwnerFromId(id));
    }
  }

  static PlayerState? _playerStateFromJson(data) {
    try {
      return PlayerState.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  static Room emptyRoom(String uid) {
    return Room(
      name: emptyRoomName,
      guests: [uid],
      sourcePlaylist: Playlist.fromMap(null, 'N/A'),
      ownerId: uid,
      tracksList: [],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'guests': guests,
      'source_playlist': sourcePlaylist.toMap(),
      'owner_id': ownerId,
      'privacy_system': fromSystemType(privacySystem),
      'vote_system': fromSystemType(voteSystem),
      'room_search': roomSearch,
      'player_state': playerState?.toJson(),
    };
  }
}
