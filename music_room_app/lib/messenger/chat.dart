import 'package:flutter/material.dart';
import 'package:music_room_app/home/widgets/drawer.dart';
import 'package:music_room_app/messenger/models/user_model.dart';
import 'package:music_room_app/widgets/custom_appbar.dart';

import 'models/message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const String routeName = '/chatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  _buildMessage(Message message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? const Color(0XFF072BB8) : Colors.blueGrey[200],
        borderRadius: isMe
            ? const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : const BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.time!,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            message.text!,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        IconButton(
          icon: message.isLiked!
              ? const Icon(Icons.favorite)
              : const Icon(Icons.favorite_border),
          iconSize: 30.0,
          color: message.isLiked! ? Colors.red : Colors.blueGrey,
          onPressed: () {},
        )
      ],
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: const InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    User user = arg["user"];

    return Scaffold(
        appBar: customAppBar(appText: user.name, context: context),
        backgroundColor: Theme.of(context).backgroundColor,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.lightBlue[50],
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 15),
                      itemCount: messages.length,
                      itemBuilder: (context, i) {
                        final Message message = messages[i];
                        final bool isMe = message.sender!.id == currentUser.id;
                        return _buildMessage(message, isMe);
                      }),
                ),
              ),
              _buildMessageComposer(),
            ],
          ),
        ));
  }
}
