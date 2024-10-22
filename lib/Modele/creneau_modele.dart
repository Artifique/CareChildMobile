class Disponibilite {
  final String id; // Identifiant unique pour chaque disponibilité
  final String specialisteId; // ID du spécialiste associé
  final List<String> joursDisponibilite; // Jours disponibles, sous forme de date
  final String heureDebut; // Heure de début de la disponibilité au format HH:mm
  final String heureFin; // Heure de fin de la disponibilité au format HH:mm
  final bool disponibilite; // Indique si le créneau est disponible
  final String commentaire; // Commentaire optionnel sur la disponibilité
  final int nombreConsultationsMax; // Nombre maximum de consultations par jour

  Disponibilite({
    required this.id,
    required this.specialisteId,
    required this.joursDisponibilite,
    required this.heureDebut,
    required this.heureFin,
    required this.disponibilite,
    required this.commentaire,
    required this.nombreConsultationsMax,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'specialisteId': specialisteId,
      'joursDisponibilite': joursDisponibilite,
      'heureDebut': heureDebut,
      'heureFin': heureFin,
      'disponibilite': disponibilite,
      'commentaire': commentaire,
      'nombreConsultationsMax': nombreConsultationsMax,
    };
  }

  factory Disponibilite.fromFirestore(Map<String, dynamic> data) {
    return Disponibilite(
      id: data['id'],
      specialisteId: data['specialisteId'],
      joursDisponibilite: List<String>.from(data['joursDisponibilite']),
      heureDebut: data['heureDebut'],
      heureFin: data['heureFin'],
      disponibilite: data['disponibilite'],
      commentaire: data['commentaire'],
      nombreConsultationsMax: data['nombreConsultationsMax'],
    );
  }

  // Fonction pour convertir les joursDisponibilite en DateTime
  List<DateTime> getDisponibilitesAsDates() {
    return joursDisponibilite.map((jour) => DateTime.parse(jour)).toList();
  }

  // Vérifie si une heure donnée est disponible
  bool estDisponible(DateTime date, int heure) {
    DateTime debut = DateTime(date.year, date.month, date.day, int.parse(heureDebut.split(':')[0]), int.parse(heureDebut.split(':')[1]));
    DateTime fin = DateTime(date.year, date.month, date.day, int.parse(heureFin.split(':')[0]), int.parse(heureFin.split(':')[1]));

    // Vérifier si l'heure est comprise entre l'heure de début et de fin
    return date.isAfter(debut) && date.isBefore(fin) && disponibilite;
  }
}