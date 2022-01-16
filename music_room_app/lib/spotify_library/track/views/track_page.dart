import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/services/spotify.dart';
import 'package:music_room_app/spotify_library/track/views/track_form.dart';
import 'package:music_room_app/spotify_library/track/managers/track_main_manager.dart';

class TrackPage extends StatelessWidget {
  const TrackPage({Key? key, required this.manager}) : super(key: key);

  final TrackMainManager manager;
  Playlist get playlist => manager.playlist;
  BuildContext get context => manager.context;

  static Future<void> show(BuildContext context, Playlist playlist,
      TrackApp trackApp, List<TrackApp> tracksList, Spotify spotify) async {
    TrackMainManager manager = TrackMainManager(
        context: context,
        trackApp: trackApp,
        playlist: playlist,
        tracksList: tracksList,
        spotify: spotify);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => TrackPage(manager: manager),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    manager.playIfConnected();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 40,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.blueGrey,
              Colors.black87,
            ],
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildTopRow(),
              SizedBox(
                height: h * 0.03,
              ),
              TrackForm.create(manager),
              SizedBox(
                height: h * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24,
          ),
          onPressed: Navigator.of(context).pop,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        Column(
          children: <Widget>[
            const Text(
              "PLAYING FROM PLAYLIST",
              style: TextStyle(
                letterSpacing: 1,
                fontSize: 11,
                color: Colors.white,
              ),
            ),
            Text(
              playlist.name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                fontFamily: "ProximaNova",
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 24,
        ),
      ],
    );
  }
}
