import 'package:accessability/Modele/trajet_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class TrajetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'trajets';

  // Créer un nouveau trajet et l'enregistrer dans Firestore
  Future<void> createTrajet(Trajet trajet) async {
    try {
      DocumentReference docRef = await _firestore.collection(collectionName).add({
        'depart': trajet.depart,
        'arrivee': trajet.arrivee,
        'distance': trajet.distance,
        'prix': trajet.prix,
        'coordonneesDepart': trajet.coordonneesDepart,
        'coordonneesArrivee': trajet.coordonneesArrivee,
      });
      if (kDebugMode) {
        print("Trajet créé avec succès : ${docRef.id}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la création du trajet : $e");
      }
    }
  }

  // Récupérer un trajet par son ID
  Future<Trajet?> getTrajetById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collectionName).doc(id).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        return Trajet(
          depart: data['depart'],
          arrivee: data['arrivee'],
          distance: data['distance'],
          prix: data['prix'],
          coordonneesDepart: data['coordonneesDepart'],
          coordonneesArrivee: data['coordonneesArrivee'],
        );
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération du trajet : $e");
      }
      return null;
    }
  }

  // Récupérer tous les trajets
  Future<List<Trajet>> getAllTrajets() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(collectionName).get();
      return querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return Trajet(
          depart: data['depart'],
          arrivee: data['arrivee'],
          distance: data['distance'],
          prix: data['prix'],
          coordonneesDepart: data['coordonneesDepart'],
          coordonneesArrivee: data['coordonneesArrivee'],
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération des trajets : $e");
      }
      return [];
    }
  }

  // Mettre à jour un trajet
  Future<void> updateTrajet(String id, Trajet trajet) async {
    try {
      await _firestore.collection(collectionName).doc(id).update({
        'depart': trajet.depart,
        'arrivee': trajet.arrivee,
        'distance': trajet.distance,
        'prix': trajet.prix,
        'coordonneesDepart': trajet.coordonneesDepart,
        'coordonneesArrivee': trajet.coordonneesArrivee,
      });
      if (kDebugMode) {
        print("Trajet mis à jour avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la mise à jour du trajet : $e");
      }
    }
  }

  // Supprimer un trajet
  Future<void> deleteTrajet(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
      if (kDebugMode) {
        print("Trajet supprimé avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la suppression du trajet : $e");
      }
    }
  }
}
