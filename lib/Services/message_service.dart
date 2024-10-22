import 'package:accessability/Modele/groupe_modele.dart';
import 'package:accessability/Modele/message_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Créer un groupe de discussion avec une clé générée automatiquement
  Future<void> creerGroupe(String idGroupe, String nomGroupe, List<String> participantsIds, String createurId) async {
    final groupe = GroupeDiscussion(
      idGroupe: idGroupe,
      nom: nomGroupe,
      createurId: createurId,
      participantsIds: participantsIds,
    );

    await _firestore.collection('groupes').doc(idGroupe).set(groupe.toFirestore());
  }

  // Récupérer un nouvel ID pour le groupe
  String getNewGroupeId() {
    return _firestore.collection('groupes').doc().id;
  }

  // Envoyer un message
  Future<void> envoyerMessage(String emetteurId, String recepteurId, String contenu, {String? idGroupe}) async {
    String idMessage = _firestore.collection('messages').doc().id; 
    Message message = Message(
      idMessage: idMessage,
      contenu: contenu,
      dateEnvoi: DateTime.now(),
      emetteurId: emetteurId,
      recepteurId: recepteurId,
      idGroupe: idGroupe,
    );

    await _firestore.collection('messages').doc(idMessage).set(message.toFirestore());
  }

  // Recevoir les messages (privés ou de groupe)
  Stream<List<Message>> recevoirMessages(String? idGroupe, String currentUserId) {
    Query query = _firestore.collection('messages').orderBy('dateEnvoi');

    if (idGroupe != null && idGroupe.isNotEmpty) {
      query = query.where('idGroupe', isEqualTo: idGroupe);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList().where((message) {
        return message.emetteurId == currentUserId || message.recepteurId == currentUserId;
      }).toList();
    });
  }

  // Ajouter un participant à un groupe
  // Future<void> ajouterParticipant(String idGroupe, String participantId) async {
  //   DocumentSnapshot groupeSnapshot = await _firestore.collection('groupes').doc(idGroupe).get();
    
  //   if (groupeSnapshot.exists) {
  //     GroupeDiscussion groupe = GroupeDiscussion.fromFirestore(groupeSnapshot.data() as Map<String, dynamic>, idGroupe);
  //     groupe.participantsIds.add(participantId); 

  //     await _firestore.collection('groupes').doc(idGroupe).update({'participantsIds': groupe.participantsIds});
  //   }
  // }

  // Recevoir tous les participants d'un groupe
  Future<List<String>> recevoirParticipants(String idGroupe) async {
    DocumentSnapshot groupeSnapshot = await _firestore.collection('groupes').doc(idGroupe).get();
    if (groupeSnapshot.exists) {
      GroupeDiscussion groupe = GroupeDiscussion.fromFirestore(groupeSnapshot.data() as Map<String, dynamic>, idGroupe);
      return groupe.participantsIds;
    }
    return [];
  }

  // Supprimer un groupe
  Future<void> supprimerGroupe(String idGroupe) async {
    final messagesSnapshot = await _firestore.collection('messages').where('idGroupe', isEqualTo: idGroupe).get();
    for (var doc in messagesSnapshot.docs) {
      await doc.reference.delete();
    }
    
    await _firestore.collection('groupes').doc(idGroupe).delete();
  }

  // Supprimer un message
  Future<void> supprimerMessage(String idMessage) async {
    await _firestore.collection('messages').doc(idMessage).delete();
  }

  // Récupérer tous les groupes
  Future<List<GroupeDiscussion>> getAllGroupes() async {
    QuerySnapshot querySnapshot = await _firestore.collection('groupes').get();
    return querySnapshot.docs.map((doc) {
      return GroupeDiscussion.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Envoyer une demande d'adhésion à un groupe
  Future<void> envoyerDemandeAdhesion(String idGroupe, String demandeurId) async {
    Map<String, dynamic> demande = {
      'demandeurId': demandeurId,
      'idGroupe': idGroupe,
      'statut': 'en attente',
    };

    await _firestore.collection('demandesAdhesion').add(demande);
  }

  // Recevoir les demandes d'adhésion d'un groupe
  Stream<List<Map<String, dynamic>>> recevoirDemandesAdhesion(String idGroupe) {
    return _firestore
        .collection('demandesAdhesion')
        .where('idGroupe', isEqualTo: idGroupe)
        .where('statut', isEqualTo: 'en attente')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => doc.data()).toList();
        });
  }

  // Accepter une demande d'adhésion
  Future<void> accepterDemande(String demandeId, String idGroupe, String participantId) async {
    // Mettre à jour le statut de la demande
    await _firestore.collection('demandesAdhesion').doc(demandeId).update({'statut': 'accepté'});
    // Ajouter le participant au groupe
    await ajouterParticipant(idGroupe, participantId);
  }

  // Refuser une demande d'adhésion
  Future<void> refuserDemande(String demandeId) async {
    // Mettre à jour le statut de la demande
    await _firestore.collection('demandesAdhesion').doc(demandeId).update({'statut': 'refusé'});
  }

  // Méthode pour ajouter un participant à un groupe
  Future<void> ajouterParticipant(String idGroupe, String participantId) async {
    DocumentSnapshot groupeSnapshot = await _firestore.collection('groupes').doc(idGroupe).get();
    if (groupeSnapshot.exists) {
      GroupeDiscussion groupe = GroupeDiscussion.fromFirestore(groupeSnapshot.data() as Map<String, dynamic>, idGroupe);
      groupe.participantsIds.add(participantId);

      // Mettre à jour la liste des participants
      await _firestore.collection('groupes').doc(idGroupe).update({'participantsIds': groupe.participantsIds});
    }
  }

  // Récupérer l'ID d'un groupe par l'ID du créateur
  Future<String?> getGroupeByCreateurId(String createurId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('groupes')
        .where('createurId', isEqualTo: createurId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.id; // Retourner l'ID du premier groupe trouvé
    }
    return null;
  }

  // Récupérer une demande d'adhésion en fonction de l'ID du groupe
  Future<Map<String, dynamic>?> getDemandeByGroupeId(String idGroupe) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('demandesAdhesion')
        .where('idGroupe', isEqualTo: idGroupe)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data() as Map<String, dynamic>;
    }
    return null;
  }


  
  // Méthode pour récupérer toutes les demandes d'adhésion pour les groupes créés par l'utilisateur actuel
  Stream<List<Map<String, dynamic>>> recevoirDemandesAdhesionPourGroupesCreateur(String currentUserId) async* {
    // Récupérer les groupes créés par l'utilisateur
    QuerySnapshot groupesSnapshot = await _firestore
        .collection('groupes')
        .where('createurId', isEqualTo: currentUserId)
        .get();

    List<String> groupesIds = groupesSnapshot.docs.map((doc) => doc.id).toList();

    if (groupesIds.isEmpty) {
      yield [];
      return;
    }

    // Écouter les demandes d'adhésion pour ces groupes
    yield* _firestore
        .collection('demandesAdhesion')
        .where('idGroupe', whereIn: groupesIds)
        .where('statut', isEqualTo: 'en attente')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }




}
