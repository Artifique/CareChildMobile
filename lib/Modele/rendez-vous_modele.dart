class RendezVousM {
  late final String idRendezVousM;
  final String date;  // Utilisation de String pour la date au format yyyy-MM-dd
  final String heure;  // Utilisation de String pour l'heure unique au format HH:mm
  final String status; // Statut du rendez-vous
  final String idSpecialiste; // ID du spécialiste
  final String idParent;
  final String motif;
  final String idEnfant; // Nouveau champ pour l'id de l'enfant

  // Modifiez le constructeur pour donner une valeur par défaut à status
  RendezVousM({
    required this.idRendezVousM,
    required this.date,  // La date sera une chaîne (ex: "2024-10-12")
    required this.heure,  // L'heure sera une chaîne (ex: "09:00")
    String? status,  // Rendre status optionnel
    required this.idSpecialiste,
    required this.idParent,
    required this.motif,
    required this.idEnfant, // Ajouter idEnfant comme champ requis
  }) : status = status ?? 'en attente'; // Assigner une valeur par défaut

  // Convertir un rendez-vous en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'idRendezVousM': idRendezVousM,
      'date': date,  // Conserver la date en chaîne
      'heure': heure,  // Conserver l'heure au format HH:mm
      'status': status,
      'idSpecialiste': idSpecialiste,
      'idParent': idParent,
      'motif': motif,
      'idEnfant': idEnfant, // Ajouter le champ idEnfant ici
    };
  }

  // Créer un rendez-vous depuis Firestore
  factory RendezVousM.fromFirestore(Map<String, dynamic> data, String idRendezVousM) {
    return RendezVousM(
      idRendezVousM: idRendezVousM,
      date: data['date'],  // La date est stockée comme chaîne
      heure: data['heure'],  // L'heure est une chaîne au format HH:mm
      status: data['status'],
      idSpecialiste: data['idSpecialiste'],
      idParent: data['idParent'],
      motif: data['motif'],
      idEnfant: data['idEnfant'], // Récupérer le champ idEnfant
    );
  }
}