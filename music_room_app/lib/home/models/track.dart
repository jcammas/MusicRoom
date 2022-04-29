import 'package:flutter/material.dart';
import 'package:music_room_app/services/api_path.dart';
import 'database_model.dart';

class TrackApp implements DatabaseModel {
  TrackApp({
    required this.name,
    required this.id,
    required this.votes,
    required this.indexApp,
    this.album,
    this.artists,
    this.discNumber,
    this.durationMs,
    this.explicit,
    this.externalIds,
    this.type,
    this.isPlayable,
    this.isLocal,
    this.restrictions,
    this.popularity,
    this.trackNumber,
    this.indexSpotify,
  });

  final String id;
  String name;
  int votes;
  Map<String, dynamic>? album;
  List<dynamic>? artists;
  int? discNumber;
  int? durationMs;
  bool? explicit;
  Map<String, dynamic>? externalIds;
  String? type;
  bool? isPlayable;
  bool? isLocal;
  Map<String, dynamic>? restrictions;
  int? popularity;
  int? trackNumber;
  int? indexSpotify;
  int indexApp;
  static const double imageSize = 55.0;

  @override
  get docId => DBPath.track(id);

  @override
  get wrappedCollectionsIds => [];

  Widget returnImage() {
    if (this.album != null) {
      if (this.album!['images'] != null) {
        if (this.album!['images'].isNotEmpty) {
          if (this.album!['images'].first['url'] != null) {
            return Image.network(this.album!['images'].first['url'],
                width: imageSize, height: imageSize);
          }
        }
      }
    }
    return const Padding(padding: EdgeInsets.only(left: imageSize));
  }

  factory TrackApp.fromMap(Map<String, dynamic>? data, String id) {
    if (data != null) {
      final String name = data['name'] ?? 'N/A';
      final int votes = data['votes'] ?? 0;
      final Map<String, dynamic>? album = data['album'];
      final List<dynamic>? artists = data['artists'];
      final int? discNumber = data['disc_number'];
      final int? durationMs = data['duration_ms'];
      final bool? explicit = data['explicit'];
      final Map<String, dynamic>? externalIds = data['external_ids'];
      final String? type = data['type'];
      final bool? isPlayable = data['is_playable'];
      final bool? isLocal = data['is_local'];
      final Map<String, dynamic>? restrictions = data['restrictions'];
      final int? popularity = data['popularity'];
      final int? trackNumber = data['track_number'];
      final int? indexSpotify = data['index_spotify'];
      final int indexApp = data['index_app'] ?? 0;
      return TrackApp(
        id: id,
        name: name,
        votes: votes,
        album: album,
        artists: artists,
        discNumber: discNumber,
        durationMs: durationMs,
        explicit: explicit,
        externalIds: externalIds,
        type: type,
        isPlayable: isPlayable,
        isLocal: isLocal,
        restrictions: restrictions,
        popularity: popularity,
        trackNumber: trackNumber,
        indexSpotify: indexSpotify,
        indexApp: indexApp,
      );
    } else {
      return TrackApp(id: 'N/A', name: 'N/A', votes: 0, indexApp: 0);
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'votes': votes,
      'album': album,
      'artists': artists,
      'disc_number': discNumber,
      'duration_ms': durationMs,
      'explicit': explicit,
      'external_ids': externalIds,
      'type': type,
      'is_playable': isPlayable,
      'is_local': isLocal,
      'restrictions': restrictions,
      'popularity': popularity,
      'track_number': trackNumber,
      'index_spotify': indexSpotify,
      'index_app': indexApp
    };
  }
}
