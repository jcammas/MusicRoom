import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/api_path.dart';
import 'database_model.dart';

class Room implements DatabaseModel {
  Room(
      {required this.id,
      required this.guests,
      required this.playlist,
      required this.owner,
      required this.voteSystem,
      required this.privacySystem});

  String id;
  List<UserApp> guests = [];
  Playlist playlist;
  UserApp owner;
  String voteSystem;
  String privacySystem;

  @override
  get docId => DBPath.room(id);

  factory Room.fromMap(Map<String, dynamic> data) {
    final String id = data['id'];
    final List<UserApp> guests = data['guests'];
    final Playlist playlist = data['playlist'];
    final UserApp owner = data['owner'];
    final String voteSystem = data['voteSystem'];
    final String privacySystem = data['privacySystem'];
    return Room(
      id: id,
      guests: guests,
      playlist: playlist,
      owner: owner,
      voteSystem: voteSystem,
      privacySystem: privacySystem,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'guests': guests,
      'playlist': playlist,
      'owner': owner,
      'privacySystem': privacySystem,
      'voteSystem': voteSystem,
    };
  }
}
