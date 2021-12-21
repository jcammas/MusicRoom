import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/user.dart';

class Room {
  Room({  required this.guests,
  required this.playlist,
  required this.owner,
  required this.voteSystem,
  required this.privacySystem});
  List<User> guests = [];
  Playlist playlist;
  User owner;
  String voteSystem;
  String privacySystem;

  factory Room.fromMap(Map<String, dynamic> data) {
    final List<User> guests = data['guests'];
    final Playlist playlist = data['playlist'];
    final User owner = data['owner'];
    final String voteSystem = data['voteSystem'];
    final String privacySystem = data['privacySystem'];
    return Room(
        guests : guests,
        playlist : playlist,
        owner : owner,
        voteSystem : voteSystem,
        privacySystem : privacySystem,
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
