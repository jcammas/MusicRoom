import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/api_path.dart';
import 'database_model.dart';

class Playlist implements DatabaseModel {
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
  Map<String, TrackApp> tracksList;
  Map<String, dynamic>? owner;
  String? description;
  bool? collaborative;
  bool? public;
  List<Map<String, dynamic>>? images;
  Map<String, dynamic>? tracksData;
  static const double imageSize = 55.0;

  @override
  get docId => DBPath.playlist(id);
  @override
  get wrappedCollectionsIds => [DBPath.playlistTracks(id)];

  Widget returnImage() {
    if (this.images != null) {
      if (this.images!.isNotEmpty) {
        if (this.images!.first['url'] != null) {
          return Image.network(this.images!.first['url'],
              width: imageSize, height: imageSize);
        }
      }
    }
    return const Padding(padding: EdgeInsets.only(left: imageSize));
  }

  factory Playlist.fromMap(Map<String, dynamic>? data, String id) {
    if (data != null) {
      final String name = data['name'] ?? 'N/A';
      final Map<String, dynamic>? owner = data['owner'];
      final String? description = data['description'];
      final bool? collaborative = data['collaborative'];
      final bool? public = data['public'];
      final List<dynamic> images = data['images'] ?? List.empty();
      final Map<String, dynamic>? tracksData = data['tracks'];
      Map<String, TrackApp> tracksList = {};
      Map<String, dynamic>? tracksListData = data['tracks_list'];
      if (tracksListData != null) {
        tracksListData.updateAll((id, track) => TrackApp.fromMap(track, id));
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
      return Playlist(id: 'N/A', name: 'N/A', tracksList: {});
    }
  }

  @override
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
