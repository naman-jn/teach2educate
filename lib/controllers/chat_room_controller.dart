import 'package:teach2educate/models/chat_room_model.dart';
import 'package:teach2educate/models/passenger_model.dart';
import 'package:teach2educate/models/request_status_enum.dart';
import 'package:teach2educate/services/database_service.dart';

class ChatRoomController {
  String? coPassengerId;
  Passenger? passenger;
  ChatRoom? chatRoom;

  RequestStatus getRequestStatus() {
    RequestStatus _requestStatus = RequestStatus.requestDenied;
    if (passenger != null && coPassengerId != null) {
      if (!passenger!.chatRooms.keys.contains(coPassengerId))
        _requestStatus = RequestStatus.notConnected;
      else {
        if (chatRoom!.requester != passenger!.id) {
          switch (chatRoom!.requestStatus) {
            case RequestStatus.requestSent:
              _requestStatus = RequestStatus.requestReceieved;
              break;
            case RequestStatus.requestReceieved:
              _requestStatus = RequestStatus.requestSent;
              break;
            case RequestStatus.requestDenied:
              _requestStatus = RequestStatus.notConnected;
              break;
            default:
              _requestStatus = chatRoom!.requestStatus;
          }
        } else
          _requestStatus = chatRoom!.requestStatus;
      }
    }
    // log(_requestStatus.toString() + coPassengerId!);
    return _requestStatus;
  }

  Future<void> sendRequest() async {
    String? chatRoomId;
    if (chatRoom != null) {
      chatRoomId = chatRoom!.id;
    }

    await DatabaseService().sendChatRequest(
      coPassengerId!,
      chatRoomId,
    );
  }

  Future<void> acceptRequest() async {
    await DatabaseService()
        .updateChatRequest(chatRoom!.id, RequestStatus.connected);
  }

  Future<void> discardRequest() async {
    await DatabaseService()
        .updateChatRequest(chatRoom!.id, RequestStatus.notConnected);
  }

  Future<void> denyRequest() async {
    await DatabaseService()
        .updateChatRequest(chatRoom!.id, RequestStatus.requestDenied);
  }
}
