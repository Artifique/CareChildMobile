class ParticipantsGroupe {
  final String idGroupe;
  final String? idParent;
  final String? idSpecialiste;

  ParticipantsGroupe({
    required this.idGroupe,
    this.idParent,
    this.idSpecialiste,
  });

  // Convertir en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'idGroupe': idGroupe,
      'idParent': idParent,
      'idSpecialiste': idSpecialiste,
    };
  }

  // Créer depuis Firestore
  factory ParticipantsGroupe.fromFirestore(Map<String, dynamic> data) {
    return ParticipantsGroupe(
      idGroupe: data['idGroupe'],
      idParent: data['idParent'],
      idSpecialiste: data['idSpecialiste'],
    );
  }
}
