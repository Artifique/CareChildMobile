import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {

  String id;
  String message;
  DateTime timestamp;
   String parenId;

  Notification({
    required this.id,
    required this.message,
    required this.timestamp,
    required this.parenId,
  });

  factory Notification.fromFirestore(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      message: json['message'],
      parenId: json['parenId'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'message': message,
      'parenId': parenId,
      'timestamp': timestamp,
    };
  }
}
