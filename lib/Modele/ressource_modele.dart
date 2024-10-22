class Ressource {
  String idRessource;     // Identifiant unique de la ressource
  String titre;           // Titre de la ressource
  String type;     // type de la ressource
  String url;           // URL ou chemin vers le fichier audio
  String transcriptionTexte; // Texte de la transcription de l'audio
  String imageRepresentation; // URL ou chemin vers l'image représentative
  String idSpecialiste;   // Référence au Spécialiste qui a créé la ressource

  // Constructeur
  Ressource({
    required this.idRessource,
    required this.titre,
    required this.type,
    required this.url,
    required this.transcriptionTexte,
    required this.imageRepresentation,
    required this.idSpecialiste, // Remplacer idAdmin par idSpecialiste
  });

  // Méthode pour convertir l'objet en JSON pour stockage dans Firebase
  Map<String, dynamic> toJson() {
    return {
      'idRessource': idRessource,
      'titre': titre,
      'type': type,
      'url': url,
      'transcriptionTexte': transcriptionTexte,
      'imageRepresentation': imageRepresentation,
      'idSpecialiste': idSpecialiste, // Remplacer idAdmin par idSpecialiste
    };
  }

  // Méthode pour créer un objet Ressource à partir de données JSON
  factory Ressource.fromJson(Map<String, dynamic> json) {
    return Ressource(
      idRessource: json['idRessource'],
      titre: json['titre'],
      type: json['type'],
      url: json['url'],
      transcriptionTexte: json['transcriptionTexte'],
      imageRepresentation: json['imageRepresentation'],
      idSpecialiste: json['idSpecialiste'], // Remplacer idAdmin par idSpecialiste
    );
  }
}
