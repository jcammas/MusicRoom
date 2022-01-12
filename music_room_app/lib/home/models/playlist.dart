import 'package:music_room_app/home/models/track.dart';

class Playlist {
  Playlist(
      {required this.id,
      required this.name,
      required this.tracksList,
      this.owner,
      this.description,
      this.collaborative,
      this.public,
      this.images,
      this.tracksData});

  final String id;
  String name;
  Map<String, Track> tracksList;
  Map<String, dynamic>? owner;
  String? description;
  bool? collaborative;
  bool? public;
  List<Map<String, dynamic>>? images;
  Map<String, dynamic>? tracksData;

  factory Playlist.fromMap(Map<String, dynamic>? data, String id) {
    if (data != null) {
      final String name = data['name'] ?? 'N/A';
      final Map<String, dynamic> owner = data['owner'] ?? 'N/A';
      final String? description = data['description'];
      final bool? collaborative = data['collaborative'];
      final bool? public = data['public'];
      final List<dynamic> images = data['images'] ?? List.empty();
      final Map<String, dynamic>? tracksData = data['tracks'];
      Map<String, Track> tracksList = {};
      Map<String, dynamic>? tracksListData = data['tracks_list'];
      if (tracksListData != null) {
        tracksListData.updateAll((id, track) => Track.fromMap(track, id));
        tracksList = tracksListData.cast();
      }
      return Playlist(
        name: name,
        id: id,
        tracksList: tracksList,
        owner: owner,
        description: description,
        collaborative: collaborative,
        public: public,
        images: images.whereType<Map<String, dynamic>>().toList(),
        tracksData: tracksData,
      );
    } else {
      return Playlist(
          id: 'N/A',
          name: 'N/A',
          tracksList: {}
      );
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'owner': owner,
      'description': description,
      'collaborative': collaborative,
      'public': public,
      'images': images,
      'tracks': tracksData,
    };
  }
}
