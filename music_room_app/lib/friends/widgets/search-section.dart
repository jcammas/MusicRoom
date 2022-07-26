import 'package:flutter/material.dart';
import 'package:music_room_app/friends/services/friend-links-manager.dart';
import 'package:music_room_app/home/models/database_model.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/widgets/search-bar.dart';
import 'package:music_room_app/widgets/utils.dart';
import 'package:provider/provider.dart';

class SearchSection extends StatefulWidget {
  SearchSection();

  @override
  State<SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<SearchSection> {
  @override
  Widget build(BuildContext context) {
    var friendLinksManager = context.watch<FriendLinksManagerService>();
    var count = friendLinksManager.pendingLinks.length;
    return Container(
        color: Theme.of(context).primaryColorLight,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () {
                        friendLinksManager.switchUserMode();
                      },
                      // child: const Text('Find Users')),
                      child: friendLinksManager.userMode == true
                          ? const Text('Find Friends')
                          : const Text('Find Users')),
                  new Stack(
                    children: <Widget>[
                      new IconButton(
                          icon: Icon(Icons.notifications),
                          onPressed: () {
                            //OPEN NOTIFICATION PANEL WITH ALL PENDING INVITES
                          }),
                      count != 0
                          ? new Positioned(
                              right: 11,
                              top: 11,
                              child: new Container(
                                padding: EdgeInsets.all(2),
                                decoration: new BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: BoxConstraints(
                                  minWidth: 14,
                                  minHeight: 14,
                                ),
                                child: Text(
                                  '$count',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : new Container()
                    ],
                  ),
                ],
              ),
            ),
            SearchBar(
              getItemList: (pattern) async {
                final db = Provider.of<Database>(context, listen: false);
                final List<String> friendIds = friendLinksManager.userIds;
                print(friendIds);
                return await db.getUsers(
                    nameQuery: formatSearchParam(pattern),
                    ids: friendLinksManager.userMode == true ? [] : friendIds);
              },
              onSelected: (DatabaseModel selected) {
                friendLinksManager.selectedUser = selected as UserApp;
              },
            ),
          ],
        ));
  }
}
