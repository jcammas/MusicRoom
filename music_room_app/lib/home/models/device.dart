import 'package:meta/meta.dart';

class Device {
  Device(
      {required this.name,
      required this.id,
      required this.permission,
      required this.controllingUser});
  final String id;
  String name;
  String permission;
  String controllingUser;

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

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'permission': permission,
      'controllingUser': controllingUser,
    };
  }
}
