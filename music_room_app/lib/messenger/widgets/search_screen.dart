import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/user.dart';

class SearchScreen extends StatefulWidget {
  UserApp? user;
  SearchScreen({Key? key, this.user}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
          hintText: "search your friends ...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          )),
    );
  }
}
