import 'package:music_room_app/home/models/database_model.dart';
import 'package:music_room_app/services/api_path.dart';

class RelationLink implements DatabaseModel {
  RelationLink({
    required this.name,
    required this.users,
    required this.status,
  }) {
    if (this.users.length <= 0) throw Error();
    this._linkedFrom = this.users[0];
    this._linkedTo = this.users[1];
    this.uid = toKey(this._linkedFrom, this._linkedTo);
    if (this.status == "pending" ||
        this.status == "accepted" ||
        this.status == "invalid") {
      this.status = this.status;
    } else
      throw Error();
  }

  final String name; //type of relation, ie: "friendship"
  final List<String> users;
  late String status;
  late final String uid;
  late final String _linkedFrom;
  late final String _linkedTo;

  String get linkedFrom => _linkedFrom;

  String get linkedTo => _linkedTo;

  get docId => DBPath.relationLink(uid);

  get wrappedCollectionsIds => [];

  String toKey(a, b) => a + b;

  static fromMap(Map<String, dynamic>? data, String uid) {
    String name = "Invalid Link";
    List<String> users = [];
    String status = "invalid";

    if (data != null) {
      name = data['name'];
      users = data['users'];
      status = data['fristatusend'];
    }
    return RelationLink(name: name, users: users, status: status);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'users': users,
      'status': status,
      'uid': uid,
      'linkedFrom': linkedFrom,
      'linkedTo': linkedTo,
    };
  }
}
