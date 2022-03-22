import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/playlist.dart';

class PlaylistTile extends StatelessWidget {
  const PlaylistTile(
      {Key? key,
      required this.playlist,
      required this.onTap,
      this.icon = const Icon(Icons.chevron_right)})
      : super(key: key);
  final Playlist playlist;
  final VoidCallback onTap;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(playlist.name),
      trailing: icon,
      leading: playlist.returnImage(),
      onTap: onTap,
    );
  }
}
