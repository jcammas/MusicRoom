import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:music_room_app/account/widgets/custom_settings_tile.dart';
import 'package:music_room_app/home/models/user.dart';
import 'package:music_room_app/services/auth.dart';
import 'package:music_room_app/services/database.dart';
import 'package:provider/provider.dart';
import 'account_manager.dart';

class AccountForm extends StatefulWidget {
  const AccountForm({Key? key, required this.manager}) : super(key: key);
  final AccountManager manager;

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final db = Provider.of<Database>(context, listen: false);
    return ChangeNotifierProvider<AccountManager>(
      create: (_) => AccountManager(auth: auth, db: db),
      child: Consumer<AccountManager>(
        builder: (_, model, __) => AccountForm(manager: model),
      ),
    );
  }

  @override
  State<AccountForm> createState() => _AccountFormState();
}

class _AccountFormState extends State<AccountForm> {
  late Map<String, dynamic> settingsData;
  bool isSwitchedEmail = false;
  bool isSwitchedEmailWithFriends = false;
  bool isSwitchedFriends = false;
  bool isSwitchedFriendsWithFriends = false;
  bool isSwitchedPlaylist = false;
  bool isSwitchedPlaylistWithFriends = false;

  Map<String, dynamic> fillSettingsData(UserApp? user) {
    return <String, dynamic>{
      'Name': user == null ? 'N/A' : user.name,
      'Email': user == null ? 'N/A' : user.email,
      'Friends': user == null ? 'N/A' : user.friends,
      'playlist': user == null ? 'N/A' : user.playlists,
    };
  }

  _myPrivacySettings(context) {
    showModalBottomSheet(
        context: context,
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return SingleChildScrollView(
              child: Container(
                color: Colors.transparent,
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
                            color: Color(0XFF072BB8),
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "My e-mail",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0XFF434343),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Switch(
                                activeTrackColor: Color(0XFF072BB8),
                                activeColor: Color(0XFF072BB8),
                                value: isSwitchedEmail,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitchedEmail = value;
                                  });
                                }),
                            isSwitchedEmail
                                ? Icon(Icons.lock, color: Color(0XFF072BB8))
                                : SizedBox(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "My friends list",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0XFF434343),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Switch(
                                activeTrackColor: Color(0XFF072BB8),
                                activeColor: Color(0XFF072BB8),
                                value: isSwitchedFriends,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitchedFriends = value;
                                  });
                                }),
                            isSwitchedFriends
                                ? Icon(Icons.lock, color: Color(0XFF072BB8))
                                : SizedBox(),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "My playlist",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0XFF434343),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Switch(
                                activeTrackColor: Color(0XFF072BB8),
                                activeColor: Color(0XFF072BB8),
                                value: isSwitchedPlaylist,
                                onChanged: (value) {
                                  setState(() {
                                    isSwitchedPlaylist = value;
                                  });
                                }),
                            isSwitchedPlaylist
                                ? Icon(Icons.lock, color: Color(0XFF072BB8))
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Text(
                          "Only friends can see",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0XFF072BB8),
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        isSwitchedEmail
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "My e-mail",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0XFF434343),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Switch(
                                      activeTrackColor: Color(0XFF072BB8),
                                      activeColor: Color(0XFF072BB8),
                                      value: isSwitchedEmailWithFriends,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitchedEmailWithFriends = value;
                                        });
                                      }),
                                  isSwitchedEmailWithFriends
                                      ? Icon(Icons.people,
                                          color: Color(0XFF072BB8))
                                      : SizedBox(),
                                ],
                              )
                            : SizedBox(),
                        isSwitchedFriends
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "My friends list",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0XFF434343),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Switch(
                                      activeTrackColor: Color(0XFF072BB8),
                                      activeColor: Color(0XFF072BB8),
                                      value: isSwitchedFriendsWithFriends,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitchedFriendsWithFriends = value;
                                        });
                                      }),
                                  isSwitchedFriendsWithFriends
                                      ? Icon(Icons.people,
                                          color: Color(0XFF072BB8))
                                      : SizedBox(),
                                ],
                              )
                            : SizedBox(),
                        isSwitchedPlaylist
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "My playlists",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0XFF434343),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Switch(
                                      activeTrackColor: Color(0XFF072BB8),
                                      activeColor: Color(0XFF072BB8),
                                      value: isSwitchedPlaylistWithFriends,
                                      onChanged: (value) {
                                        setState(() {
                                          isSwitchedPlaylistWithFriends = value;
                                        });
                                      }),
                                  isSwitchedPlaylistWithFriends
                                      ? Icon(
                                          Icons.people,
                                          color: Color(0XFF072BB8),
                                        )
                                      : SizedBox(),
                                ],
                              )
                            : SizedBox(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                const Color(0XFF072BB8),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
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
              ),
            );
          });
        }).whenComplete(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    return StreamBuilder<UserApp>(
      stream: widget.manager.getUserStream(),
      builder: (context, snapshot) {
        UserApp? user = snapshot.data;
        settingsData = fillSettingsData(user);
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    radius: 45,
                    child: ClipOval(
                      child: Image.asset("images/avatar_random.png"),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: screenHeight * 0.7,
                child: SettingsList(
                  sections: [
                    SettingsSection(
                      tiles: [
                        CustomSettingsTile(
                            type: SettingType.name,
                            title: 'Name',
                            manager: widget.manager,
                            user: user,
                            subtitle: settingsData['Name'].toString(),
                            iconData: Icons.face),
                        CustomSettingsTile(
                            type: SettingType.email,
                            title: 'Email',
                            manager: widget.manager,
                            user: user,
                            subtitle: settingsData['Email'].toString(),
                            iconData: Icons.email),
                        CustomSettingsTile(
                            type: SettingType.newPassword,
                            title: 'Change Password',
                            manager: widget.manager,
                            user: user,
                            iconData: Icons.lock),
                        SettingsTile(
                          title: 'Devices Settings',
                          leading: const Icon(Icons.radio),
                          onPressed: (BuildContext context) {},
                        ),
                        SettingsTile(
                          title: 'Privacy Settings',
                          leading: const Icon(
                            Icons.privacy_tip,
                            color: Color(0XFF072BB8),
                          ),
                          onPressed: (BuildContext context) {
                            _myPrivacySettings(context);
                          },
                        ),
                        SettingsTile(
                          title: 'Default Room Settings',
                          leading: const Icon(Icons.music_note,
                              color: Color(0XFF072BB8)),
                          onPressed: (BuildContext context) {},
                        ),
                        CustomSettingsTile(
                            type: SettingType.delete,
                            title: 'Delete Account',
                            manager: widget.manager,
                            user: user,
                            iconData: Icons.delete_forever),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
