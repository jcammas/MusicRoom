import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/track/managers/track_control_row_manager.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/player_options.dart';

class TrackControlRow extends StatefulWidget {
  const TrackControlRow({Key? key, required this.manager}) : super(key: key);

  final TrackControlRowManager manager;

  static Widget create(
      {required BuildContext context,
      required TrackApp trackApp,
      required Playlist playlist,
      required List<TrackApp> tracksList,
      required TrackControlRowManager manager}) {
    return ChangeNotifierProvider<TrackControlRowManager>(
      create: (_) => manager,
      child: Consumer<TrackControlRowManager>(
        builder: (_, manager, __) => TrackControlRow(manager: manager),
      ),
    );
  }

  @override
  _TrackControlRowState createState() => _TrackControlRowState();
}

class _TrackControlRowState extends State<TrackControlRow> {
  TrackControlRowManager get manager => widget.manager;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 22, right: 22),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: manager.toggleShuffle,
            child: Icon(
              LineIcons.random,
              color: manager.isShuffling ? Colors.green : Colors.grey.shade400,
            ),
          ),
          GestureDetector(
            onTap: manager.skipPrevious,
            child: const Icon(
              Icons.skip_previous,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(
            height: 90,
            width: 90,
            child: Center(
              child: IconButton(
                iconSize: 70,
                alignment: Alignment.center,
                icon: Icon(
                  manager.isPaused
                      ? Icons.play_circle_filled
                      : Icons.pause_circle_filled,
                  color: Colors.white,
                ),
                onPressed: manager.togglePlay,
              ),
            ),
          ),
          GestureDetector(
            onTap: manager.skipNext,
            child: const Icon(
              Icons.skip_next,
              color: Colors.white,
              size: 40,
            ),
          ),
          GestureDetector(
            onTap: manager.toggleRepeat,
            child: Icon(
              manager.repeatMode == RepeatMode.off
                  ? Icons.repeat_outlined
                  : manager.repeatMode == RepeatMode.track
                      ? Icons.repeat_one_on_outlined
                      : Icons.repeat_on_outlined,
              color: manager.repeatMode == RepeatMode.off
                  ? Colors.grey.shade400
                  : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
