import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/database_model.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/spotify_profile.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/services/spotify.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';

abstract class ListItemsManager {
  Future<void> refreshItems(BuildContext context);

  Future<void> deleteItem(BuildContext context, DatabaseModel item);

  void pageIsLoading(bool isLoading);

  bool get isLoading;
}

class LibraryManager with ChangeNotifier implements ListItemsManager {
  LibraryManager(
      {required this.spotify, required this.db, this.isLoading = false});

  final Spotify spotify;
  final Database db;
  @override
  bool isLoading;

  @override
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

  @override
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

  @override
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

  final Spotify spotify;
  final Database db;
  final Playlist playlist;
  @override
  bool isLoading;

  @override
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

  @override
  Future<void> refreshItems(BuildContext context) async {
    try {
      pageIsLoading(true);
      List<TrackApp> trackList = await spotify.getPlaylistTracks(playlist.id);
      await db.setListInObjectInUser(playlist, trackList);
      pageIsLoading(false);
      await db.setList(trackList, mergeOption: true);
      await db.setListInObject(playlist, trackList, mergeOption: true);
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

  Future<void> fillIfEmpty(BuildContext context) async {
      pageIsLoading(true);
      bool has = await db.userPlaylistHasTracks(playlist);
      has ? pageIsLoading(false) : refreshItems(context);
  }

  @override
  void pageIsLoading(bool isLoading) {
    this.isLoading = isLoading;
    notifyListeners();
  }
}