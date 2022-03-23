import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/widgets/empty_content.dart';
import 'package:music_room_app/spotify_library/widgets/list_items_builder.dart';
import 'package:music_room_app/spotify_library/playlist/track_tile.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';
import '../../home/models/room.dart';
import '../../services/database.dart';
import '../managers/room_playlist_manager.dart';

class RoomPlaylistPage extends StatelessWidget {
  const RoomPlaylistPage({Key? key, required this.manager}) : super(key: key);
  final RoomPlaylistManager manager;

  static Widget create({required Database db, required Room room}) {
    return ChangeNotifierProvider<RoomPlaylistManager>(
      create: (_) => RoomPlaylistManager(db: db, room: room),
      child: Consumer<RoomPlaylistManager>(
        builder: (_, manager, __) => RoomPlaylistPage(manager: manager),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: customAppBar(
            appText: manager.room.name,
            context: context,
            funcText: 'End',
            topRight: manager.endRoom),
        backgroundColor: Theme.of(context).backgroundColor,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: _buildContents(context)));
  }

  Widget _buildContents(BuildContext context) {
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
                child: TrackTile(
                  track: track,
                  onTap: () => {},
                ),
              ),
        );
      },
    );
  }
}
