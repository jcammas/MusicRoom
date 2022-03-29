import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/models/player_state.dart';
import 'package:spotify_sdk/models/track.dart';
import '../../home/models/playlist.dart';
import '../../home/models/room.dart';
import '../../home/models/track.dart';
import '../../services/database.dart';
import '../../services/spotify_web.dart';
import '../../services/spotify_sdk_service.dart';
import '../../spotify_library/widgets/list_items_manager.dart';
import '../../widgets/show_exception_alert_dialog.dart';

class RoomManager with ChangeNotifier implements ListItemsManager {
  final Database db;
  late bool isMaster;
  Room room;
  bool isLoading = false;
  bool isConnected = false;
  StreamSubscription<ConnectionStatus>? connStatusSubscription;

  RoomManager({required this.db, required this.room}) {
    isMaster = db.uid == room.ownerId;
    initManager();
  }

  Future<void> quitRoom(BuildContext context) async {
    updateLoading(true);
    await db.updateUserRoom(null);
    await deleteGuest(context, db.uid);
    isMaster ? await db.delete(room) : null;
  }

  Future<void> deleteGuest(BuildContext context, String naughtyGuestId) async {
    try {
      room.guests.removeWhere((guest) => guest == naughtyGuestId);
      await db.updateRoomGuests(room);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> initManager() async {
    connStatusSubscription = SpotifySdkService.subscribeConnectionStatus(
        onData: whenConnStatusChange,
        onError: (error) => updateConnected(false));
    updateConnected(await SpotifySdkService.checkConnection());
  }

  void whenConnStatusChange(ConnectionStatus newStatus) =>
      updateConnected(newStatus.connected);

  void updateConnected(bool isConnected) =>
      updateWith(isConnected: isConnected);

  void updateLoading(bool isLoading) => updateWith(isLoading: isLoading);

  void updateWith({bool? isConnected, bool? isLoading}) {
    this.isConnected = isConnected ?? this.isConnected;
    this.isLoading = isLoading ?? this.isLoading;
    notifyListeners();
  }
}

class RoomPlaylistManager extends RoomManager {
  RoomPlaylistManager(
      {required Database db, required Room room, required this.spotify})
      : super(db: db, room: room){
    initPlaylistManager();
    refreshTracksList();
  }

  final SpotifyWeb spotify;
  StreamSubscription<Room>? roomSubscription;
  List<TrackApp>? tracksList;
  TrackApp? currentTrack;
  String? token;

  String? getTrackSdkId(Track? trackSdk) =>
      trackSdk == null ? null : trackSdk.uri.split(':')[2];

  Future<void> refreshTracksList() async => tracksList = await db.getRoomTracks(room);

  Playlist get sourcePlaylist => room.sourcePlaylist;

  roomTracksStream() => db.roomTracksStream(room);

  roomStream() => db.roomStream(room);

  Future<void> initPlaylistManager() async {
    roomSubscription = roomStream().listen(whenRoomChange);
  }

  Future<void> whenRoomChange(Room newRoom) async {
    PlayerState? newPlayerState = newRoom.playerState;
    if (newPlayerState != null) {
      await refreshTracksList();
      String? newId = getTrackSdkId(newPlayerState.track);
      bool isNew = currentTrack?.id != newId;
      if (!isMaster) remoteControlSdk(newPlayerState, isNew);
      if (isNew) {
        currentTrack = SpotifySdkService.loadOrUpdateTrackFromSdk(
            currentTrack, tracksList, newId);
      }
    }
    room = newRoom;
    notifyListeners();
  }

  Future<void> remoteControlSdk(
      PlayerState newPlayerState, bool playNew) async {
    if (playNew && currentTrack != null) {
      await SpotifySdkService.playTrack(currentTrack!);
    } else if (!playNew) {
      await SpotifySdkService.seekTo(newPlayerState.playbackPosition);
    }
    SpotifySdkService.togglePlay(newPlayerState.isPaused);
  }

  Future<void> connectSpotifySdk(BuildContext context) async {
    try {
      updateLoading(true);
      token = await spotify.getAccessToken();
      token = await SpotifySdkService.connectSpotifySdk(token);
      updateWith(isLoading: false, isConnected: true);
    } on Exception catch (e) {
      updateWith(isLoading: false, isConnected: false);
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  Future<void> deleteTrack(BuildContext context, TrackApp item) async {
    try {
      await db.deleteInObject(room, item);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }
}

class RoomGuestsManager extends RoomManager {
  RoomGuestsManager({required Database db, required Room room})
      : super(db: db, room: room);

  roomGuestsStream() => db.usersStream(ids: room.guests);
}
