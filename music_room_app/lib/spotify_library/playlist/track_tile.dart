import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';

class TrackTile extends StatelessWidget {
  const TrackTile({Key? key, required this.track, required this.onTap})
      : super(key: key);
  final TrackApp track;
  final VoidCallback onTap;
  static const double imageSize = 55.0;

  Widget _returnImage(TrackApp track) {
    if (track.album != null) {
      if (track.album!['images'] != null) {
        if (track.album!['images'].isNotEmpty) {
          if (track.album!['images'].first['url'] != null) {
            return Image.network(track.album!['images'].first['url'], width: imageSize,
                height: imageSize);
          }
        }
      }
    }
    return const Padding(padding: EdgeInsets.only(left: imageSize));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(track.name),
      trailing: const Icon(Icons.chevron_right),
      leading: _returnImage(track),
      onTap: onTap,
    );
  }
}
