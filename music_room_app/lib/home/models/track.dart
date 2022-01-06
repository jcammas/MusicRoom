class Track {
  Track({required this.name, required this.id, required this.votes});

  final String id;
  String name;
  int votes;

  factory Track.fromMap(Map<String?, dynamic> data) {
    final String name = data['name'];
    final String id = data['id'];
    final int votes = data['votes'];
    return Track(
      name: name,
      id: id,
      votes: votes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'votes': votes,
    };
  }
}
