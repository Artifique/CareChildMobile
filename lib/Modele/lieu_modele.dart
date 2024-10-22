class Lieu {
  String id;
  String nom;
  String adresse;
  String accessibilite;

  Lieu({required this.id, required this.nom, required this.adresse, required this.accessibilite});

  factory Lieu.fromFirestore(Map<String, dynamic> data, String id) {
    return Lieu(
      id: id,
      nom: data['nom'] ?? '',
      adresse: data['adresse'] ?? '',
      accessibilite: data['accessibilite'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
      'adresse': adresse,
      'accessibilite': accessibilite,
    };
  }
}