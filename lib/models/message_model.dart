import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String content;
  String senderId;
  DateTime timestamp;
  Message({
    required this.content,
    required this.senderId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'senderId': senderId,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      content: map['content'],
      senderId: map['senderId'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));
}
