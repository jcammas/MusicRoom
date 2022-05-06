import 'package:flutter/material.dart';
import 'package:music_room_app/friends/services/friend-links-manager.dart';
import 'package:music_room_app/home/models/database_model.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/widgets/search-bar.dart';
import 'package:music_room_app/widgets/utils.dart';
import 'package:provider/provider.dart';

class SearchSection extends StatefulWidget {
  SearchSection({required this.friendLinksManager});
  final FriendLinksManager friendLinksManager;

  @override
  State<SearchSection> createState() => _SearchSectionState();

  static Widget create(BuildContext context) {
    var db = Provider.of<Database>(context, listen: false);
    return ChangeNotifierProvider<FriendLinksManager>(
      create: (context) => FriendLinksManager(db: db),
      child: Consumer<FriendLinksManager>(
        builder: (_, friendLinksManager, __) =>
            SearchSection(friendLinksManager: friendLinksManager),
      ),
    );
  }
}

class _SearchSectionState extends State<SearchSection> {
  @override
  Widget build(BuildContext context) {
    Future<List<DatabaseModel>> Function(dynamic pattern) getUserList =
        (pattern) async {
      final db = Provider.of<Database>(context, listen: false);
      final List<String> friendIds = widget.friendLinksManager.friendIds;

      return await db.getUsersByIds(
          nameQuery: formatSearchParam(pattern), ids: friendIds);
    };

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
                        widget.friendLinksManager.switchUserMode();
                      },
                      child: widget.friendLinksManager.userMode == "users"
                          ? const Text('Find Friends')
                          : const Text('Find Users')),
                  SizedBox(width: 10),
                  TextButton(
                      onPressed: () => {}, child: const Text('Friend Requests'))
                ],
              ),
            ),
            SearchBar(
              getItemList: getUserList,
              onSelected: (DatabaseModel selected) {
                widget.friendLinksManager.selectedUser = selected;
              },
            ),
          ],
        ));
  }
}
