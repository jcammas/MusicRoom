import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_room_app/home/models/database_model.dart';
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
  String opeFailed = 'Operation failed';

  RoomManager({required this.db, required this.room}) {
    isMaster = db.uid == room.ownerId;
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
        title: opeFailed,
        exception: e,
      );
    }
  }

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
      : super(db: db, room: room) {
    initPlaylistManager();
    refreshTracksList();
  }

  final SpotifyWeb spotify;
  List<TrackApp> tracksList = [];
  TrackApp currentTrack = TrackApp(name: 'default', id: 'NA', votes: 0);
  String? token;
  StreamSubscription<Room>? roomSubscription;
  StreamSubscription<ConnectionStatus>? connStatusSubscription;
  StreamSubscription<PlayerState>? playerStateSubscription;
  bool isPaused = true;
  Duration position = const Duration(milliseconds: 0);
  Timer? timer;

  String? getTrackSdkId(Track? trackSdk) =>
      trackSdk == null ? null : trackSdk.uri.split(':')[2];

  Future<void> refreshTracksList() async =>
      tracksList = await db.getRoomTracks(room);

  Playlist get sourcePlaylist => room.sourcePlaylist;

  roomTracksStream() => db.roomTracksStream(room);

  roomStream() => db.roomStream(room);

  Future<void> initPlaylistManager() async {
    connStatusSubscription = SpotifySdkService.subscribeConnectionStatus(
        onData: whenConnStatusChange,
        onError: (error) => updateConnected(false));
    isConnected = await SpotifySdkService.checkConnection();
    if (isConnected) {
      await SpotifySdkService.playTrackBySpotifyUri(
          room.playerState?.track?.uri);
      SpotifySdkService.seekTo(room.playerState?.track?.duration);
      SpotifySdkService.togglePlay(room.playerState?.isPaused);
    }
    roomSubscription = roomStream().listen(whenRoomChange);
  }

  void whenConnStatusChange(ConnectionStatus newStatus) {
    updateConnected(newStatus.connected);
    playerStateSubscription =
        SpotifySdkService.subscribePlayerState(onData: whenPlayerStateChange);
  }

  void whenPlayerStateChange(PlayerState newState) {
    String? newId = getTrackSdkId(newState.track);
    if (currentTrack.id != newId) {
      currentTrack =
          SpotifySdkService.findNewTrackApp(currentTrack, tracksList, newId);
    }
    position = Duration(milliseconds: newState.playbackPosition);
    if (isPaused != newState.isPaused) {
      timer != null ? timer!.cancel() : null;
      newState.isPaused == false ? initTimer() : null;
      isPaused = newState.isPaused;
    }
    notifyListeners();
  }

  Future<void> whenRoomChange(Room newRoom) async {
    PlayerState? newPlayerState = newRoom.playerState;
    if (newPlayerState != null && !isMaster) {
      remoteControlSdk(newPlayerState);
    } else if (newPlayerState != null && isMaster) {
      String? newId = getTrackSdkId(newPlayerState.track);
      if (currentTrack.id != newId) {
        currentTrack =
            SpotifySdkService.findNewTrackApp(currentTrack, tracksList, newId);
      }
    }
    room = newRoom;
    notifyListeners();
  }

  void remoteControlSdk(PlayerState newPlayerState) {
    String? newId = getTrackSdkId(newPlayerState.track);
    if (currentTrack.id != newId) {
      TrackApp newTrack =
          SpotifySdkService.findNewTrackApp(currentTrack, tracksList, newId);
      SpotifySdkService.playTrack(newTrack);
    }
    SpotifySdkService.seekTo(newPlayerState.playbackPosition);
    if (newPlayerState.isPaused != isPaused) {
      SpotifySdkService.togglePlay(newPlayerState.isPaused);
    }
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
        title: opeFailed,
        exception: e,
      );
    }
  }

  initTimer() {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(const Duration(seconds: 1), updatePositionOneSecond);
  }

  void updatePositionOneSecond(Timer timer) {
    position += const Duration(seconds: 1);
  }

  Future<void> deleteTrack(BuildContext context, DatabaseModel item) async {
    try {
      await db.deleteInObject(room, item);
      refreshTracksList();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: opeFailed,
        exception: e,
      );
    }
  }

  int maxIndexInTrackList() =>
      tracksList.map((track) => track.indexApp ?? 0).toList().reduce(max);

  Future<void> addTrack(BuildContext context, TrackApp track) async {
    try {
      track.indexSpotify = -1;
      track.indexApp = maxIndexInTrackList() + 1;
      await db.setInObject(room, track);
      refreshTracksList();
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: opeFailed,
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
