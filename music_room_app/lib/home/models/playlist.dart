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
  List<Track> tracksList;
  Map<String, dynamic>? owner;
  String? description;
  bool? collaborative;
  bool? public;
  List<Map<String, dynamic>>? images;
  Map<String, dynamic>? tracksData;

  factory Playlist.fromMap(Map<String?, dynamic> data, String id) {
    final String name = data['name'] ?? 'N/A';
    final Map<String, dynamic> owner = data['owner'] ?? 'N/A';
    final String? description = data['description'];
    final bool? collaborative = data['collaborative'];
    final bool? public = data['public'];
    final List<dynamic> images = data['images'] ?? List.empty();
    final Map<String, dynamic>? tracksData = data['tracks'];
    List<Track> tracksList = List.empty();
    final List<dynamic> tracksListData = data['tracks_list'] ?? List.empty();
    if (tracksListData.isNotEmpty) {
      tracksList = tracksListData
          .map((track) =>
              track['id'] != null ? Track.fromMap(track, track['id']) : null)
          .whereType<Track>()
          .toList();
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
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'tracks_list': tracksList,
      'owner': owner,
      'description': description,
      'collaborative': collaborative,
      'public': public,
      'images': images,
      'tracks': tracksData,
    };
  }
}
