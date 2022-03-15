import 'package:flutter/material.dart';
import '../../home/models/user.dart';
import '../../services/database.dart';
import '../models/message.dart';

class NewMessageWidget extends StatefulWidget {
  final UserApp currentUser;
  final UserApp interlocutor;
  final Database db;

  const NewMessageWidget({
    required this.db,
    required this.currentUser,
    required this.interlocutor,
    Key? key,
  }) : super(key: key);

  @override
  _NewMessageWidgetState createState() => _NewMessageWidgetState();
}

class _NewMessageWidgetState extends State<NewMessageWidget> {
  final _controller = TextEditingController();
  String message = '';

  void sendMessage() async {
    FocusScope.of(context).unfocus();

    await widget.db.set(new Message(
        senderId: widget.currentUser.uid,
        receiverId: widget.interlocutor.uid,
        senderName: widget.currentUser.name,
        receiverName: widget.interlocutor.name,
        message: message,
        createdAt: DateTime.now()));

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) =>
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                textCapitalization: TextCapitalization.sentences,
                autocorrect: true,
                enableSuggestions: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelText: 'Type your message',
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0),
                    gapPadding: 10,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: (value) =>
                    setState(() {
                      message = value;
                    }),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: message
                  .trim()
                  .isEmpty ? null : sendMessage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ),
          ],
        ),
      );
}
