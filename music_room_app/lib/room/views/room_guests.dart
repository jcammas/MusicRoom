import 'package:flutter/material.dart';
import 'package:music_room_app/room/widgets/guest_tile.dart';
import 'package:music_room_app/spotify_library/widgets/empty_content.dart';
import 'package:music_room_app/spotify_library/widgets/list_items_builder.dart';
import 'package:music_room_app/spotify_library/playlist/track_tile.dart';
import 'package:provider/provider.dart';
import '../../home/models/room.dart';
import '../../home/models/user.dart';
import '../../services/database.dart';
import '../managers/room_guests_manager.dart';

class RoomGuestsPage extends StatefulWidget {
  const RoomGuestsPage({required this.manager});

  final RoomGuestsManager manager;

  static Widget create({required Database db, required Room room}) {
    return ChangeNotifierProvider<RoomGuestsManager>(
      create: (_) => RoomGuestsManager(db: db, room: room),
      child: Consumer<RoomGuestsManager>(
          builder: (_, manager, __) => RoomGuestsPage(manager: manager)),
    );
  }

  @override
  _RoomGuestsPageState createState() => _RoomGuestsPageState();
}

class _RoomGuestsPageState extends State<RoomGuestsPage> {
  RoomGuestsManager get manager => widget.manager;

  // void updateScaffold() {
  //   RoomScaffoldManager scaffoldManager =
  //   Provider.of<RoomScaffoldManager>(context, listen: false);
  //   scaffoldManager.setScaffold(
  //       title: manager.room.name, funcText: 'End', topRightFn: manager.endRoom);
  // }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration.zero, updateScaffold);
    return StreamBuilder<List<UserApp>>(
      stream: manager.roomGuestsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<UserApp>(
          snapshot: snapshot,
          manager: manager,
          emptyScreen: const EmptyContent(),
          itemBuilder: (context, guest) => Dismissible(
            key: Key('guest-${guest.uid}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => manager.deleteGuest(context, guest),
            child: GuestTile(guest: guest, onTap: () => {}),
          ),
        );
      },
    );
  }
}
