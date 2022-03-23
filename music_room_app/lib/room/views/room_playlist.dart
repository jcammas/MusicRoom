import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/room/managers/room_manager.dart';
import 'package:music_room_app/spotify_library/widgets/empty_content.dart';
import 'package:music_room_app/spotify_library/widgets/list_items_builder.dart';
import 'package:music_room_app/spotify_library/playlist/track_tile.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class RoomPlaylistPage extends StatelessWidget {
  const RoomPlaylistPage(
      {Key? key,
        required this.manager})
      : super(key: key);
  final RoomManager manager;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Playlist>(
        stream: manager.roomPlaylistStream(),
        builder: (context, snapshot) {
          final playlist = snapshot.data;
          final pName = playlist?.name ?? '';
          return Scaffold(
              appBar: customAppBar(
                  appText: pName,
                  context: context,
                  funcText: 'End',
                  topRight: manager.endRoom),
              backgroundColor: Theme.of(context).backgroundColor,
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: SystemUiOverlayStyle.light,
                  child: _buildPage(context, playlist)));
        });
  }

  Widget _buildPage(BuildContext context, Playlist? playlist) {
    if (playlist != null) {
      return _buildContents(context, playlist);
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildContents(BuildContext context, Playlist playlist) {
    return StreamBuilder<List<TrackApp>>(
      stream: manager.roomPlaylistTracksStream(),
      builder: (context, snapshot) {
        return ChangeNotifierProvider<RoomManager>(
          create: (_) => manager,
          child: Consumer<RoomManager>(
            builder: (_, __, ___) => ListItemsBuilder<TrackApp>(
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
                  onTap: () =>
                  {},
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
