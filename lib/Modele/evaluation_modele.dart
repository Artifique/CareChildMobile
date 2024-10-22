import 'package:cloud_firestore/cloud_firestore.dart';

class Evaluation {
  String id; // Identifiant unique de l'évaluation
  String enfantId; // Identifiant de l'enfant évalué
  String specialisteId; // Identifiant du spécialiste qui effectue l'évaluation
  DateTime dateEvaluation; // Date de l'évaluation
  String commentaires; // Commentaires ou observations du spécialiste
  List<String> recommandations; // Recommandations pour l'enfant

  Evaluation({
    required this.id,
    required this.enfantId,
    required this.specialisteId,
    required this.dateEvaluation,
    this.commentaires = '', // Vide par défaut
    this.recommandations = const [], // Liste vide par défaut
  });

  factory Evaluation.fromFirestore(Map<String, dynamic> json) {
    return Evaluation(
      id: json['id'],
      enfantId: json['enfantId'],
      specialisteId: json['specialisteId'],
      dateEvaluation: (json['dateEvaluation'] as Timestamp).toDate(),
      commentaires: json['commentaires'] ?? '',
      recommandations: List<String>.from(json['recommandations'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'enfantId': enfantId,
      'specialisteId': specialisteId,
      'dateEvaluation': dateEvaluation,
      'commentaires': commentaires,
      'recommandations': recommandations,
    };
  }
}