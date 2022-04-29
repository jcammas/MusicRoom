import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/room/views/add_track_form.dart';
import 'package:music_room_app/room/views/room_default.dart';
import 'package:music_room_app/services/spotify_sdk_service.dart';
import 'package:music_room_app/spotify_library/widgets/empty_content.dart';
import 'package:music_room_app/spotify_library/widgets/list_items_builder.dart';
import 'package:music_room_app/spotify_library/playlist/track_tile.dart';
import 'package:provider/provider.dart';
import '../../constant_colors.dart';
import '../../home/models/room.dart';
import '../../services/database.dart';
import '../../spotify_library/track/views/track_page.dart';
import '../../widgets/connect_spotify_form.dart';
import '../managers/room_scaffold_manager.dart';
import '../managers/room_manager.dart';

class RoomPlaylistPage extends StatefulWidget {
  const RoomPlaylistPage({required this.manager});

  final RoomPlaylistManager manager;

  static Widget create({required BuildContext context, required Room room}) {
    final SpotifySdkService spotify = Provider.of<SpotifySdkService>(context, listen: false);
    final Database db = Provider.of<Database>(context, listen: false);
    return ChangeNotifierProvider<RoomPlaylistManager>(
      create: (_) => RoomPlaylistManager(db: db, room: room, spotify: spotify),
      child: Consumer<RoomPlaylistManager>(
          builder: (_, manager, __) => RoomPlaylistPage(manager: manager)),
    );
  }

  @override
  _RoomPlaylistPageState createState() => _RoomPlaylistPageState();
}

class _RoomPlaylistPageState extends State<RoomPlaylistPage> {
  RoomPlaylistManager get manager => widget.manager;

  void updateScaffold() {
    RoomScaffoldManager scaffoldManager =
        Provider.of<RoomScaffoldManager>(context, listen: false);
    scaffoldManager.setScaffold(
        title: manager.room.name,
        funcText: manager.isMaster ? 'End' : 'Quit',
        topRightFn: manager.quitRoom);
  }

  Widget roomTrackTile(TrackApp track, List<TrackApp> tracksList) {
    return TrackTile(
      track: track,
      onTap: manager.isMaster
          ? () => TrackPage.show(context, manager.sourcePlaylist, track,
              tracksList, manager.spotify, manager.db,
              room: manager.room)
          : () => {},
      icon: manager.trackApp.id == track.id
          ? const Icon(Icons.radio_button_checked, color: primaryColor)
          : manager.isMaster
              ? const Icon(Icons.chevron_right)
              : null,
      tileColor: manager.trackApp.id == track.id ? activeTileColor : null,
    );
  }

  Widget roomPlaylist() {
    return StreamBuilder<List<TrackApp>>(
      stream: manager.roomTracksStream(),
      builder: (context, snapshot) {
        manager.updateTracksList(snapshot.data);
        return ListItemsBuilder<TrackApp>(
          snapshot: snapshot,
          manager: manager,
          emptyScreen:
              const EmptyContent(message: 'No tracks in this playlist'),
          bottomAddTile: ListTile(
            title: Icon(Icons.add),
            onTap: () =>
                showBottomForm(context, AddTrackForm.create(context, manager)),
          ),
          itemBuilder: (context, track) => manager.isMaster
              ? Dismissible(
                  key: Key('track-${track.id}'),
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    snapshot.data?.remove(track);
                    manager.deleteTrack(context, track);
                  },
                  child: roomTrackTile(track, snapshot.data!))
              : roomTrackTile(track, snapshot.data!),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, updateScaffold);
    return manager.isConnected
        ? roomPlaylist()
        : ConnectSpotifyForm(refreshFunction: manager.connectSpotifySdk);
  }
}
