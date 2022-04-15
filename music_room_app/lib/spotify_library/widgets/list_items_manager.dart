import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/database_model.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/spotify_profile.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/services/spotify_web.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';

import '../../home/models/user.dart';

abstract class ListItemsManager {
  bool get isLoading;
}

class LibraryManager with ChangeNotifier implements ListItemsManager {
  LibraryManager(
      {required this.spotify, required this.db, this.isLoading = false});

  final SpotifyWebService spotify;
  final Database db;
  @override
  bool isLoading;

  Future<void> deleteItem(BuildContext context, DatabaseModel item) async {
    try {
      await db.deleteInUser(item);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> refreshItems(BuildContext context) async {
    try {
      pageIsLoading(true);
      final SpotifyProfile profile = await spotify.getCurrentUserProfile();
      db.setInUser(profile);
      final List<Playlist> playlists = await spotify.getCurrentUserPlaylists();
      await db.setListInUser(playlists);
      pageIsLoading(false);
      await db.setList(playlists, mergeOption: true);
    } on PlatformException catch (e) {
      pageIsLoading(false);
      showExceptionAlertDialog(context,
          title: 'Refreshing playlists failed !',
          exception: PlatformException(
              code: e.code, message: 'Spotify import has been canceled.'));
    } on Exception catch (e) {
      pageIsLoading(false);
      showExceptionAlertDialog(context,
          title: 'Refreshing playlists failed !', exception: e);
    }
  }

  void pageIsLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }
}

class PlaylistManager with ChangeNotifier implements ListItemsManager {
  PlaylistManager(
      {required this.spotify,
      required this.db,
      required this.playlist,
      this.isLoading = false});

  final SpotifyWebService spotify;
  final Database db;
  final Playlist playlist;
  @override
  bool isLoading;

  Future<void> deleteItem(BuildContext context, DatabaseModel item) async {
    try {
      await db.deleteInObjectInUser(playlist, item);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> refreshItems(BuildContext context) async {
    try {
      pageIsLoading(true);
      List<TrackApp> tracksList = await spotify.getPlaylistTracks(playlist.id);
      await db.setListInObjectInUser(playlist, tracksList);
      pageIsLoading(false);
      await db.setList(tracksList, mergeOption: true);
      await db.setListInObject(playlist, tracksList, mergeOption: true);
    } on PlatformException catch (e) {
      pageIsLoading(false);
      showExceptionAlertDialog(context,
          title: 'Refreshing this playlist failed !',
          exception: PlatformException(
              code: e.code, message: 'Spotify import has been canceled.'));
    } on Exception catch (e) {
      pageIsLoading(false);
      showExceptionAlertDialog(context,
          title: 'Refreshing this playlist failed !', exception: e);
    }
  }

  Future<void> fillIfEmpty(BuildContext context,
      {bool awaitRefresh = false}) async {
    pageIsLoading(true);
    bool has = await db.userPlaylistHasTracks(playlist);
    has
        ? pageIsLoading(false)
        : awaitRefresh
            ? await refreshItems(context)
            : refreshItems(context);
  }

  void pageIsLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }

  Future<bool> checkIfRoomActive() async {
    UserApp me = await db.getUser();
    return me.roomId != null;
  }
}
