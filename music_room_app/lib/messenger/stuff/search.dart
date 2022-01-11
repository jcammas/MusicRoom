import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/messenger/stuff/chat.dart';
import 'package:music_room_app/messenger/stuff/search_manager.dart';
import 'package:music_room_app/messenger/stuff/user_model.dart';

import 'package:provider/provider.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/home/models/user.dart';

class SearchFriends extends StatefulWidget {
  SearchFriends({Key? key, required this.model}) : super(key: key);

  SearchManager model;

  static Widget create(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    return ChangeNotifierProvider<SearchManager>(
      create: (_) => SearchManager(db: db),
      child: Consumer<SearchManager>(
        builder: (_, model, __) => SearchFriends(model: model),
      ),
    );
  }

  @override
  _SearchFriendsState createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  TextEditingController searchController = TextEditingController();

  SearchManager get model => widget.model;

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.getUsers();
    List<UserApp> filteredUsers =
        model.getFilteredByName(searchController.text);
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Search ...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onTap: () {},
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => searchController.clear()),
                )
              ],
            ),
          ),
          searchController.text.isEmpty
              ? const SizedBox()
              : Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: RefreshIndicator(
                        displacement: 100,
                        onRefresh: model.getUsers,
                        child: model.isLoading
                            ? const CircularProgressIndicator()
                            : filteredUsers.isNotEmpty
                                ? SizedBox(
                                    child: ListView.builder(
                                        itemCount: filteredUsers.length,
                                        itemBuilder: (_, i) {
                                          return GestureDetector(
                                            child: ListTile(
                                              leading: CircleAvatar(
                                                radius: 45,
                                                child: ClipOval(
                                                  child: Image.asset(
                                                      "images/avatar_random.png"),
                                                ),
                                              ),
                                              title: Text(
                                                filteredUsers[i].name,
                                                style: const TextStyle(
                                                    color: Colors.blueGrey,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            onTap: () {
                                              Object arguments = {
                                                "user": filteredUsers[i].name
                                              };
                                              Navigator.pushNamed(
                                                  context, ChatScreen.routeName,
                                                  arguments: arguments);
                                              setState(() =>
                                                  searchController.clear());
                                            },
                                          );
                                        }),
                                  )
                                : const SizedBox()),
                  ),
                ),
        ],
      ),
    );
  }
}
