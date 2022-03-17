import 'package:flutter/material.dart';
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
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.02,
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
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
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
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.02,
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
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.05,
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
  }
}