import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:spotify_sdk/enums/repeat_mode_enum.dart';
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

  RoomManager({required this.db, required this.room}) {
    isMaster = db.uid == room.ownerId;
  }

  void loadingState(bool value) {
    isLoading = value;
    notifyListeners();
  }

  Future<void> quitRoom(BuildContext context) async {
    loadingState(true);
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
}

class RoomPlaylistManager extends RoomManager {
  RoomPlaylistManager(
      {required Database db, required Room room, required this.spotify})
      : super(db: db, room: room);

  final SpotifyWeb spotify;
  StreamSubscription<Room>? roomSubscription;
  TrackApp? currentTrack;
  Track? trackSdk;

  String? get trackSdkId =>
      trackSdk == null ? null : trackSdk!.uri.split(':')[2];

  List<TrackApp> get tracksList => room.tracksList;

  Playlist get sourcePlaylist => room.sourcePlaylist;

  roomTracksStream() => db.roomTracksStream(room);

  roomStream() => db.roomStream(room);

  Future<void> initManager() async {
    roomSubscription = roomStream().listen(whenRoomChange);
  }

  Future<void> whenRoomChange(Room newRoom) async {
    if (!isMaster) remoteControlSdk(newRoom);
    room = newRoom;
    notifyListeners();
  }

  Future<void> remoteControlSdk(Room newRoom) async {
    PlayerState? newPlayerState = newRoom.playerState;
    if (newPlayerState != null) {
      trackSdk = newPlayerState.track;
      if (trackSdk != null) {
        String? newId = trackSdkId;
        if (currentTrack?.id != newId) {
          currentTrack = SpotifySdkService.loadOrUpdateTrackFromSdk(
              currentTrack, newRoom.tracksList, newId);
          if (currentTrack != null) await SpotifySdkService.playTrack(currentTrack!);
        } else {
          await SpotifySdkService.seekTo(newPlayerState.playbackPosition);
        }
        SpotifySdkService.togglePlay(newPlayerState.isPaused);
      } else {
        SpotifySdkService.togglePlay(true);
      }
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
