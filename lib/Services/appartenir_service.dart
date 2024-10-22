import 'package:accessability/Modele/appartenir_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AppartenirService {
  final CollectionReference appartenirCollection = FirebaseFirestore.instance.collection('appartenir');

  // Créer un nouvel enregistrement d'appartenance
  Future<void> createAppartenir(Appartenir appartenir) async {
    try {
      await appartenirCollection.doc(appartenir.id).set(appartenir.toFirestore());
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'appartenance : $e');
    }
  }

  // Mettre à jour un enregistrement d'appartenance existant
  Future<void> updateAppartenir(Appartenir appartenir) async {
    try {
      await appartenirCollection.doc(appartenir.id).update(appartenir.toFirestore());
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'appartenance : $e');
    }
  }

  // Supprimer un enregistrement d'appartenance
  Future<void> deleteAppartenir(String id) async {
    try {
      await appartenirCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'appartenance : $e');
    }
  }

  // Récupérer tous les enregistrements d'appartenance
  Future<List<Appartenir>> getAllAppartenir() async {
    try {
      QuerySnapshot querySnapshot = await appartenirCollection.get();
      return querySnapshot.docs.map((doc) => Appartenir.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des appartenances : $e');
    }
  }

  // Récupérer un enregistrement d'appartenance par ID
  Future<Appartenir> getAppartenirById(String id) async {
    try {
      DocumentSnapshot doc = await appartenirCollection.doc(id).get();
      return Appartenir.fromFirestore(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'appartenance : $e');
    }
  }
}
