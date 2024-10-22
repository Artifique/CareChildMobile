import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Modele/evenement_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class RechercheService {
  // Recherche des utilisateurs par nom
  Future<List<Utilisateur>> rechercherUtilisateurs(String query) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('utilisateurs')
          .where('nom', isGreaterThanOrEqualTo: query)
          // ignore: prefer_interpolation_to_compose_strings
          .where('nom', isLessThanOrEqualTo: query + '\uf8ff') // Recherche partielle
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Utilisateur(
          id: doc.id,
          nom: data['nom'],
          email: data['email'],
          tel: data['tel'],
          adresse: data['adresse'],
          image: data['image'],
          role: data['role'],
          mdp: '', // Ne pas récupérer le mot de passe ici
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la recherche des utilisateurs: $e");
      }
      return [];
    }
  }
// Recherche des événements par titre
 Future<List<Evenement>> rechercherEvenements(String query) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('evenements')
          .where('titre', isGreaterThanOrEqualTo: query)
          // ignore: prefer_interpolation_to_compose_strings
          .where('titre', isLessThanOrEqualTo: query + '\uf8ff') // Recherche partielle
          .get();

      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Convertir les champs de date si ce sont des chaînes
        DateTime dateDebut = data['dateDebut'] is Timestamp
            ? (data['dateDebut'] as Timestamp).toDate()
            : DateTime.parse(data['dateDebut']); // Conversion depuis String si besoin

        DateTime dateFin = data['dateFin'] is Timestamp
            ? (data['dateFin'] as Timestamp).toDate()
            : DateTime.parse(data['dateFin']); // Conversion depuis String si besoin

        DateTime heure = data['heure'] is Timestamp
            ? (data['heure'] as Timestamp).toDate()
            : DateTime.parse(data['heure']); // Conversion depuis String si besoin

        return Evenement(
          id: doc.id,
          titre: data['titre'],
          description: data['description'],
          dateDebut: dateDebut,
          dateFin: dateFin,
          heure: heure,
          parentId: data['parentId'] ?? 'RIEN',
          adminId: data['adminId'] ?? '',
        );
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la recherche des événements: $e");
      }
      return [];
    }
  }

}
