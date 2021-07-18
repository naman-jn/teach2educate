import 'dart:convert';
import 'package:teach2educate/models/request_status_enum.dart';

class ChatRoom {
  String id;
  RequestStatus requestStatus;
  List<String> members;
  String requester;
  ChatRoom({
    required this.id,
    required this.requestStatus,
    required this.members,
    required this.requester,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'requestStatus': requestStatus.toString(),
      'members': members,
      'requester': requester,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'],
      requestStatus: RequestStatus.values
          .firstWhere((e) => e.toString() == map['requestStatus']),
      members: List<String>.from(map['members']),
      requester: map['requester'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source));
}
