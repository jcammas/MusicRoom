import 'package:flutter/cupertino.dart';
import '../../services/database.dart';

class RoomManager with ChangeNotifier {
  Database db;
  String roomId;
  RoomManager({required this.db, required this.roomId});
}
