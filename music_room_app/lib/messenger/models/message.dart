import 'package:flutter/material.dart';

import '../utils.dart';

class MessageField {
  static const String createdAt = 'createdAt';
}

class Message {
  final String idUser;

  final String username;
  final String message;
  final DateTime? createdAt;

  const Message({
    required this.idUser,
    required this.username,
    required this.message,
    required this.createdAt,
  });

  static Message fromJson(Map<String, dynamic> json) => Message(
        idUser: json['uid'],
        username: json['name'],
        message: json['message'],
        createdAt: Utils.toDateTime(json['createdAt']),
      );

  Map<String, dynamic> toJson() => {
        'uid': idUser,
        'name': username,
        'message': message,
        'createdAt': Utils.fromDateTimeToJson(createdAt!),
      };
}
