import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  late final String idMessage;
  final String contenu;
  final DateTime dateEnvoi;
  final String emetteurId;
  final String recepteurId;
  final String? idGroupe;

  Message({
    required this.idMessage,
    required this.contenu,
    required this.dateEnvoi,
    required this.emetteurId,
    required this.recepteurId,
 
    this.idGroupe,
  });

  // Convertir en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'idMessage': idMessage,
      'contenu': contenu,
      'dateEnvoi': dateEnvoi,
      'emetteurId': emetteurId,
      'recepteurId': recepteurId,
      'idGroupe': idGroupe,
    };
  }

  // Créer depuis Firestore
  factory Message.fromFirestore(Map<String, dynamic> data, String idMessage) {
    return Message(
      idMessage: idMessage,
      contenu: data['contenu'],
      dateEnvoi: (data['dateEnvoi'] as Timestamp).toDate(),
      emetteurId: data['emetteurId'],
      recepteurId: data['recepteurId'],
      idGroupe: data['idGroupe'],
    );
  }
}
