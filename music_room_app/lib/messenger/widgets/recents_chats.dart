import 'package:flutter/material.dart';
import 'package:music_room_app/messenger/chat.dart';
import 'package:music_room_app/messenger/models/message_model.dart';

class RecentChats extends StatelessWidget {
  const RecentChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, i) {
                final Message chat = chats[i];
                return GestureDetector(
                  onTap: () {
                    Object arguments = {
                      "user": chat.sender,
                    };
                    Navigator.pushNamed(context, ChatScreen.routeName,
                        arguments: arguments);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5, right: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: chat.unread! ? Colors.lightBlue[50] : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: <Widget>[
                            const CircleAvatar(
                              radius: 35,
                              backgroundImage:
                                  AssetImage("images/avatar_random.png"),
                            ),
                            SizedBox(
                              width: screenHeight * 0.01,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chat.sender!.name,
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                SizedBox(
                                  width: screenWidth * 0.45,
                                  child: Text(
                                    chat.text!,
                                    style: const TextStyle(
                                        color: Colors.blueGrey,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              Text(
                                chat.time!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              chat.unread!
                                  ? Container(
                                      width: 40,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'new'.toUpperCase(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color: Colors.white),
                                      ),
                                    )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
