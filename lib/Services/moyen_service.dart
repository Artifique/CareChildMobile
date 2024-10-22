import 'package:accessability/Modele/moyen_transport_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class MoyenDeTransportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'moyensDeTransport';

  // Créer un nouveau moyen de transport
  Future<void> createMoyenDeTransport(MoyenDeTransport moyen) async {
    try {
      await _firestore.collection(collectionName).add({
        'type': moyen.type,
        'prixParKm': moyen.prixParKm,
      });
      if (kDebugMode) {
        print("Moyen de transport créé avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la création du moyen de transport : $e");
      }
    }
  }

  // Récupérer un moyen de transport par son ID
  Future<MoyenDeTransport?> getMoyenDeTransportById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collectionName).doc(id).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        return MoyenDeTransport.fromFirestore(data, doc.id);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération du moyen de transport : $e");
      }
      return null;
    }
  }

  // Mettre à jour un moyen de transport
  Future<void> updateMoyenDeTransport(String id, MoyenDeTransport moyen) async {
    try {
      await _firestore.collection(collectionName).doc(id).update({
        'type': moyen.type,
        'prixParKm': moyen.prixParKm,
      });
      if (kDebugMode) {
        print("Moyen de transport mis à jour avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la mise à jour du moyen de transport : $e");
      }
    }
  }

  // Supprimer un moyen de transport
  Future<void> deleteMoyenDeTransport(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
      if (kDebugMode) {
        print("Moyen de transport supprimé avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la suppression du moyen de transport : $e");
      }
    }
  }

  // Récupérer tous les moyens de transport
  Future<List<MoyenDeTransport>> getAllMoyensDeTransport() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection(collectionName).get();
      return snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        return MoyenDeTransport.fromFirestore(data, doc.id);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération des moyens de transport : $e");
      }
      return [];
    }
  }
}
