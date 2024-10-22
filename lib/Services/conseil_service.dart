import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:accessability/Modele/conseil_modele.dart'; // Assurez-vous que le chemin est correct

class ConseilService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ajouter un conseil
  Future<void> addConseil(Conseil conseil) async {
    try {
      await _firestore.collection('conseils').doc(conseil.id).set(conseil.toFirestore());
    } catch (e) {
      throw Exception('Erreur lors de l\'ajout du conseil : $e');
    }
  }

  // Récupérer des conseils par idParent
  Future<List<Conseil>> getConseilsByParent(String idParent) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('conseils')
          .where('idParent', isEqualTo: idParent)
          .get();

      return snapshot.docs.map((doc) => Conseil.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des conseils : $e');
    }
  }

  // Récupérer des conseils par idSpecialiste
  Future<List<Conseil>> getConseilsBySpecialiste(String idSpecialiste) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('conseils')
          .where('idSpecialiste', isEqualTo: idSpecialiste)
          .get();

      return snapshot.docs.map((doc) => Conseil.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des conseils : $e');
    }
  }

  // Récupérer des conseils par idEnfant
  Future<List<Conseil>> getConseilsByEnfant(String idEnfant) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('conseils')
          .where('idEnfant', isEqualTo: idEnfant) // Filtrage par idEnfant
          .get();

      return snapshot.docs.map((doc) => Conseil.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des conseils : $e');
    }
  }

  // Récupérer tous les conseils (optionnel)
  Future<List<Conseil>> getAllConseils() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('conseils').get();
      return snapshot.docs.map((doc) => Conseil.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération de tous les conseils : $e');
    }
  }
}
