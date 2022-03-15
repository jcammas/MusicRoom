import 'package:flutter/material.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:music_room_app/home/widgets/drawer.dart';
// import 'package:music_room_app/services/database.dart';
// import 'package:provider/provider.dart';
// import 'package:music_room_app/services/auth.dart';
// import 'models/user.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  static const String routeName = '/friends';

  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appText: 'Friends', context: context),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: const MyDrawer(),
      body: Container(child: Column(children: <Widget>[SearchSection()])),
    );
  }
}

class FriendDisplay extends StatelessWidget {
  const FriendDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 150, color: Colors.red, margin: const EdgeInsets.all(8.0));
  }
}

class SearchSection extends StatelessWidget {
  const SearchSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey[300],
        padding: EdgeInsets.fromLTRB(10, 25, 10, 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.only(left: 5),
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).shadowColor,
                            offset: Offset(0, 3.0),
                            blurRadius: 4.0),
                      ]),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'John Doe',
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                  ),
                )),
                SizedBox(width: 10),
                Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Theme.of(context).shadowColor,
                          offset: Offset(0, 3.0),
                          blurRadius: 4.0),
                    ], borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Icon(Icons.search),
                    )),
              ],
            ),
            SizedBox(height: 50),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red,
              ),
            )
          ],
        ));
  }
}
// class SearchSection extends StatefulWidget {
//   const SearchSection({Key? key}) : super(key: key);

//   @override
//   _SearchSectionState createState() => _SearchSectionState();
// }

// class _SearchSectionState extends State<SearchSection> {
//   TextEditingController searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: searchController,
//         decoration: InputDecoration(
//             hintText: "John Doe",
//             border:
//                 OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
//       ),
//     );
//   }
// }
