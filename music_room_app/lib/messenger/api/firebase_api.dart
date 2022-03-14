import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:music_room_app/messenger/models/user.dart';
import '../models/message.dart';
import '../utils.dart';

class FirebaseApi {

  static Future uploadMessage(
      String idReceiver, String idSender, String message, String username) async {
    final refMessages =
        FirebaseFirestore.instance.collection('chats/$idChat/messages');

    final newMessage = Message(
      idUser: idUser,
      username: username,
      message: message,
      createdAt: DateTime.now(),
    );
    await refMessages.add(newMessage.toJson());

    final refUsers = FirebaseFirestore.instance.collection('user_info');
    await refUsers
        .doc(idUser)
        .update({UserField.lastMessageTime: DateTime.now()});
  }

  static Stream<List<Message>> getMessages(String idUser) =>
      FirebaseFirestore.instance
          .collection('chats/$idUser/messages')
          .orderBy(MessageField.createdAt, descending: true)
          .snapshots()
          .transform(Utils.transformer(Message.fromJson));

  static Future addRandomUsers(List<User> users) async {
    final refUsers = FirebaseFirestore.instance.collection('user_info');

    final allUsers = await refUsers.get();
    if (allUsers.size != 0) {
      return;
    } else {
      for (final user in users) {
        final userDoc = refUsers.doc();
        final newUser = user.copyWith(uid: userDoc.id);

        await userDoc.set(newUser.toJson());
      }
    }
  }
}
