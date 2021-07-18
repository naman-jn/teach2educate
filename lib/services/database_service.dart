import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:teach2educate/models/chat_room_model.dart';
import 'package:teach2educate/models/message_model.dart';
import 'package:teach2educate/models/passenger_model.dart';
import 'package:teach2educate/models/request_status_enum.dart';

class DatabaseService {
  late FirebaseFirestore _db;
  late User? _user;
  late CollectionReference passengersCollection;
  late CollectionReference chatRoomsCollection;
  DatabaseService() {
    _db = FirebaseFirestore.instance;
    _user = FirebaseAuth.instance.currentUser;
    passengersCollection = _db.collection("passengers");
    chatRoomsCollection = _db.collection("chatRooms");
  }

  Stream<Passenger?> getPassengerDataStream() async* {
    if (_user != null) {
      final ref = passengersCollection.doc(_user!.uid);
      yield* ref.snapshots().map(
        (snap) {
          if (snap.exists) {
            return Passenger.fromMap(snap.data() as Map<String, dynamic>);
          } else {
            return null;
          }
        },
      );
    } else {
      yield null;
    }
  }

  Future<void> createNewPassenger(
      String name, String role, String company) async {
    if (_user != null)
      await passengersCollection.doc(_user!.uid).set(Passenger(
            name: name,
            phoneNumber: _user!.phoneNumber!,
            role: role,
            company: company,
            id: _user!.uid,
            chatRooms: {},
          ).toMap());
  }

  Future<bool?> isNewPassenger() async {
    if (_user != null) {
      var docSnapshot = await passengersCollection.doc(_user!.uid).get();
      return (!docSnapshot.exists);
    }
    return null;
  }

  List<Passenger> _coPassengersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Passenger _passenger =
          Passenger.fromMap(doc.data() as Map<String, dynamic>);
      return _passenger;
    }).toList();
  }

  Stream<List<Passenger>> getCoPassengerss() async* {
    yield* passengersCollection
        .where("id", isNotEqualTo: _user!.uid)
        .snapshots()
        .map((_coPassengersListFromSnapshot));
  }

  Stream<ChatRoom?> getChatRoomDetails(String? id) async* {
    if (id == null) {
      yield null;
    }
    var ref = chatRoomsCollection.doc(id);
    yield* ref.snapshots().map(
      (snap) {
        return ChatRoom.fromMap(snap.data() as Map<String, dynamic>);
      },
    );
  }

  Future<void> sendChatRequest(String coPassengerId,
      [String? chatRoomId]) async {
    String userId = _user!.uid;
    var ref = chatRoomsCollection.doc(chatRoomId);
    ref.set(ChatRoom(
            id: ref.id,
            requestStatus: RequestStatus.requestSent,
            members: [userId, coPassengerId],
            requester: userId)
        .toMap());

    await passengersCollection
        .doc(userId)
        .update({"chatRooms.$coPassengerId": ref.id});
    await passengersCollection
        .doc(coPassengerId)
        .update({"chatRooms.$userId": ref.id});
  }

  Future<void> updateChatRequest(
      String chatRoomId, RequestStatus newRequestStatus) async {
    await chatRoomsCollection
        .doc(chatRoomId)
        .update({"requestStatus": newRequestStatus.toString()});
  }

  List<Message> _messageListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      Message _passenger = Message.fromMap(doc.data() as Map<String, dynamic>);
      return _passenger;
    }).toList();
  }

  Stream<List<Message>> getChatMesaages(String chatRoomId) async* {
    yield* chatRoomsCollection
        .doc(chatRoomId)
        .collection('messages')
        .orderBy("timestamp")
        .snapshots()
        .map((_messageListFromSnapshot));
  }

  Future<void> sendMessage(String chatRoomId, Message message) async {
    await chatRoomsCollection
        .doc(chatRoomId)
        .collection('messages')
        .doc()
        .set(message.toMap());
  }
}
