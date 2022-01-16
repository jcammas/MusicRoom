import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/track/managers/track_title_row_manager.dart';
import 'package:music_room_app/spotify_library/widgets/marquee_overflow.dart';
import 'package:provider/provider.dart';

class TrackTitleRow extends StatefulWidget {
  const TrackTitleRow({Key? key, required this.manager}) : super(key: key);

  final TrackTitleRowManager manager;

  static Widget create(
      {required BuildContext context,
      required TrackApp trackApp,
      required List<TrackApp> tracksList,
      required TrackTitleRowManager manager}) {
    return ChangeNotifierProvider<TrackTitleRowManager>(
      create: (_) => manager,
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
    final double w = MediaQuery.of(context).size.width;
    String artist = manager.returnArtist();
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MarqueeOverflow(
                text: track.name,
                width: w * 0.65,
                height: 30.0,
                maxLength: 21,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: "ProximaNova",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  wordSpacing: 0.2,
                ),
              ),
              MarqueeOverflow(
                text: artist,
                width: w * 0.65,
                height: 20.0,
                maxLength: 29,
                textStyle: TextStyle(
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
            icon: Icon(
              LineIcons.plus,
              color: manager.isAdded ? Colors.green : Colors.grey.shade400,
              size: w * 0.075,
            ),
            onPressed: manager.toggleAdded,
          ),
        ],
      ),
    );
  }
}
