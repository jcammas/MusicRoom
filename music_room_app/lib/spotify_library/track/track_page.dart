import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/track/track_manager.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

class TrackPage extends StatefulWidget {
  const TrackPage(
      {Key? key,
      required this.track,
      required this.playlist,
      required this.manager})
      : super(key: key);
  final TrackApp track;
  final Playlist playlist;
  final TrackManager manager;

  static Future<void> show(BuildContext context, Playlist playlist, TrackApp track,
      List<TrackApp>? trackList) async {
    TrackManager manager =
        TrackManager(trackApp: track, playlist: playlist, tracksList: trackList);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => ChangeNotifierProvider<TrackManager>(
          create: (_) => manager,
          child: Consumer<TrackManager>(
            builder: (_, model, __) =>
                TrackPage(track: track, playlist: playlist, manager: manager),
          ),
        ),
      ),
    );
  }

  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  TrackManager get manager => widget.manager;

  Playlist get playlist => widget.manager.playlist;

  TrackApp get track => widget.manager.trackApp;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return manager.getConnectionStreamBuilder(
      Scaffold(
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
          child: _buildContents(context),
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
        const Icon(
          Icons.arrow_drop_down_outlined,
          color: Colors.white,
          size: 24,
        )
      ],
    );
  }

  Widget _buildTitleRow() {
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                track.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "ProximaNova",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  wordSpacing: 0.2,
                ),
              ),
              Text(
                manager.returnArtist(),
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontFamily: "ProximaNovaThin",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
          IconButton(
            icon: (manager.isAdded == true)
                ? const Icon(
                    LineIcons.plus,
                    color: Colors.green,
                    size: 27,
                  )
                : Icon(
                    LineIcons.plus,
                    color: Colors.grey.shade400,
                    size: 27,
                  ),
            onPressed: manager.toggleLike,
          ),
        ],
      ),
    );
  }

  Future<void> _connectSpotify() async {
    try {
      await manager.connectToSpotifyRemote();
    } on MissingPluginException catch (e) {
      showExceptionAlertDialog(context, title: 'Not implemented', exception: e);
    } on Exception catch (e) {
      showExceptionAlertDialog(context,
          title: 'Connection failed !', exception: e);
    }
  }

  Widget _buildConnectRow() {
    const double size = 5;
    return Container(
      margin: const EdgeInsets.only(top: 15, bottom: 20),
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Connect',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            padding: const EdgeInsets.only(top: 10, bottom: 10, left: 2),
            icon: CircleAvatar(
              radius: 6 * size,
              backgroundColor: Colors.black,
              child: CircleAvatar(
                radius: 5.9 * size,
                backgroundColor: Colors.black,
                child: Image.asset("images/spotify_icon.png"),
              ),
            ),
            iconSize: 12 * size,
            onPressed: _connectSpotify,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderRow() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: 5, right: 5),
          width: double.infinity,
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.white,
              inactiveTrackColor: Colors.grey.shade600,
              activeTickMarkColor: Colors.white,
              thumbColor: Colors.white,
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 4,
              ),
            ),
            child: Slider(
              value: (manager.position.inSeconds.toDouble() !=
                      manager.duration.inSeconds.toDouble())
                  ? manager.position.inSeconds.toDouble()
                  : manager.setChangedSlider(),
              min: 0,
              max: manager.duration.inSeconds.toDouble(),
              onChanged: (value) => manager.seekToSecond(value.toInt()),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "${manager.position.inMinutes.toInt()}:${(manager.position.inSeconds % 60).toString().padLeft(2, "0")}",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontFamily: "ProximaNovaThin",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${manager.duration.inMinutes.toInt()}:${(manager.duration.inSeconds % 60).toString().padLeft(2, "0")}",
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontFamily: "ProximaNovaThin",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildControlRow() {
    return Container(
      padding: const EdgeInsets.only(left: 22, right: 22),
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            LineIcons.random,
            color: Colors.grey.shade400,
          ),
          GestureDetector(
            onTap: manager.skipPrevious,
            child: const Icon(
              Icons.skip_previous,
              color: Colors.white,
              size: 40,
            ),
          ),
          SizedBox(
            height: 90,
            width: 90,
            child: Center(
              child: IconButton(
                iconSize: 70,
                alignment: Alignment.center,
                icon: manager.isPlayed
                    ? const Icon(
                        Icons.pause_circle_filled,
                        color: Colors.white,
                      )
                    : const Icon(
                        Icons.play_circle_filled,
                        color: Colors.white,
                      ),
                onPressed: manager.togglePlay,
              ),
            ),
          ),
          GestureDetector(
            onTap: manager.skipNext,
            child: const Icon(
              Icons.skip_next,
              color: Colors.white,
              size: 40,
            ),
          ),
          Icon(
            Icons.repeat,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRow() {
    return Container(
      padding: const EdgeInsets.only(left: 22, right: 22),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            LineIcons.desktop,
            color: Colors.grey.shade400,
          ),
          Icon(
            LineIcons.alternateList,
            color: Colors.grey.shade400,
          ),
        ],
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final double h = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildTopRow(),
          SizedBox(
            height: h * 0.04,
          ),
          SizedBox(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: manager.returnImage(),
              ),
              height: h * 0.48),
          SizedBox(
            height: h * 0.04,
          ),
          _buildTitleRow(),
          manager.isLoading
              ? const Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 50),
                  child: Center(child: CircularProgressIndicator()))
              : manager.isConnected
                  ? manager.getPlayerStateStreamBuilder(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _buildSliderRow(),
                          _buildControlRow(),
                        ],
                      ),
                    )
                  : _buildConnectRow(),
          _buildBottomRow(),
        ],
      ),
    );
  }
}
