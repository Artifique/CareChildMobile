class Inscription {
  final String idParent;
  final String idEvent;

  Inscription({
    required this.idParent,
    required this.idEvent,
  });

  // Convertir en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'idParent': idParent,
      'idEvent': idEvent,
    };
  }

  // Créer depuis Firestore
  factory Inscription.fromFirestore(Map<String, dynamic> data) {
    return Inscription(
      idParent: data['idParent'],
      idEvent: data['idEvent'],
    );
  }
}
