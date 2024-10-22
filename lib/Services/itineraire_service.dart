import 'package:accessability/Modele/itineraire_modele.dart';
import 'package:accessability/Modele/trajet_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class ItineraireService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'itineraires';

  // Créer un nouvel itinéraire avec plusieurs trajets
  Future<void> createItineraire(Itineraire itineraire) async {
    try {
      List<Map<String, dynamic>> trajetsData = itineraire.trajets.map((trajet) {
        return {
          'depart': trajet.depart,
          'arrivee': trajet.arrivee,
          'distance': trajet.distance,
          'prix': trajet.prix,
          'coordonneesDepart': trajet.coordonneesDepart,
          'coordonneesArrivee': trajet.coordonneesArrivee,
        };
      }).toList();

      await _firestore.collection(collectionName).add({
        'trajets': trajetsData,
      });
      if (kDebugMode) {
        print("Itinéraire créé avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la création de l'itinéraire : $e");
      }
    }
  }

  // Récupérer un itinéraire par son ID
  Future<Itineraire?> getItineraireById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collectionName).doc(id).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        List<Trajet> trajets = (data['trajets'] as List).map((trajetData) {
          return Trajet(
            depart: trajetData['depart'] ?? '',
            arrivee: trajetData['arrivee'] ?? '',
            distance: trajetData['distance']?.toDouble() ?? 0.0,
            prix: trajetData['prix']?.toDouble() ?? 0.0,
            coordonneesDepart: trajetData['coordonneesDepart'],
            coordonneesArrivee: trajetData['coordonneesArrivee'],
          );
        }).toList();

        return Itineraire(trajets: trajets);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération de l'itinéraire : $e");
      }
      return null;
    }
  }

  // Mettre à jour un itinéraire
  Future<void> updateItineraire(String id, Itineraire itineraire) async {
    try {
      List<Map<String, dynamic>> trajetsData = itineraire.trajets.map((trajet) {
        return {
          'depart': trajet.depart,
          'arrivee': trajet.arrivee,
          'distance': trajet.distance,
          'prix': trajet.prix,
          'coordonneesDepart': trajet.coordonneesDepart,
          'coordonneesArrivee': trajet.coordonneesArrivee,
        };
      }).toList();

      await _firestore.collection(collectionName).doc(id).update({
        'trajets': trajetsData,
      });
      if (kDebugMode) {
        print("Itinéraire mis à jour avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la mise à jour de l'itinéraire : $e");
      }
    }
  }

  // Supprimer un itinéraire
  Future<void> deleteItineraire(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
      if (kDebugMode) {
        print("Itinéraire supprimé avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la suppression de l'itinéraire : $e");
      }
    }
  }
}
