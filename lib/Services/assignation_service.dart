import 'package:accessability/Modele/assignation_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


class AssignationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _assignations = FirebaseFirestore.instance.collection('assignations');

  // Créer une assignation
  Future<void> faireAssignation(String idEnfant, String idSpecialiste) async {
    try {
      String id = _firestore.collection('assignations').doc().id; // Génération automatique de l'ID
      DateTime dateAssignation = DateTime.now();

      Assignation assignation = Assignation(
        id: id,
        idEnfant: idEnfant,
        idSpecialiste: idSpecialiste,
        dateAssignation: dateAssignation,
      );

      await _assignations.doc(id).set(assignation.toFirestore());
      if (kDebugMode) {
        print('Assignation créée avec succès.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la création de l\'assignation : $e');
      }
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  // Annuler une assignation
  Future<void> annulerAssignation(String idAssignation) async {
    try {
      await _assignations.doc(idAssignation).delete();
      if (kDebugMode) {
        print('Assignation annulée avec succès.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'annulation de l\'assignation : $e');
      }
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  // Récupérer toutes les assignations pour un enfant
  Future<List<Assignation>> getAssignationsByEnfant(String idEnfant) async {
    try {
      QuerySnapshot snapshot = await _assignations.where('idEnfant', isEqualTo: idEnfant).get();
      return snapshot.docs.map((doc) => Assignation.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des assignations : $e');
      }
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }

  // Récupérer toutes les assignations pour un spécialiste
  Future<List<Assignation>> getAssignationsBySpecialiste(String idSpecialiste) async {
    try {
      QuerySnapshot snapshot = await _assignations.where('idSpecialiste', isEqualTo: idSpecialiste).get();
      return snapshot.docs.map((doc) => Assignation.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des assignations : $e');
      }
      // ignore: use_rethrow_when_possible
      throw e;
    }
  }
}
