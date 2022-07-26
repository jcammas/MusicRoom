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
    return Container(
        color: Theme.of(context).primaryColorLight,
        padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                  SizedBox(width: 10),
                  TextButton(
                      onPressed: () => {}, child: const Text('Friend Requests'))
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
