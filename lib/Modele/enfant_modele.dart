class Enfant {
  String id; // Identifiant unique de l'enfant
  String nom; // Nom de l'enfant
  String age; // Âge de l'enfant
  String parentId; // Identifiant du parent
  String typeHandicap; // Type de handicap (ex : "sourd", "autiste")
  String diagnostic; // Diagnostic médical (ex : "autisme", "déficience auditive")
  List<String> besoinsEducatifs; // Liste des besoins éducatifs spécifiques
  String observationComportementale; // Observations récentes sur le comportement

  Enfant({
    required this.id,
    required this.nom,
    required this.age,
    required this.parentId,
    required this.typeHandicap,
    this.diagnostic = '', // Valeur par défaut si non spécifié
    this.besoinsEducatifs = const [], // Liste vide par défaut
    this.observationComportementale = '', // Vide par défaut
  });

  // Méthode pour copier l'objet en modifiant certains champs
  Enfant copyWith({
    String? id,
    String? nom,
    String? age,
    String? parentId,
    String? typeHandicap,
    String? diagnostic,
    List<String>? besoinsEducatifs,
    String? observationComportementale,
  }) {
    return Enfant(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      age: age ?? this.age,
      parentId: parentId ?? this.parentId,
      typeHandicap: typeHandicap ?? this.typeHandicap,
      diagnostic: diagnostic ?? this.diagnostic,
      besoinsEducatifs: besoinsEducatifs ?? this.besoinsEducatifs,
      observationComportementale: observationComportementale ?? this.observationComportementale,
    );
  }

  factory Enfant.fromFirestore(Map<String, dynamic> json) {
    return Enfant(
      id: json['id'],
      nom: json['nom'],
      age: json['age'],
      parentId: json['parentId'],
      typeHandicap: json['typeHandicap'] ?? '',
      diagnostic: json['diagnostic'] ?? '',
      besoinsEducatifs: List<String>.from(json['besoinsEducatifs'] ?? []),
      observationComportementale: json['observationComportementale'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'nom': nom,
      'age': age,
      'parentId': parentId,
      'typeHandicap': typeHandicap,
      'diagnostic': diagnostic,
      'besoinsEducatifs': besoinsEducatifs,
      'observationComportementale': observationComportementale,
    };
  }
}