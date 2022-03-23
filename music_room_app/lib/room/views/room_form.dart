import 'package:flutter/material.dart';
import 'package:music_room_app/room/managers/room_manager.dart';
import 'package:music_room_app/room/views/room_chat.dart';
import 'package:music_room_app/room/views/room_guests.dart';
import 'package:music_room_app/room/views/room_playlist.dart';
import 'package:music_room_app/services/database.dart';
import '../widgets/cupertino_home_scaffold.dart';
import '../widgets/tab_item.dart';

class RoomForm extends StatefulWidget {
  const RoomForm({Key? key, required this.manager}) : super(key: key);
  final RoomManager manager;

  static Widget create(BuildContext context,
      {required Database db, required String roomId}) {
    return RoomForm(manager: RoomManager(db: db, roomId: roomId));
  }

  @override
  State<RoomForm> createState() => _RoomFormState();
}

class _RoomFormState extends State<RoomForm> {

  RoomManager get manager => widget.manager;

  TabItem _currentTab = TabItem.playlist;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.playlist: GlobalKey<NavigatorState>(),
    TabItem.guests: GlobalKey<NavigatorState>(),
    TabItem.chat: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.playlist: (_) => RoomPlaylistPage(manager: manager),
      TabItem.guests: (_) => RoomGuestsPage(),
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

  @override
  Widget build(BuildContext context) {
    return manager.isLoading ? Center(child: CircularProgressIndicator()) : WillPopScope(
      onWillPop: () async => !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
