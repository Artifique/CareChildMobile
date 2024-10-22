import 'package:accessability/Modele/rendez-vous_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RendezVousService {
  final CollectionReference rendezVousCollection =
      FirebaseFirestore.instance.collection('rendezVous');

  // Prendre un rendez-vous
  Future<void> prendreRendezVous(RendezVousM rendezVous) async {
    try {
      await rendezVousCollection.doc(rendezVous.idRendezVousM).set(rendezVous.toFirestore());
      if (kDebugMode) {
        print('Rendez-vous pris avec succès');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la prise de rendez-vous : $e');
      }
    }
  }

  // Annuler un rendez-vous
  Future<void> annulerRendezVous(String idRendezVous) async {
    try {
      await rendezVousCollection.doc(idRendezVous).update({'status': 'annulé'});
      if (kDebugMode) {
        print('Rendez-vous annulé avec succès');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'annulation du rendez-vous : $e');
      }
    }
  }
  // Annuler un rendez-vous
  // ignore: non_constant_identifier_names
  Future<void> Terminer(String idRendezVous) async {
    try {
      await rendezVousCollection.doc(idRendezVous).update({'status': 'terminé'});
      if (kDebugMode) {
        print('Rendez-vous declarer terminé');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la declaration du rendez vous comme terminé : $e');
      }
    }
  }

  // Mettre un rendez-vous en attente
  Future<void> mettreEnAttente(String idRendezVous) async {
    try {
      await rendezVousCollection.doc(idRendezVous).update({'status': 'en attente'});
      if (kDebugMode) {
        print('Rendez-vous mis en attente avec succès');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise en attente du rendez-vous : $e');
      }
    }
  }

  // Confirmer un rendez-vous
  Future<void> confirmerRendezVous(String idRendezVous) async {
    try {
      await rendezVousCollection.doc(idRendezVous).update({'status': 'confirmé'});
      if (kDebugMode) {
        print('Rendez-vous confirmé avec succès');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la confirmation du rendez-vous : $e');
      }
    }
  }

  // Prendre en charge un rendez-vous (mettre le statut à "en charge")
  Future<void> prendreEnCharge(String idRendezVous) async {
    try {
      await rendezVousCollection.doc(idRendezVous).update({'status': 'en charge'});
      if (kDebugMode) {
        print('Rendez-vous pris en charge avec succès');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la prise en charge du rendez-vous : $e');
      }
    }
  }

  // Terminer un rendez-vous (mettre le statut à "terminé")
  Future<void> terminer(String idRendezVous) async {
    try {
      await rendezVousCollection.doc(idRendezVous).update({'status': 'terminé'});
      if (kDebugMode) {
        print('Rendez-vous terminé avec succès');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la terminaison du rendez-vous : $e');
      }
    }
  }

  // Lister tous les rendez-vous
  Future<List<RendezVousM>> listerRendezVous() async {
    try {
      QuerySnapshot querySnapshot = await rendezVousCollection.get();
      return querySnapshot.docs
          .map((doc) => RendezVousM.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors du listing des rendez-vous : $e');
      }
      return [];
    }
  }

  // Obtenir un rendez-vous par son ID
  Future<RendezVousM?> obtenirRendezVousParId(String idRendezVous) async {
    try {
      DocumentSnapshot doc = await rendezVousCollection.doc(idRendezVous).get();
      if (doc.exists) {
        return RendezVousM.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      } else {
        if (kDebugMode) {
          print('Aucun rendez-vous trouvé pour cet ID');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération du rendez-vous : $e');
      }
      return null;
    }
  }

  // Récupérer les rendez-vous par ID de parent
  Future<List<RendezVousM>> getRendezVousByParentId(String parentId) async {
    try {
      QuerySnapshot snapshot = await rendezVousCollection
          .where('idParent', isEqualTo: parentId)
          .get();

      return snapshot.docs.map((doc) => RendezVousM.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération des rendez-vous : $e");
      }
      return [];
    }
  }

  // Récupérer les rendez-vous par ID de spécialiste
  Future<List<RendezVousM>> getRendezVousBySpecialisteId(String idSpecialiste) async {
    try {
      QuerySnapshot snapshot = await rendezVousCollection
          .where('idSpecialiste', isEqualTo: idSpecialiste)
          .get();

      return snapshot.docs.map((doc) => RendezVousM.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération des rendez-vous : $e");
      }
      return [];
    }
  }

  // Récupérer les rendez-vous par ID d'enfant
  Future<List<RendezVousM>> getRendezVousByEnfantId(String idEnfant) async {
    try {
      QuerySnapshot snapshot = await rendezVousCollection
          .where('idEnfant', isEqualTo: idEnfant)
          .get();

      return snapshot.docs.map((doc) => RendezVousM.fromFirestore(doc.data() as Map<String, dynamic>, doc.id)).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération des rendez-vous : $e");
      }
      return [];
    }
  }

  // Mettre à jour les informations d'un rendez-vous
  Future<void> mettreAJourRendezVous(String idRendezVous, Map<String, dynamic> nouvellesInformations) async {
    try {
      await rendezVousCollection.doc(idRendezVous).update(nouvellesInformations);
      if (kDebugMode) {
        print('Rendez-vous mis à jour avec succès');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour du rendez-vous : $e');
      }
    }
  }

Future<String?> getEnfantIdByRendezVousId(String idRendezVous) async {
  try {
    DocumentSnapshot doc = await rendezVousCollection.doc(idRendezVous).get();
    if (doc.exists && doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return data['idEnfant'];  // Assurez-vous que 'idEnfant' est bien le champ correct dans Firestore
    } else {
      if (kDebugMode) {
        print('Aucun rendez-vous trouvé pour cet ID');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Erreur lors de la récupération de l\'ID enfant : $e');
    }
    return null;
  }
}
Future<String?> getParentIdByRendezVousId(String idRendezVous) async {
  try {
    DocumentSnapshot doc = await rendezVousCollection.doc(idRendezVous).get();
    if (doc.exists && doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return data['idParent'];  // Assurez-vous que 'idParent' est bien le champ correct dans Firestore
    } else {
      if (kDebugMode) {
        print('Aucun rendez-vous trouvé pour cet ID');
      }
      return null;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Erreur lors de la récupération de l\'ID parent : $e');
    }
    return null;
  }
}


  
}