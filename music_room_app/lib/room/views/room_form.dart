import 'package:flutter/material.dart';
import 'package:music_room_app/room/views/room_chat.dart';
import 'package:music_room_app/room/views/room_guests.dart';
import 'package:music_room_app/room/views/room_playlist.dart';
import 'package:music_room_app/services/database.dart';
import '../../home/models/room.dart';
import '../widgets/cupertino_home_scaffold.dart';
import '../widgets/tab_item.dart';

class RoomForm extends StatefulWidget {
  const RoomForm({Key? key, required this.db, required this.roomId})
      : super(key: key);
  final Database db;
  final String roomId;

  @override
  State<RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {
  TabItem _currentTab = TabItem.playlist;
  bool _isLoading = true;
  Room? room;

  Database get db => widget.db;

  String get roomId => widget.roomId;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.playlist: GlobalKey<NavigatorState>(),
    TabItem.guests: GlobalKey<NavigatorState>(),
    TabItem.chat: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.playlist: (context) =>
          RoomPlaylistPage.create(context: context, room: room!),
      TabItem.guests: (_) =>
          RoomGuestsPage.create(context: context, room: room!),
      TabItem.chat: (_) => RoomChatPage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      navigatorKeys[tabItem]!.currentState!.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  void getRoom() async {
    try {
      room = await db.getRoomById(roomId);
      if (room!.name == Room.emptyRoomName) db.updateUserRoom(null);
    } catch(e) {
      room = Room.emptyRoom('noId');
    }
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    getRoom();
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : WillPopScope(
                onWillPop: () async =>
                    !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
                child: CupertinoHomeScaffold(
                  currentTab: _currentTab,
                  onSelectTab: _select,
                  widgetBuilders: widgetBuilders,
                  navigatorKeys: navigatorKeys,
                ),
              );
  }
}
