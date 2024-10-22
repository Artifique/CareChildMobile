import 'package:accessability/Modele/creneau_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DisponibiliteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Créer une disponibilité
  Future<void> creerDisponibilite(Disponibilite disponibilite) async {
    await _firestore.collection('disponibilites').doc(disponibilite.id).set(disponibilite.toFirestore());
  }

  // Lire une disponibilité par ID
  Future<Disponibilite?> lireDisponibilite(String id) async {
    DocumentSnapshot doc = await _firestore.collection('disponibilites').doc(id).get();
    if (doc.exists) {
      return Disponibilite.fromFirestore(doc.data() as Map<String, dynamic>);
    }
    return null; // Retourne null si la disponibilité n'existe pas
  }

  // Modifier une disponibilité
  Future<void> modifierDisponibilite(Disponibilite disponibilite) async {
    await _firestore.collection('disponibilites').doc(disponibilite.id).update(disponibilite.toFirestore());
  }

  // Supprimer une disponibilité
  Future<void> supprimerDisponibilite(String id) async {
    await _firestore.collection('disponibilites').doc(id).delete();
  }

  // Récupérer toutes les disponibilités d'un spécialiste
  Future<List<Disponibilite>> recupererDisponibilitesParSpecialiste(String specialisteId) async {
    QuerySnapshot snapshot = await _firestore.collection('disponibilites')
        .where('specialisteId', isEqualTo: specialisteId)
        .get();

    return snapshot.docs.map((doc) => Disponibilite.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
  }

  // Récupérer les disponibilités par jour
  Future<List<Disponibilite>> recupererDisponibilitesParJour(String specialisteId, String jour) async {
    QuerySnapshot snapshot = await _firestore.collection('disponibilites')
        .where('specialisteId', isEqualTo: specialisteId)
        .where('joursDisponibilite', arrayContains: jour) // Filtrer par jour de disponibilité
        .get();

    return snapshot.docs.map((doc) => Disponibilite.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
  }

  // Vérifier la disponibilité à une date et heure spécifiques
  bool estDisponible(DateTime date, int heure, List<Disponibilite> disponibilites) {
    DateTime timeSlotStart = DateTime(date.year, date.month, date.day, heure);
    DateTime timeSlotEnd = timeSlotStart.add(const Duration(hours: 1));

    return disponibilites.any((dispo) {
      // Vérifier si la date est dans les jours de disponibilité
      if (!dispo.joursDisponibilite.contains(date.toIso8601String().split('T').first)) {
        return false; // La date n'est pas dans les jours disponibles
      }
      
      // Convertir les heures de début et de fin en DateTime
      DateTime start = DateTime.parse('${dispo.joursDisponibilite.first} ${dispo.heureDebut}');
      DateTime end = DateTime.parse('${dispo.joursDisponibilite.first} ${dispo.heureFin}');
      return timeSlotStart.isAfter(start) && timeSlotEnd.isBefore(end) && dispo.disponibilite;
    });
  }
}