class Evenement {
  String id; // L'ID peut être une valeur vide au départ
  final String titre;
  final String description;
  final DateTime dateDebut; 
  final DateTime dateFin;
  final String parentId;
  final String adminId;
  final DateTime heure; 

  Evenement({
    this.id = '', // Valeur par défaut vide
    required this.titre,
    required this.description,
    required this.dateDebut,
    required this.dateFin,
    required this.parentId,
    required this.adminId,
    required this.heure,
  });

  // Méthode pour convertir l'événement en Map pour Firestore
  Map<String, dynamic> toFirestore() {
    return {
      // Ne pas inclure 'id' ici car Firestore le génère automatiquement
      'titre': titre,
      'description': description,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'parentId': parentId,
      'adminId': adminId,
      'heure': heure.toIso8601String(),
    };
  }

  // Méthode copyWith
  Evenement copyWith({
    String? id,
    String? titre,
    String? description,
    DateTime? dateDebut,
    DateTime? dateFin,
    String? parentId,
    String? adminId,
    DateTime? heure,
  }) {
    return Evenement(
      id: id ?? this.id,
      titre: titre ?? this.titre,
      description: description ?? this.description,
      dateDebut: dateDebut ?? this.dateDebut,
      dateFin: dateFin ?? this.dateFin,
      parentId: parentId ?? this.parentId,
      adminId: adminId ?? this.adminId,
      heure: heure ?? this.heure,
    );
  }

  // Méthode pour créer un événement à partir de Firestore
  factory Evenement.fromFirestore(Map<String, dynamic> data) {
    return Evenement(
      id: data['id'] ?? '', // Assurez-vous que cela soit correct
      titre: data['titre'] ?? '',
      description: data['description'] ?? '',
      dateDebut: DateTime.parse(data['dateDebut']),
      dateFin: DateTime.parse(data['dateFin']),
      parentId: data['parentId'] ?? 'RIEN',
      adminId: data['adminId'] ?? '',
      heure: DateTime.parse(data['heure']),
    );
  }
}
