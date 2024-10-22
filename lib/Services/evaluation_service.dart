import 'package:accessability/Modele/evaluation_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class EvaluationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'evaluations';

  // Ajouter une évaluation
  Future<void> addEvaluation(Evaluation evaluation) async {
    try {
      await _firestore.collection(collectionName).add(evaluation.toFirestore());
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de l'ajout de l'évaluation : $e");
      }
    }
  }

  // Récupérer toutes les évaluations d'un enfant
  Future<List<Evaluation>> getEvaluationsByEnfantId(String enfantId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection(collectionName)
          .where('enfantId', isEqualTo: enfantId)
          .get();
      return querySnapshot.docs
          .map((doc) => Evaluation.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération des évaluations : $e");
      }
      return [];
    }
  }
}