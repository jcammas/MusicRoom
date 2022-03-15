import 'dart:async';

import 'package:flutter/material.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';
import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:music_room_app/services/database.dart';
import 'package:provider/provider.dart';
// import 'package:music_room_app/services/auth.dart';
// import 'models/user.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({Key? key}) : super(key: key);

  static const String routeName = '/friends';

  @override
  _FriendScreenState createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(appText: 'Friends', context: context),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[SearchSection(), FriendSection()])),
    );
  }
}

class FriendSection extends StatefulWidget {
  @override
  State<FriendSection> createState() => _FriendSectionState();
}

class _FriendSectionState extends State<FriendSection> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final Stream<UserApp> _user = db.userStream();

    return Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: StreamBuilder<UserApp>(
          stream: _user,
          builder: (BuildContext context, AsyncSnapshot<UserApp> snapshot) {
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
                  List<String> friends = snapshot.data!.friends;
                  List foundFriends = [];
                  String displayFound = foundFriends.length > 0
                      ? 'Found' + foundFriends.length.toString() + 'friends'
                      : '';
                  String displayTotal =
                      'Total friends: ' + friends.length.toString();
                  children = <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            displayFound,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          Text(
                            displayTotal,
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: friends.map((friend) {
                        return FriendCard(friend);
                      }).toList(),
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

class FriendCard extends StatelessWidget {
  // final List friendList = [
  //   {
  //     'surname': 'Toto',
  //     'name': 'Poto',
  //     'avatar': 'https://picsum.photos/id/2/200',
  //   },
  //   {
  //     'surname': 'Jambon',
  //     'name': 'Beurre',
  //     'avatar': 'https://picsum.photos/id/1/200',
  //   },
  //   {
  //     'surname': 'Jean',
  //     'name': 'Ticip',
  //     'avatar': 'https://picsum.photos/id/3/200',
  //   },
  //   {
  //     'surname': 'Joe',
  //     'name': 'LaDouilleBlazeARallongeQuiCasseLeCraneFrrPourquoi',
  //     'avatar': 'https://picsum.photos/id/4/200',
  //   }
  // ];
  final String friendData;
  FriendCard(this.friendData);

  @override
  Widget build(BuildContext context) {
    String displayName = friendData;
    return Container(
      margin: EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor,
                offset: Offset(0, 3.0),
                blurRadius: 6.0),
          ],
          borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 3,
              child: Container(
                width: 90,
                height: 90,
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.blue,
                    image: DecorationImage(
                        image: NetworkImage('https://picsum.photos/id/4/200'),
                        fit: BoxFit.cover)),
              )),
          Expanded(
            flex: 5,
            child: Text(displayName,
                // overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline6),
          ),
          Expanded(
              flex: 2,
              child: MaterialButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.more_horiz,
                    color: Colors.white,
                  )))
        ],
      ),
    );
  }
}

class SearchSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  // SizedBox(width: 10),
                  // TextButton(
                  //     onPressed: () => {}, child: const Text('Find Friends'))
                ],
              ),
            ),
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
          ],
        ));
  }
}
