class ConcernerPar {
  final String idEnfant;
  final String idRdv;

  ConcernerPar({
    required this.idEnfant,
    required this.idRdv,
  });

  // Convertir en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'idEnfant': idEnfant,
      'idRdv': idRdv,
    };
  }

  // Créer depuis Firestore
  factory ConcernerPar.fromFirestore(Map<String, dynamic> data) {
    return ConcernerPar(
      idEnfant: data['idEnfant'],
      idRdv: data['idRdv'],
    );
  }
}
