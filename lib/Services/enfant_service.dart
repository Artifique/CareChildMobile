import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:accessability/Modele/enfant_modele.dart';
import 'package:flutter/foundation.dart';

class EnfantService {
  final CollectionReference enfantsCollection =
      FirebaseFirestore.instance.collection('enfants');

  // Créer un enfant
  Future<void> creerEnfant(Enfant enfant) async {
    try {
      // Créer une nouvelle référence de document pour générer un ID automatiquement
      DocumentReference docRef = await enfantsCollection.add(enfant.toFirestore());
      if (kDebugMode) {
        print('Enfant créé avec succès : ${docRef.id}');
      }

      // Mettre à jour l'ID de l'enfant avec celui généré
      await enfantsCollection.doc(docRef.id).update({'id': docRef.id});
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la création de l\'enfant: $e');
      }
    }
  }

  // Lire un enfant
  Future<Enfant?> getEnfantById(String id) async {
    try {
      DocumentSnapshot doc = await enfantsCollection.doc(id).get();
      if (doc.exists) {
        return Enfant.fromFirestore(doc.data() as Map<String, dynamic>);
      } else {
        if (kDebugMode) {
          print('Enfant non trouvé');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération de l\'enfant: $e');
      }
      return null;
    }
  }

  // Mettre à jour un enfant
  Future<void> updateEnfant(Enfant enfant) async {
    try {
      await enfantsCollection.doc(enfant.id).update(enfant.toFirestore());
      if (kDebugMode) {
        print('Enfant mis à jour avec succès');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour de l\'enfant: $e');
      }
    }
  }

  // Supprimer un enfant
  Future<void> supprimerEnfant(String id) async {
    try {
      await enfantsCollection.doc(id).delete();
      if (kDebugMode) {
        print('Enfant supprimé avec succès');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la suppression de l\'enfant: $e');
      }
    }
  }

  // Récupérer tous les enfants
  Future<List<Enfant>> getEnfants() async {
    try {
      QuerySnapshot querySnapshot = await enfantsCollection.get();
      return querySnapshot.docs
          .map((doc) => Enfant.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des enfants: $e');
      }
      return [];
    }
  }

  // Mettre à jour le type de handicap d'un enfant
  Future<void> updateTypeHandicap(String enfantId, String typeHandicap) async {
    try {
      await enfantsCollection.doc(enfantId).update({
        'typeHandicap': typeHandicap,
      });
      if (kDebugMode) {
        print('Type de handicap mis à jour avec succès');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour du type de handicap: $e');
      }
    }
  }

// Récupérer les enfants d'un parent spécifique
Future<List<Enfant>> getEnfantsByParentId(String parentId) async {
  try {
    QuerySnapshot querySnapshot = await enfantsCollection
        .where('parentId', isEqualTo: parentId) // Filtrer par parentId
        .get();
    
    return querySnapshot.docs
        .map((doc) => Enfant.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList();
  } catch (e) {
    if (kDebugMode) {
      print('Erreur lors de la récupération des enfants par ID du parent: $e');
    }
    return [];
  }
}

}