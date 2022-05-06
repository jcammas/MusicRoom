import 'package:flutter/material.dart';
import 'package:music_room_app/friends/services/search-friend-manager.dart';
import 'package:music_room_app/home/models/friend-link.dart';
import 'package:music_room_app/services/database.dart';
import 'package:provider/provider.dart';

class FriendSection extends StatefulWidget {
  FriendSection({required this.searchManager});
  final SearchFriendManager searchManager;

  @override
  State<FriendSection> createState() => _FriendSectionState();

  static Widget create(BuildContext context) {
    var db = Provider.of<Database>(context, listen: false);
    return ChangeNotifierProvider<SearchFriendManager>(
      create: (context) => SearchFriendManager(db: db),
      child: Consumer<SearchFriendManager>(
        builder: (_, searchManager, __) =>
            FriendSection(searchManager: searchManager),
      ),
    );
  }
}

class _FriendSectionState extends State<FriendSection> {
  @override
  Widget build(BuildContext context) {
    var db = Provider.of<Database>(context, listen: false);
    final Stream<List<FriendLink>> _friends = db.getFriends();

    return Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: StreamBuilder<List<FriendLink>>(
          stream: _friends,
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
                  // String displayFound = friends.length > 0
                  //     ? 'Found' + friends.length.toString() + 'friends'
                  //     : '';
                  String displayTotal =
                      'Total friends: ' + friends.length.toString();
                  children = <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Text(
                          //   displayFound,
                          //   style: Theme.of(context).textTheme.subtitle2,
                          // ),
                          Text(
                            displayTotal,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: widget.searchManager
                          .getFriendListOrSelectedFriend(friends),
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
