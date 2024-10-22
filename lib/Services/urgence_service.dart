import 'package:accessability/Modele/service_urgence_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ServiceUrgenceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'servicesUrgence';

  // Créer un nouveau service d'urgence
  Future<void> createServiceUrgence(ServiceUrgence service) async {
    try {
      await _firestore.collection(collectionName).add({
        'nom': service.nom,
        'numero': service.numero,
      });
      if (kDebugMode) {
        print("Service d'urgence créé avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la création du service d'urgence : $e");
      }
    }
  }

  // Récupérer un service d'urgence par son ID
  Future<ServiceUrgence?> getServiceUrgenceById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collectionName).doc(id).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        return ServiceUrgence.fromFirestore(data, doc.id);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération du service d'urgence : $e");
      }
      return null;
    }
  }

  // Mettre à jour un service d'urgence
  Future<void> updateServiceUrgence(String id, ServiceUrgence service) async {
    try {
      await _firestore.collection(collectionName).doc(id).update({
        'nom': service.nom,
        'numero': service.numero,
      });
      if (kDebugMode) {
        print("Service d'urgence mis à jour avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la mise à jour du service d'urgence : $e");
      }
    }
  }

  // Supprimer un service d'urgence
  Future<void> deleteServiceUrgence(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
      if (kDebugMode) {
        print("Service d'urgence supprimé avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la suppression du service d'urgence : $e");
      }
    }
  }

  // Récupérer tous les services d'urgence
  Future<List<ServiceUrgence>> getAllServicesUrgence() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(collectionName).get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return ServiceUrgence.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération des services d'urgence : $e");
      }
      return [];
    }
  }
}
