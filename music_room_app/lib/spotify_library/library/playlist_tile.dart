import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/playlist.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile({Key? key, required this.playlist, required this.onTap})
      : super(key: key);
  final Playlist playlist;
  final VoidCallback onTap;
  static const double imageSize = 55.0;

  Widget _returnImage(Playlist playlist) {
    if (playlist.images != null) {
      if(playlist.images!.isNotEmpty) {
        if(playlist.images!.first['url'] != null) {
          return Image.network(playlist.images!.first['url'], width: imageSize, height: imageSize);
        }
      }
    }
    return const Padding(padding: EdgeInsets.only(left: imageSize));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(playlist.name),
      trailing: const Icon(Icons.chevron_right),
      leading: _returnImage(playlist),
      onTap: onTap,
    );
  }
}
