import 'package:flutter/material.dart';
import 'package:music_room_app/friends/services/search-friend-manager.dart';
import 'package:music_room_app/home/models/database_model.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/widgets/search-bar.dart';
import 'package:music_room_app/widgets/utils.dart';
import 'package:provider/provider.dart';

class SearchSection extends StatefulWidget {
  SearchSection({required this.searchManager});
  final SearchFriendManager searchManager;

  @override
  State<SearchSection> createState() => _SearchSectionState();

  static Widget create(BuildContext context) {
    var db = Provider.of<Database>(context, listen: false);
    // return ChangeNotifierProvider<SearchFriendManager>(
    //   create: (context) => SearchFriendManager(db: db),
    //   child: Consumer<SearchFriendManager>(
    //     builder: (_, searchManager, __) =>
    //         SearchSection(searchManager: searchManager),
    //   ),
    // );
    return SearchSection(searchManager: SearchFriendManager(db: db));
  }
}

class _SearchSectionState extends State<SearchSection> {
  @override
  Widget build(BuildContext context) {
    Future<List<DatabaseModel>> Function(dynamic pattern) getUserList =
        (pattern) async {
      final db = Provider.of<Database>(context, listen: false);
      final currentUser = await db.getUser();
      final friendList = currentUser.friends;
      return await db.getUsersByIds(
          nameQuery: formatSearchParam(pattern), ids: friendList);
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
                      onPressed: () => {},
                      child: const Text('Friend Requests')),
                  SizedBox(width: 10),
                  TextButton(
                      onPressed: () => {}, child: const Text('Find Friends'))
                ],
              ),
            ),
            SearchBar(
              getItemList: getUserList,
              onSelected: (DatabaseModel selected) {
                widget.searchManager.selectedUser = selected;
              },
            ),
          ],
        ));
  }
}
