class DemandeAdhesion {
  final String demandeurId;
  String statut; // 'en attente', 'accepté', 'refusé'

  DemandeAdhesion({
    required this.demandeurId,
    this.statut = 'en attente', // Statut par défaut
  });

  // Convertir en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'demandeurId': demandeurId,
      'statut': statut,
    };
  }

  // Créer depuis Firestore
  factory DemandeAdhesion.fromFirestore(Map<String, dynamic> data) {
    return DemandeAdhesion(
      demandeurId: data['demandeurId'],
      statut: data['statut'],
    );
  }
}