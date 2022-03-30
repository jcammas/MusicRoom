import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/track.dart';

class TrackTile extends StatelessWidget {
  const TrackTile(
      {Key? key,
      required this.track,
      required this.onTap,
      this.icon = const Icon(Icons.chevron_right),
      this.tileColor})
      : super(key: key);
  final TrackApp track;
  final VoidCallback onTap;
  final Icon? icon;
  final Color? tileColor;
  static const double imageSize = 55.0;

  Widget _returnImage(TrackApp track) {
    if (track.album != null) {
      if (track.album!['images'] != null) {
        if (track.album!['images'].isNotEmpty) {
          if (track.album!['images'].first['url'] != null) {
            return Image.network(track.album!['images'].first['url'],
                width: imageSize, height: imageSize);
          }
        }
      }
    }
    return const Padding(padding: EdgeInsets.only(left: imageSize));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
      title: Text(track.name),
      trailing: icon,
      leading: _returnImage(track),
      tileColor: tileColor,
      onTap: onTap,
    );
  }
}
