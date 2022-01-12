class Track {
  Track({
    required this.name,
    required this.id,
    required this.votes,
    this.album,
    this.artists,
    this.discNumber,
    this.durationMs,
    this.explicit,
    this.externalIds,
    this.type,
    this.isPlayable,
    this.linkedFrom,
    this.isLocal,
    this.restrictions,
    this.popularity,
    this.trackNumber,
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
  Track? linkedFrom;
  bool? isLocal;
  Map<String, dynamic>? restrictions;
  int? popularity;
  int? trackNumber;

  factory Track.fromMap(Map<String?, dynamic> data, String id) {
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
    final Track? linkedFrom = data['linked_from'];
    final bool? isLocal = data['is_local'];
    final Map<String, dynamic>? restrictions = data['restrictions'];
    final int? popularity = data['popularity'];
    final int? trackNumber = data['track_number'];
    return Track(
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
      linkedFrom: linkedFrom,
      isLocal: isLocal,
      restrictions: restrictions,
      popularity: popularity,
      trackNumber: trackNumber,
    );
  }

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
      'linked_from': linkedFrom,
      'is_local': isLocal,
      'restrictions': restrictions,
      'popularity': popularity,
      'track_number': trackNumber,
    };
  }
}
