import 'package:flutter/cupertino.dart';
import 'package:teach2educate/models/passenger_model.dart';

class ActiveChat with ChangeNotifier {
  String? chatRoomId;
  Passenger? coPassenger;

  setActiveChat({required String chatRoomId, required Passenger coPassenger}) {
    this.chatRoomId = chatRoomId;
    this.coPassenger = coPassenger;
    notifyListeners();
  }

  deActivateChat() {
    this.chatRoomId = null;
    this.coPassenger = null;
    notifyListeners();
  }

  bool get isChatInActive => (chatRoomId == null && coPassenger == null);
}
