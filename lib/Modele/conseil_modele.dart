class Conseil {
  final String id;
  final String idParent;
  final String idSpecialiste;
  final String idEnfant; 
  final String contenu;
  final DateTime dateConseil;

  Conseil({
    required this.id,
    required this.idParent,
    required this.idSpecialiste,
    required this.idEnfant, 
    required this.contenu,
    required this.dateConseil,
  });

  // Convertir en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'idParent': idParent,
      'idSpecialiste': idSpecialiste,
      'idEnfant': idEnfant, 
      'contenu': contenu,
      'dateConseil': dateConseil.toIso8601String(),
    };
  }

  // Créer depuis Firestore
  factory Conseil.fromFirestore(Map<String, dynamic> data) {
    return Conseil(
      id: data['id'],
      idParent: data['idParent'],
      idSpecialiste: data['idSpecialiste'],
      idEnfant: data['idEnfant'], 
      contenu: data['contenu'],
      dateConseil: DateTime.parse(data['dateConseil']),
    );
  }
}
