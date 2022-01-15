import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/track/track_control_row.dart';
import 'package:music_room_app/spotify_library/track/track_image.dart';
import 'package:music_room_app/spotify_library/track/track_manager.dart';
import 'package:music_room_app/spotify_library/track/track_slider_row.dart';
import 'package:music_room_app/spotify_library/track/track_title_row.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';
import 'package:provider/provider.dart';
import 'package:spotify_sdk/models/connection_status.dart';

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

  static Future<void> show(BuildContext context, Playlist playlist,
      TrackApp track, List<TrackApp> trackList) async {
    TrackManager manager = TrackManager(
        trackApp: track, playlist: playlist, tracksList: trackList);
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

  List<TrackApp> get tracksList => widget.manager.tracksList;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return StreamBuilder<ConnectionStatus>(
      stream: manager.subscribeConnection(),
      builder: (context, snapshot) {
        manager.whenConnStatusChange(snapshot);
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
            child: _buildContents(context),
          ),
        );
      },
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

  Future<void> _connectSpotify() async {
    try {
      await manager.connectSpotifySdk();
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
          TrackImage.create(
              context: context, trackApp: track, tracksList: tracksList),
          SizedBox(
            height: h * 0.04,
          ),
          TrackTitleRow.create(
              context: context, trackApp: track, tracksList: tracksList),
          manager.isLoading
              ? const Padding(
                  padding: EdgeInsets.only(top: 50, bottom: 45),
                  child: Center(child: CircularProgressIndicator()))
              : manager.isConnected
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TrackSliderRow.create(
                            context: context,
                            trackApp: track,
                            tracksList: tracksList),
                        TrackControlRow.create(
                            context: context,
                            playlist: playlist,
                            trackApp: track,
                            tracksList: tracksList),
                      ],
                    )
                  : _buildConnectRow(),
          _buildBottomRow(),
        ],
      ),
    );
  }
}
