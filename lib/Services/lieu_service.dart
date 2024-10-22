import 'package:accessability/Modele/lieu_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class LieuService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'lieux';

  // Créer un nouveau lieu et l'enregistrer dans Firestore
  Future<void> createLieu(Lieu lieu) async {
    try {
      DocumentReference docRef = await _firestore.collection(collectionName).add(lieu.toFirestore());
      if (kDebugMode) {
        print("Lieu créé avec succès : ${docRef.id}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la création du lieu : $e");
      }
    }
  }

  // Récupérer un lieu par son ID
  Future<Lieu?> getLieuById(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collectionName).doc(id).get();
      if (doc.exists) {
        return Lieu.fromFirestore(doc.data() as Map<String, dynamic>, id);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération du lieu : $e");
      }
      return null;
    }
  }

  // Récupérer tous les lieux
  Future<List<Lieu>> getAllLieux() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection(collectionName).get();
      return querySnapshot.docs.map((doc) {
        return Lieu.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération des lieux : $e");
      }
      return [];
    }
  }

  // Mettre à jour un lieu
  Future<void> updateLieu(String id, Lieu lieu) async {
    try {
      await _firestore.collection(collectionName).doc(id).update(lieu.toFirestore());
      if (kDebugMode) {
        print("Lieu mis à jour avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la mise à jour du lieu : $e");
      }
    }
  }

  // Supprimer un lieu
  Future<void> deleteLieu(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
      if (kDebugMode) {
        print("Lieu supprimé avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la suppression du lieu : $e");
      }
    }
  }
}
