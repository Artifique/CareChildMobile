import 'package:cloud_firestore/cloud_firestore.dart';

class Appartenir {

  String id;
  String contenu;
  DateTime timestamp;
  String senderId;
  String receiverId;

  Appartenir({
    required this.id,
    required this.contenu,
    required this.timestamp,
    required this.senderId,
    required this.receiverId,
  });

  factory Appartenir.fromFirestore(Map<String, dynamic> json) {
    return Appartenir(
      id: json['id'],
      contenu: json['contenu'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'contenu': contenu,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': timestamp,
    };
  }
}
