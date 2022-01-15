import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/track/track_title_row_manager.dart';
import 'package:provider/provider.dart';

class TrackTitleRow extends StatefulWidget {
  const TrackTitleRow({Key? key, required this.manager}) : super(key: key);

  final TrackTitleRowManager manager;

  static Widget create(
      {required BuildContext context,
      required TrackApp trackApp,
      required List<TrackApp> tracksList}) {
    return ChangeNotifierProvider<TrackTitleRowManager>(
      create: (_) =>
          TrackTitleRowManager(trackApp: trackApp, tracksList: tracksList),
      child: Consumer<TrackTitleRowManager>(
        builder: (_, manager, __) => TrackTitleRow(manager: manager),
      ),
    );
  }

  @override
  _TrackTitleRowState createState() => _TrackTitleRowState();
}

class _TrackTitleRowState extends State<TrackTitleRow> {
  TrackTitleRowManager get manager => widget.manager;

  TrackApp get track => widget.manager.trackApp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                track.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "ProximaNova",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  wordSpacing: 0.2,
                ),
              ),
              Text(
                manager.returnArtist(),
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontFamily: "ProximaNovaThin",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          IconButton(
            icon: (manager.isAdded == true)
                ? const Icon(
                    LineIcons.plus,
                    color: Colors.green,
                    size: 27,
                  )
                : Icon(
                    LineIcons.plus,
                    color: Colors.grey.shade400,
                    size: 27,
                  ),
            onPressed: manager.toggleAdded,
          ),
        ],
      ),
    );
  }
}
