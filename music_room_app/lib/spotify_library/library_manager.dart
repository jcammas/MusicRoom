import 'package:flutter/cupertino.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/services/spotify.dart';

class LibraryManager with ChangeNotifier {
  LibraryManager(
      {required this.spotify,
        required this.db,
        this.isLoading = false});

  final Spotify spotify;
  final Database db;
  bool isLoading;


}