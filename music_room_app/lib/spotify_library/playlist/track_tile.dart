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

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
      title: Text(track.name),
      trailing: icon,
      leading: track.returnImage(),
      tileColor: tileColor,
      onTap: onTap,
    );
  }
}
