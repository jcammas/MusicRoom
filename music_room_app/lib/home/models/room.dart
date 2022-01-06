import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/user.dart';

class Room {
  Room(
      {required this.guests,
      required this.playlist,
      required this.owner,
      required this.voteSystem,
      required this.privacySystem});

  List<UserApp> guests = [];
  Playlist playlist;
  UserApp owner;
  String voteSystem;
  String privacySystem;

  factory Room.fromMap(Map<String, dynamic> data) {
    final List<UserApp> guests = data['guests'];
    final Playlist playlist = data['playlist'];
    final UserApp owner = data['owner'];
    final String voteSystem = data['voteSystem'];
    final String privacySystem = data['privacySystem'];
    return Room(
      guests: guests,
      playlist: playlist,
      owner: owner,
      voteSystem: voteSystem,
      privacySystem: privacySystem,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'guests': guests,
      'playlist': playlist,
      'owner': owner,
      'privacySystem': privacySystem,
      'voteSystem': voteSystem,
    };
  }
}
