import 'package:flutter/material.dart';
import 'package:music_room_app/friends/services/friend-links-manager.dart';
import 'package:music_room_app/friends/widgets/friend-card.dart';
import 'package:music_room_app/home/models/friend-link.dart';

class FriendSection extends StatefulWidget {
  final FriendLinksManager friendLinksManager;
  FriendSection(this.friendLinksManager);

  @override
  State<FriendSection> createState() => _FriendSectionState();
}

class _FriendSectionState extends State<FriendSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: StreamBuilder<List<FriendLink>>(
          stream: widget.friendLinksManager.friendLinksStream,
          builder:
              (BuildContext context, AsyncSnapshot<List<FriendLink>> snapshot) {
            List<Widget> children;

            if (snapshot.hasError) {
              children = <Widget>[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text('Stack trace: ${snapshot.stackTrace}'),
                ),
              ];
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  children = const <Widget>[];
                  break;

                case ConnectionState.waiting:
                  children = const <Widget>[
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting friendlist...'),
                    )
                  ];
                  break;

                default:
                  List<FriendLink>? links = snapshot.data;
                  List<String> friends = links!.map((e) => e.linkedTo).toList();
                  String displayTotal =
                      'Total friends: ' + friends.length.toString();
                  children = <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            displayTotal,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: widget.friendLinksManager.friendIds
                          .map((e) => FriendCard(e))
                          .toList(),
                    )
                  ];
                  break;
              }
            }

            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children);
          },
        ));
  }
}
