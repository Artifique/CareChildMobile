class Favoris {
  final String idParent;
  final String idRessource;

  Favoris({
    required this.idParent,
    required this.idRessource,
  });

  // Convertir en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'idParent': idParent,
      'idRessource': idRessource,
    };
  }

  // Créer depuis Firestore
  factory Favoris.fromFirestore(Map<String, dynamic> data) {
    return Favoris(
      idParent: data['idParent'],
      idRessource: data['idRessource'],
    );
  }
}
