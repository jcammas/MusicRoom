import 'package:music_room_app/home/models/database_model.dart';
import '../../services/api_path.dart';

class MessageField {
  static const String createdAt = 'createdAt';
}

class Message implements DatabaseModel {
  const Message({
    required this.senderId,
    required this.receiverId,
    this.senderName,
    this.receiverName,
    required this.message,
    required this.createdAt,
  });

  final String senderId;
  final String receiverId;
  final String? senderName;
  final String? receiverName;
  final String message;
  final DateTime createdAt;

  @override
  get docId =>
      DBPath.chatMessage(senderId, receiverId, createdAt.toIso8601String());
  @override
  List<String> get wrappedCollectionsIds => [];

  factory Message.fromMap(Map<String, dynamic>? data, String id) {
    List<String> ids = id.split('_');
    final String senderId = ids[0];
    DateTime createdAt;
    if (data != null) {
      final String receiverId = data['receiver_id'] ?? 'receiver_id_missing';
      final String? senderName = data['sender_name'];
      final String? receiverName = data['receiver_name'];
      final String message = data['message'] ?? "";
      try {
        createdAt = DateTime.parse(data['created_at']);
      } catch (FormatException) {
        createdAt = DateTime.now();
      }
      return Message(
          senderId: senderId,
          receiverId: receiverId,
          senderName: senderName,
          receiverName: receiverName,
          message: message,
          createdAt: createdAt);
    } else {
      try {
        createdAt = ids.length > 1 ? DateTime.parse(ids[1]) : DateTime.now();
      } catch (FormatException) {
        createdAt = DateTime.now();
      }
      return Message(
          senderId: senderId,
          receiverId: 'receiver_id_missing',
          message: '',
          createdAt: createdAt);
    }
  }

  Map<String, dynamic> toMap() => {
        'sender_id': senderId,
        'receiver_id': receiverId,
        'sender_name': senderName,
        'receiver_name': receiverName,
        'message': message,
        'created_at': createdAt.toIso8601String()
      };
}
