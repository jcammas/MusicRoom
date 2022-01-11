import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/messenger/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:music_room_app/services/database.dart';
import 'package:music_room_app/home/models/user.dart';

class SearchFriends extends StatefulWidget {
  const SearchFriends({Key? key}) : super(key: key);

  @override
  _SearchFriendsState createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  TextEditingController searchController = TextEditingController();

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
    FirestoreDatabase db =
        Provider.of<FirestoreDatabase>(context, listen: false);
    List<UserApp>? filteredName =
        db.getFilteredByName(searchController.text) as List<UserApp>;

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
                    onChanged: (value) {
                      print(value);
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => searchController.clear()),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              child: RefreshIndicator(
                  displacement: 100,
                  onRefresh:
                      Provider.of<FirestoreDatabase>(context, listen: false)
                          .usersList,
                  child: db.isLoading
                      ? CircularProgressIndicator()
                      : filteredName.length > 0
                          ? ListView.builder(
                              itemCount: filteredName.length,
                              itemBuilder: (_, i) {
                                return Text(filteredName[i].name);
                              })
                          : Text('Aucun user')),
            ),
          ),
          FutureBuilder<List<UserApp>>(
              future: db.usersList(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        return Text(snapshot.data![i].name);
                      });
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
        ],
      ),
    );
  }
}
