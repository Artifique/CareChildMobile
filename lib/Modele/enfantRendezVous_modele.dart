class EnfantRendezVous {
  final String idEnfant;
  final String idRendezVous;

  EnfantRendezVous({
    required this.idEnfant,
    required this.idRendezVous,
  });

  // Convertir en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'idEnfant': idEnfant,
      'idRendezVous': idRendezVous,
    };
  }

  // Créer depuis Firestore
  factory EnfantRendezVous.fromFirestore(Map<String, dynamic> data) {
    return EnfantRendezVous(
      idEnfant: data['idEnfant'],
      idRendezVous: data['idRendezVous'],
    );
  }
}
