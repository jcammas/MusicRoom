import 'package:flutter/material.dart';
import 'package:music_room_app/account/widgets/titled_switch.dart';

class PrivacySettingsForm extends StatefulWidget {
  @override
  State<PrivacySettingsForm> createState() => _PrivacySettingsFormState();
}

class _PrivacySettingsFormState extends State<PrivacySettingsForm> {
  bool isSwitchedEmail = false;
  bool isSwitchedEmailWithFriends = false;
  bool isSwitchedFriends = false;
  bool isSwitchedFriendsWithFriends = false;
  bool isSwitchedPlaylist = false;
  bool isSwitchedPlaylistWithFriends = false;

  @override
  Widget build(context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
        ),
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back)),
              Text(
                "Account Privacy",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              TitledSwitch(
                  title: "My email",
                  value: isSwitchedEmail,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedEmail= value;
                    });
                  }),
              TitledSwitch(
                  title: "My friends",
                  value: isSwitchedFriends,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedFriends = value;
                    });
                  }),
              TitledSwitch(
                  title: "My playlists",
                  value: isSwitchedPlaylist,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedPlaylist = value;
                    });
                  }),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                "Only friends can see",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              isSwitchedEmail
                  ? TitledSwitch(
                  title: "My email",
                  value: isSwitchedEmailWithFriends,
                  icon: Icons.people,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedEmailWithFriends = value;
                    });
                  })
                  : SizedBox(),
              isSwitchedFriends
                  ? TitledSwitch(
                  title: "My friends",
                  value: isSwitchedFriendsWithFriends,
                  icon: Icons.people,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedFriendsWithFriends = value;
                    });
                  })
                  : SizedBox(),
              isSwitchedPlaylist
                  ? TitledSwitch(
                  title: "My playlists",
                  value: isSwitchedPlaylistWithFriends,
                  icon: Icons.people,
                  onChanged: (value) {
                    setState(() {
                      isSwitchedPlaylistWithFriends = value;
                    });
                  },)
                  : SizedBox(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                       Theme.of(context).primaryColor,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isSwitchedEmail = false;
                      isSwitchedEmailWithFriends = false;
                      isSwitchedFriends = false;
                      isSwitchedFriendsWithFriends = false;
                      isSwitchedPlaylist = false;
                      isSwitchedPlaylistWithFriends = false;
                    });
                  },
                  child: Text(
                    "Reset privacy settings",
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
