import 'package:music_room_app/home/models/relation-link.dart';

class FriendLink extends RelationLink {
  FriendLink({required List<String> users, required String status})
      : super(name: "friendship", users: users, status: status);

  static fromMap(Map<String, dynamic>? data, String uid) {
    List<String> users = [];
    String status = "invalid";

    if (data != null) {
      users = data['users'];
      status = data['status'];
    }
    return FriendLink(users: users, status: status);
  }

  void switchStatus() {
    switch (this.status) {
      case "pending":
        this.status = "accepted";
        break;
      case "accepted":
        break;
      default:
        this.status = "invalid";
    }
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
