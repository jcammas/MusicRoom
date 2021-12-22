class Playlist {
  Playlist({required this.name, required this.id, required this.owner, this.tracks = const []});
  final String id;
  String name;
  String owner;
  List<String> tracks;

  factory Playlist.fromMap(Map<String?, dynamic> data, String id) {
    final String name = data['name'];
    final String owner = data['owner'];
    final List<String> tracks = data['tracks'];
    return Playlist(
      name: name,
      id: id,
      owner : owner,
      tracks : tracks,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'owner' : owner,
      'tracks' : tracks,
    };
  }
}