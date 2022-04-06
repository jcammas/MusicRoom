import 'package:flutter/material.dart';
import 'package:music_room_app/constant_colors.dart';
import 'package:music_room_app/home/models/friend-link.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class FriendCard extends StatefulWidget {
  final String friendUid;
  FriendCard(this.friendUid);

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  @override
  Widget build(BuildContext context) {
    final db = Provider.of<Database>(context, listen: false);
    final Stream<UserApp> _friend = db.userStreamById(widget.friendUid);

    return Container(
      margin: EdgeInsets.all(10),
      height: 100,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          boxShadow: [
            const BoxShadow(
                color: shadowColor, offset: Offset(0, 3.0), blurRadius: 6.0),
          ],
          borderRadius: BorderRadius.all(Radius.circular(18))),
      child: StreamBuilder<UserApp>(
        stream: _friend,
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
                    child: Text('Awaiting friend\'s data'),
                  )
                ];
                break;

              default:
                String displayName = snapshot.data!.name;
                String avatar = snapshot.data!.avatarUrl;

                children = <Widget>[
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
                                image: NetworkImage(avatar),
                                fit: BoxFit.cover)),
                      )),
                  Expanded(
                    flex: 5,
                    child: Text(displayName,
                        style: Theme.of(context).textTheme.headline6),
                  ),
                  Expanded(flex: 2, child: CustomButtonTest(widget.friendUid))
                ];
            }
          }

          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: children);
        },
      ),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> firstItems = [dm, delete];
  // static const List<MenuItem> secondItems = [logout];

  static const dm = MenuItem(text: 'DM', icon: Icons.mail);
  static const delete = MenuItem(text: 'Delete', icon: Icons.delete_forever);
  // static const settings = MenuItem(text: 'Settings', icon: Icons.settings);
  // static const logout = MenuItem(text: 'Log Out', icon: Icons.logout);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item, friendUid) {
    var db = Provider.of<Database>(context, listen: false);

    switch (item) {
      case MenuItems.dm:
        //Open dm funnel with selected friend using passed 'friendUid'
        break;
      case MenuItems.delete:
        db.set(FriendLink(users: [db.uid, friendUid], status: "pending"));
        // db.delete(FriendLink(users: friendUid, friend: db.uid));
        break;
    }
  }
}

class CustomButtonTest extends StatefulWidget {
  const CustomButtonTest(this.friendUid);
  final String friendUid;

  @override
  State<CustomButtonTest> createState() => _CustomButtonTestState();
}

class _CustomButtonTestState extends State<CustomButtonTest> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: const Icon(
          Icons.more_horiz,
          size: 46,
          color: Colors.white,
        ),
        customItemsIndexes: const [3],
        customItemsHeight: 8,
        items: [
          ...MenuItems.firstItems.map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          ),
          // const DropdownMenuItem<Divider>(enabled: false, child: Divider()),
          // ...MenuItems.secondItems.map(
          //   (item) => DropdownMenuItem<MenuItem>(
          //     value: item,
          //     child: MenuItems.buildItem(item),
          //   ),
          // ),
        ],
        onChanged: (value) {
          MenuItems.onChanged(context, value as MenuItem, widget.friendUid);
        },
        itemHeight: 48,
        itemPadding: const EdgeInsets.only(left: 16, right: 16),
        dropdownWidth: 110,
        dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
        dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: primaryColor,
        ),
        dropdownElevation: 8,
        offset: const Offset(0, 8),
      ),
    );
  }
}
