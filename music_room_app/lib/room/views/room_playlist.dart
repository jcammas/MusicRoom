import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/widgets/empty_content.dart';
import 'package:music_room_app/spotify_library/widgets/list_items_builder.dart';
import 'package:music_room_app/spotify_library/playlist/track_tile.dart';
import 'package:provider/provider.dart';
import '../../home/models/room.dart';
import '../../services/database.dart';
import '../../services/spotify.dart';
import '../managers/room_scaffold_manager.dart';
import '../managers/room_manager.dart';

class RoomPlaylistPage extends StatefulWidget {
  const RoomPlaylistPage({required this.manager});

  final RoomPlaylistManager manager;

  static Widget create({required Database db, required Room room}) {
    return ChangeNotifierProvider<RoomPlaylistManager>(
      create: (_) => RoomPlaylistManager(db: db, room: room),
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
        title: manager.room.name, funcText: manager.isOwner()? 'End' : 'Quit', topRightFn: manager.quitRoom);
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, updateScaffold);
    return StreamBuilder<List<TrackApp>>(
      stream: manager.roomTracksStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<TrackApp>(
          snapshot: snapshot,
          manager: manager,
          emptyScreen: const EmptyContent(),
          itemBuilder: (context, track) => Dismissible(
            key: Key('playlist-${track.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => manager.deleteTrack(context, track),
            child: TrackTile(track: track, onTap: () => {}),
          ),
        );
      },
    );
  }
}
