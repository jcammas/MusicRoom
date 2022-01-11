import 'package:flutter/material.dart';
import 'package:music_room_app/messenger/stuff/message_model.dart';

import '../stuff/chat.dart';

class Favorite extends StatelessWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.03,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Text(
                  'Favorite contacts',
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      letterSpacing: 1.2),
                ),
              ],
            ),
          ),
          SizedBox(
              height: screenHeight * 0.15,
              child: ListView.builder(
                padding: EdgeInsets.only(left: screenWidth * 0.03),
                scrollDirection: Axis.horizontal,
                itemCount: favorites.length,
                itemBuilder: (context, i) {
                  return GestureDetector(
                    onTap: () {
                      Object arguments = {
                        "user": favorites[i].name,
                      };
                      Navigator.pushNamed(context, ChatScreen.routeName,
                          arguments: arguments);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.02),
                      child: Column(
                        children: <Widget>[
                          const CircleAvatar(
                            radius: 35,
                            backgroundImage:
                                AssetImage("images/avatar_random.png"),
                          ),
                          SizedBox(
                            height: screenHeight * 0.006,
                          ),
                          Text(favorites[i].name,
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  );
                },
              ))
        ],
      ),
    );
  }
}
