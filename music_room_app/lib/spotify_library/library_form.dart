import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/services/spotify.dart';
import 'package:provider/provider.dart';
import 'library_model.dart';
import 'list_items_builder.dart';

class LibraryForm extends StatefulWidget {
  const LibraryForm({Key? key, required this.model}) : super(key: key);
  final LibraryModel model;

  static Widget create(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return ChangeNotifierProvider<LibraryModel>(
      create: (_) => LibraryModel(db: db),
      child: Consumer<LibraryModel>(
        builder: (_, model, __) => LibraryForm(model: model),
      ),
    );
  }

  @override
  State<LibraryForm> createState() => _LibraryFormState();
}

class _LibraryFormState extends State<LibraryForm> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    Spotify spotify = Spotify();
    return StreamBuilder<List<Playlist>>(
      stream: widget.model.getPlaylistsStream(),
      builder: (context, snapshot) {
        // List<Playlist>? playlists = snapshot.data;
        // return ListItemsBuilder<Playlist>(
        //   snapshot: snapshot,
        //   itemBuilder: (context, playlist) => Dismissible(
        //     key: Key('playlist-${playlist.id}'),
        //     background: Container(color: Colors.red),
        //     direction: DismissDirection.endToStart,
        //     child: PlaylistListTile(
        //       playlist: playlist,
        //       onTap: () => PlaylistEntriesPage.show(context, playlist),
        //     ),
        //   ),
        // );
        return SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                leading: Image.asset("images/avatar_random.png"),
                title: const Text("some_playlist_name"),
                onTap: spotify.getCurrentUserId,
              ),
              ListTile(
                leading: Image.asset("images/avatar_random.png"),
                title: const Text("some_playlist_name"),
                onTap: spotify.getCurrentUserId,
              ),
            ],
          ),
        );
      },
    );
  }
}
