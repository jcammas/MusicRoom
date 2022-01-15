import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/track/track_slider_row_manager.dart';
import 'package:provider/provider.dart';

class TrackSliderRow extends StatefulWidget {
  const TrackSliderRow({Key? key, required this.manager}) : super(key: key);

  final TrackSliderRowManager manager;

  static Widget create(
      {required BuildContext context,
      required TrackApp trackApp,
      required List<TrackApp> tracksList,
      required TrackSliderRowManager manager}) {
    return ChangeNotifierProvider<TrackSliderRowManager>(
      create: (_) =>
          manager,
      child: Consumer<TrackSliderRowManager>(
        builder: (_, manager, __) => TrackSliderRow(manager: manager),
      ),
    );
  }

  @override
  _TrackSliderRowState createState() => _TrackSliderRowState();
}

class _TrackSliderRowState extends State<TrackSliderRow> {
  TrackSliderRowManager get manager => widget.manager;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          width: double.infinity,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade600,
              activeTickMarkColor: Colors.white,
              thumbColor: Colors.white,
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 4,
              ),
            ),
            child: Slider(
              value: (manager.position.inSeconds.toDouble() !=
                      manager.duration.inSeconds.toDouble())
                  ? manager.position.inSeconds.toDouble()
                  : manager.resetSlider() ?? 0.0,
              min: 0,
              max: manager.duration.inSeconds.toDouble(),
              onChanged: (value) => manager.seekTo(value.toInt() * 1000),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "${manager.position.inMinutes.toInt()}:${(manager.position.inSeconds % 60).toString().padLeft(2, "0")}",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontFamily: "ProximaNovaThin",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${manager.duration.inMinutes.toInt()}:${(manager.duration.inSeconds % 60).toString().padLeft(2, "0")}",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontFamily: "ProximaNovaThin",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
