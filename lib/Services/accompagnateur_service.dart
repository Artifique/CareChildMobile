import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:accessability/Modele/accompagnateur_modele.dart';
import 'package:flutter/foundation.dart';

class AccompagnateurService {
  final CollectionReference accompagnateurCollection = FirebaseFirestore.instance.collection('accompagnateurs');

  // Ajouter un nouvel accompagnateur
  Future<void> addAccompagnateur(Accompagnateur accompagnateur) async {
    try {
      await accompagnateurCollection.doc(accompagnateur.id).set(accompagnateur.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'ajout de l\'accompagnateur : $e');
      }
    }
  }

  // Récupérer un accompagnateur par son ID
  Future<Accompagnateur?> getAccompagnateurById(String id) async {
    try {
      DocumentSnapshot doc = await accompagnateurCollection.doc(id).get();
      if (doc.exists) {
        return Accompagnateur.fromFirestore(doc.data() as Map<String, dynamic>);
      } else {
        if (kDebugMode) {
          print('Accompagnateur non trouvé');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération de l\'accompagnateur : $e');
      }
      return null;
    }
  }

  // Mettre à jour un accompagnateur
  Future<void> updateAccompagnateur(Accompagnateur accompagnateur) async {
    try {
      await accompagnateurCollection.doc(accompagnateur.id).update(accompagnateur.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour de l\'accompagnateur : $e');
      }
    }
  }

  // Supprimer un accompagnateur
  Future<void> deleteAccompagnateur(String id) async {
    try {
      await accompagnateurCollection.doc(id).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la suppression de l\'accompagnateur : $e');
      }
    }
  }

  // Récupérer tous les accompagnateurs
  Future<List<Accompagnateur>> getAllAccompagnateurs() async {
    try {
      QuerySnapshot querySnapshot = await accompagnateurCollection.get();
      return querySnapshot.docs
          .map((doc) => Accompagnateur.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des accompagnateurs : $e');
      }
      return [];
    }
  }
}
