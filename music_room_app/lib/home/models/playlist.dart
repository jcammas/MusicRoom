import 'package:music_room_app/home/models/track.dart';

class Playlist {
  Playlist({required this.name, required this.id, required this.tracks});
  final String id;
  String name;
  List<Track> tracks = [];

  factory Playlist.fromMap(Map<String?, dynamic> data) {
    final String name = data['name'];
    final String id = data['id'];
    final List<Track> tracks = data['tracks'];
    return Playlist(
      name: name,
      id: id,
      tracks : tracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'tracks' : tracks,
    };
  }
}