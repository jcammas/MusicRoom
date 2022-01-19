import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';

class MessengerScreen extends StatefulWidget {
  UserApp? user;

  MessengerScreen({Key? key}) : super(key: key);

  static const String routeName = '/messenger';

  @override
  _MessengerScreenState createState() => _MessengerScreenState();
}

class _MessengerScreenState extends State<MessengerScreen> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;

  void onSearch() async {
    setState(() {
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('user_info')
        .where("name", isEqualTo: searchController.text)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No User found")));
        setState(() {
          isLoading = false;
        });
        return;
      }
      value.docs.forEach((e) {
        // if (user.data()["email"] != widget.user!.email) {
        //   searchResult.add(user.data());
        // }
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appText: 'Messenger', context: context),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: const MyDrawer(),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                  hintText: "type username",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          )
        ],
      ),
    );
  }
}
