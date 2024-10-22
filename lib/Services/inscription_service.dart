import 'package:accessability/Modele/inscription_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InscriptionService {
  final CollectionReference inscriptionCollection = FirebaseFirestore.instance.collection('inscriptions');

  // Créer une nouvelle inscription
  Future<void> inscrireParent(Inscription inscription) async {
    try {
      // Vérifier si l'utilisateur est déjà inscrit à l'événement
      QuerySnapshot existingInscription = await inscriptionCollection
          .where('idParent', isEqualTo: inscription.idParent)
          .where('idEvent', isEqualTo: inscription.idEvent)
          .get();

      if (existingInscription.docs.isEmpty) {
        // Si aucune inscription n'existe, en créer une nouvelle
        await inscriptionCollection.add(inscription.toFirestore());
      } else {
        // Lever une exception spécifique si déjà inscrit
        throw Exception('already_registered');
      }
    } catch (e) {
      if (e.toString().contains('already_registered')) {
        // Lever une exception spécifique si l'utilisateur est déjà inscrit
        throw Exception('Vous etes déjà inscrit à cet événement.');
      } else {
        // Lever une autre exception en cas d'erreur différente
        throw Exception('Erreur lors de l\'inscription à l\'événement : $e');
      }
    }
  }

  // Récupérer toutes les inscriptions pour un événement donné
  Future<List<Inscription>> getInscriptionsByEvent(String idEvent) async {
    try {
      QuerySnapshot querySnapshot = await inscriptionCollection.where('idEvent', isEqualTo: idEvent).get();
      return querySnapshot.docs
          .map((doc) => Inscription.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des inscriptions pour cet événement : $e');
    }
  }

  // Récupérer toutes les inscriptions pour un parent donné
  Future<List<Inscription>> getInscriptionsByParent(String idParent) async {
    try {
      QuerySnapshot querySnapshot = await inscriptionCollection.where('idParent', isEqualTo: idParent).get();
      return querySnapshot.docs
          .map((doc) => Inscription.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des inscriptions pour ce parent : $e');
    }
  }

  // Supprimer une inscription
  Future<void> deleteInscription(String idParent, String idEvent) async {
    try {
      QuerySnapshot querySnapshot = await inscriptionCollection
          .where('idParent', isEqualTo: idParent)
          .where('idEvent', isEqualTo: idEvent)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await inscriptionCollection.doc(querySnapshot.docs.first.id).delete();
      } else {
        throw Exception('Inscription non trouvée.');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'inscription : $e');
    }
  }
}
