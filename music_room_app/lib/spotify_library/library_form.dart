import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/services/database.dart';
import 'package:provider/provider.dart';
import 'library_model.dart';

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
    return StreamBuilder<List<Playlist>>(
      stream: widget.model.getPlaylistsStream(),
      builder: (context, snapshot) {
        List<Playlist>? playlists = snapshot.data;
        return const SingleChildScrollView(
          child: Center(),
        );
      },
    );
  }
}
