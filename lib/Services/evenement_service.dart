import 'package:accessability/Modele/evenement_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EvenementService {
  final CollectionReference evenementCollection = FirebaseFirestore.instance.collection('evenements');

  // Créer un nouvel événement avec un ID généré automatiquement
  Future<void> createEvenement(Evenement evenement) async {
    try {
      // Utilisation de 'add' pour créer un document avec un ID généré automatiquement
      DocumentReference docRef = await evenementCollection.add(evenement.toFirestore());
      // Mettre à jour l'événement avec l'ID généré par Firestore
      await docRef.update({'id': docRef.id}); // Mise à jour de l'ID dans Firestore
      evenement.id = docRef.id; // Assurez-vous que votre modèle Evenement a un setter pour id
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'événement : $e');
    }
  }

  // Mettre à jour un événement existant
  Future<void> updateEvenement(Evenement evenement) async {
    try {
      if (evenement.id.isNotEmpty) {
        await evenementCollection.doc(evenement.id).update(evenement.toFirestore());
      } else {
        throw Exception('L\'ID de l\'événement est vide. Impossible de mettre à jour.');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'événement : $e');
    }
  }

  // Supprimer un événement
  Future<void> deleteEvenement(String id) async {
    try {
      await evenementCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'événement : $e');
    }
  }

  // Récupérer tous les événements d'un administrateur spécifique
  Future<List<Evenement>> getEvenementsByAdmin(String adminId) async {
    try {
      QuerySnapshot querySnapshot = await evenementCollection.where('adminId', isEqualTo: adminId).get();
      return querySnapshot.docs
          .map((doc) => Evenement.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des événements pour l\'administrateur : $e');
    }
  }

  // Récupérer tous les événements associés à un parent spécifique
  Future<List<Evenement>> getEvenementsByParent(String parentId) async {
    try {
      QuerySnapshot querySnapshot = await evenementCollection.where('parentId', isEqualTo: parentId).get();
      return querySnapshot.docs
          .map((doc) => Evenement.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des événements pour le parent : $e');
    }
  }

  // Récupérer un événement par ID
  Future<Evenement?> getEvenementById(String id) async {
    try {
      DocumentSnapshot doc = await evenementCollection.doc(id).get();
      if (doc.exists) {
        return Evenement.fromFirestore(doc.data() as Map<String, dynamic>);
      } else {
        return null; // Retourne null si l'événement n'existe pas
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'événement : $e');
    }
  }

  // Récupérer tous les événements
  Future<List<Evenement>> getEvenements() async {
    try {
      QuerySnapshot querySnapshot = await evenementCollection.get();
      return querySnapshot.docs
          .map((doc) => Evenement.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération de tous les événements : $e');
    }
  }
}
