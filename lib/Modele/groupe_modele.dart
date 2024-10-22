import 'package:accessability/Modele/demande_modele.dart';

class GroupeDiscussion {
  late final String idGroupe;
  final String nom;
  final String createurId; // ID du créateur du groupe
  List<String> participantsIds; // Liste des ID des participants
  List<DemandeAdhesion> demandesAdhesion; // Liste des demandes d'adhésion

  GroupeDiscussion({
    required this.idGroupe,
    required this.nom,
    required this.createurId, // Initialisation du créateur
    this.participantsIds = const [], // Initialisation par défaut
    this.demandesAdhesion = const [], // Initialisation par défaut
  });

  // Convertir en format Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'idGroupe': idGroupe,
      'nom': nom,
      'createurId': createurId, // Ajout de l'ID du créateur
      'participantsIds': participantsIds, // Ajout des participants
      'demandesAdhesion': demandesAdhesion.map((d) => d.toFirestore()).toList(), // Convertir les demandes
    };
  }

  // Créer depuis Firestore
  factory GroupeDiscussion.fromFirestore(Map<String, dynamic> data, String idGroupe) {
    return GroupeDiscussion(
      idGroupe: idGroupe,
      nom: data['nom'],
      createurId: data['createurId'], // Récupérer l'ID du créateur depuis Firestore
      participantsIds: List<String>.from(data['participantsIds'] ?? []), // Récupérer les participants depuis Firestore
      demandesAdhesion: (data['demandesAdhesion'] as List<dynamic>?)?.map((d) => DemandeAdhesion.fromFirestore(d)).toList() ?? [], // Récupérer les demandes d'adhésion
    );
  }
}