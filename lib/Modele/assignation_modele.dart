class Assignation {
  final String id;
  final String idEnfant;
  final String idSpecialiste;
  final DateTime dateAssignation;

  Assignation({
    required this.id,
    required this.idEnfant,
    required this.idSpecialiste,
    required this.dateAssignation,
  });

  // Convertir en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'idEnfant': idEnfant,
      'idSpecialiste': idSpecialiste,
      'dateAssignation': dateAssignation.toIso8601String(),
    };
  }

  // Créer depuis Firestore
  factory Assignation.fromFirestore(Map<String, dynamic> data) {
    return Assignation(
      id: data['id'],
      idEnfant: data['idEnfant'],
      idSpecialiste: data['idSpecialiste'],
      dateAssignation: DateTime.parse(data['dateAssignation']),
    );
  }
}
