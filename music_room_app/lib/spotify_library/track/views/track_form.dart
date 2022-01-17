import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:music_room_app/home/models/playlist.dart';
import 'package:music_room_app/home/models/track.dart';
import 'package:music_room_app/spotify_library/track/views/track_control_row.dart';
import 'package:music_room_app/spotify_library/track/views/track_image.dart';
import 'package:music_room_app/spotify_library/track/managers/track_main_manager.dart';
import 'package:music_room_app/spotify_library/track/views/track_slider_row.dart';
import 'package:music_room_app/spotify_library/track/views/track_title_row.dart';
import 'package:music_room_app/widgets/show_exception_alert_dialog.dart';
import 'package:provider/provider.dart';

class TrackForm extends StatefulWidget {
  const TrackForm({Key? key, required this.manager}) : super(key: key);

  final TrackMainManager manager;

  static Widget create(TrackMainManager manager) {
    return ChangeNotifierProvider<TrackMainManager>(
          create: (_) => manager,
          child: Consumer<TrackMainManager>(
            builder: (_, model, __) => TrackForm(manager: manager),
          ),
        );
  }

  @override
  _TrackFormState createState() => _TrackFormState();
}

class _TrackFormState extends State<TrackForm> {
  TrackMainManager get manager => widget.manager;

  Playlist get playlist => widget.manager.playlist;

  TrackApp get track => widget.manager.trackApp;

  List<TrackApp> get tracksList => widget.manager.tracksList;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TrackImage.create(
              context: context,
              trackApp: track,
              tracksList: tracksList,
              manager: manager.imageManager),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          TrackTitleRow.create(
              context: context,
              trackApp: track,
              tracksList: tracksList,
              manager: manager.titleRowManager),
          manager.isLoading
              ? const Padding(
              padding: EdgeInsets.only(top: 52, bottom: 54),
              child: Center(child: CircularProgressIndicator()))
              : manager.isConnected
              ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TrackSliderRow.create(
                  context: context,
                  trackApp: track,
                  tracksList: tracksList,
                  manager: manager.sliderRowManager),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              TrackControlRow.create(
                  context: context,
                  playlist: playlist,
                  trackApp: track,
                  tracksList: tracksList,
                  manager: manager.controlRowManager),
            ],
          )
              : _buildConnectRow(),
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
      margin: const EdgeInsets.only(top: 13, bottom: 20),
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
            padding: const EdgeInsets.only(top: 10, left: 2),
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
}
