import 'package:music_room_app/services/api_path.dart';
import '../../home/models/database_model.dart';
import 'message.dart';

class Chat implements DatabaseModel {
  Chat(
      {required this.uid1,
        required this.uid2,
        this.userName1,
        this.userName2,
        this.messages});

  final String uid1;
  final String uid2;
  String? userName1;
  String? userName2;
  Map<String, Message>? messages;

  @override
  get docId => DBPath.chat(uid1, uid2);
  @override
  List<String> get wrappedCollectionsIds => [DBPath.chatMessages(uid1, uid2)];
  String get name => (userName1 ?? "Unknown") + '_' + (userName2 ?? "Unknown");

  factory Chat.fromMap(Map<String, dynamic>? data, String id) {
    List<String> ids = id.split('_');
    final String uid1 = ids[0];
    final String uid2 = ids.length > 1 ? ids[1] : 'N/A';
    if (data != null) {
      final String? userName1 = data['user_name_1'];
      final String? userName2 = data['user_name_2'];
      Map<String, Message> messages = {};
      Map<String, dynamic>? messagesData = data['messages'];
      if (messagesData != null) {
        messagesData.updateAll((id, message) => Message.fromMap(message, id));
        messages = messagesData.cast();
      }
      return Chat(
        uid1: uid1,
        uid2: uid2,
        userName1: userName1,
        userName2: userName2,
        messages: messages,
      );
    } else {
      return Chat(
        uid1: uid1,
        uid2: uid2,
      );
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'uid1': uid1,
      'uid2': uid2,
      'user_name_1': userName1,
      'user_name_2': userName2,
      'messages': messages,
    };
  }

}