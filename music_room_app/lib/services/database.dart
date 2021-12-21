import 'package:music_room_app/home/models/user.dart';
import 'api_path.dart';
import 'firestore_service.dart';

abstract class Database {
  Future<void> createUser(User user);

  Stream<List<User>> usersStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});

  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> createUser(User user) => _service.setData(
        path: APIPath.user(uid),
        data: user.toMap(),
      );

  @override
  Stream<List<User>> usersStream() => _service.collectionStream(
        path: APIPath.users(),
        builder: (data) => User.fromMap(data),
      );
}
