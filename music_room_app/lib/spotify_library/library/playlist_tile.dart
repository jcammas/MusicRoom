import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/playlist.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile({Key? key, required this.playlist, required this.onTap})
      : super(key: key);
  final Playlist playlist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(playlist.name),
      trailing: const Icon(Icons.chevron_right),
      leading: playlist.returnImage(),
      onTap: onTap,
    );
  }
}
