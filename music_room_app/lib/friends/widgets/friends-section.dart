import 'package:flutter/material.dart';
import 'package:music_room_app/friends/services/friend-links-manager.dart';
import 'package:music_room_app/friends/widgets/friend-card.dart';
import 'package:provider/provider.dart';

class FriendSection extends StatefulWidget {
  FriendSection();

  @override
  State<FriendSection> createState() => _FriendSectionState();
}

class _FriendSectionState extends State<FriendSection> {
  @override
  Widget build(BuildContext context) {
    var friendLinksManager = context.watch<FriendLinksManagerService>();

    return Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'Found: ' + friendLinksManager.userIds.length.toString(),
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  )
                ],
              ),
              Column(
                children: friendLinksManager.userIds
                    .map((e) => FriendCard(e, false))
                    .toList(),
              )
            ]));
  }
}
