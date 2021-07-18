import 'dart:convert';

class Passenger {
  final String name;
  final String phoneNumber;
  final String role;
  final String company;
  final String id;
  final Map chatRooms;

  Passenger({
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.company,
    required this.id,
    required this.chatRooms,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'role': role,
      'company': company,
      'id': id,
      'chatRooms': chatRooms,
    };
  }

  factory Passenger.fromMap(Map<String, dynamic> map) {
    return Passenger(
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      role: map['role'],
      company: map['company'],
      id: map['id'],
      chatRooms: Map.from(map['chatRooms'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory Passenger.fromJson(String source) =>
      Passenger.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Passenger(name: $name, phoneNumber: $phoneNumber, role: $role, company: $company, id: $id, chatRooms: $chatRooms)';
  }
}
