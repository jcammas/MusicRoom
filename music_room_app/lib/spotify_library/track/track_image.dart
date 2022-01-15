import 'package:flutter/cupertino.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/track/track_image_manager.dart';
import 'package:provider/provider.dart';

class TrackImage extends StatefulWidget {
  const TrackImage({Key? key, required this.manager}) : super(key: key);

  final TrackImageManager manager;

  static Widget create(
      {required BuildContext context,
      required TrackApp trackApp,
      required List<TrackApp> tracksList,
      required TrackImageManager manager}) {
    return ChangeNotifierProvider<TrackImageManager>(
      create: (_) => manager,
      child: Consumer<TrackImageManager>(
        builder: (_, manager, __) => TrackImage(manager: manager),
      ),
    );
  }

  @override
  _TrackImageState createState() => _TrackImageState();
}

class _TrackImageState extends State<TrackImage> {
  TrackImageManager get manager => widget.manager;

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    return SizedBox(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: manager.returnImage(),
        ),
        height: h * 0.48);
  }
}
