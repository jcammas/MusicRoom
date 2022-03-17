import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'api_path.dart';

class StorageService {

  final _storage = FirebaseStorage.instance;
  late String _uid;

  set uid(String uid) => _uid = uid;

  Future<String> saveAvatar(
      {String? uid,
        required File pickedImage}) async {
    final ref = _storage
        .ref()
        .child(StoragePath.userAvatar(uid ?? _uid));

    await ref.putFile(pickedImage);
    return await ref.getDownloadURL();
  }

}
