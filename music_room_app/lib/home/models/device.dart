import 'package:music_room_app/home/models/database_model.dart';
import 'package:music_room_app/services/api_path.dart';

class Device implements DatabaseModel {
  Device(
      {required this.name,
      required this.id,
      required this.permission,
      required this.controllingUser});

  final String id;
  String name;
  String permission;
  String controllingUser;

  @override
  get docId => DBPath.device(id);

  factory Device.fromMap(Map<String?, dynamic> data) {
    final String name = data['name'];
    final String id = data['id'];
    final String permission = data['permission'];
    final String controllingUser = data['controllingUser'];
    return Device(
      name: name,
      id: id,
      permission: permission,
      controllingUser: controllingUser,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'permission': permission,
      'controllingUser': controllingUser,
    };
  }
}
