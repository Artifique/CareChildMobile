import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:accessability/Modele/admin_modele.dart';
import 'package:flutter/foundation.dart';

class AdminService {
  final CollectionReference adminsCollection = FirebaseFirestore.instance.collection('admins');

  // Méthode pour ajouter un nouvel admin
  Future<void> ajouterAdmin(Admin admin) async {
    try {
      await adminsCollection.doc(admin.id).set(admin.toFirestore());
      if (kDebugMode) {
        print('Admin ajouté avec succès');
      }
    } catch (e) {
      throw Exception("Erreur lors de l'ajout de l'admin : $e");
    }
  }

  // Méthode pour récupérer un admin par ID
  Future<Admin> getAdminById(String adminId) async {
    try {
      DocumentSnapshot docSnapshot = await adminsCollection.doc(adminId).get();
      if (docSnapshot.exists) {
        return Admin.fromFirestore(docSnapshot.data() as Map<String, dynamic>);
      } else {
        throw Exception("Admin avec l'ID $adminId n'existe pas.");
      }
    } catch (e) {
      throw Exception("Erreur lors de la récupération de l'admin : $e");
    }
  }

  // Méthode pour mettre à jour les informations d'un admin
  Future<void> mettreAJourAdmin(Admin admin) async {
    try {
      await adminsCollection.doc(admin.id).update(admin.toFirestore());
      if (kDebugMode) {
        print('Admin mis à jour avec succès');
      }
    } catch (e) {
      throw Exception("Erreur lors de la mise à jour de l'admin : $e");
    }
  }

  // Méthode pour supprimer un admin
  Future<void> supprimerAdmin(String adminId) async {
    try {
      await adminsCollection.doc(adminId).delete();
      if (kDebugMode) {
        print('Admin supprimé avec succès');
      }
    } catch (e) {
      throw Exception("Erreur lors de la suppression de l'admin : $e");
    }
  }

  // Méthode pour lister tous les admins
  Future<List<Admin>> getTousLesAdmins() async {
    try {
      QuerySnapshot querySnapshot = await adminsCollection.get();
      return querySnapshot.docs.map((doc) {
        return Admin.fromFirestore(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception("Erreur lors de la récupération des admins : $e");
    }
  }

  // Méthode pour vérifier si un admin existe
  Future<bool> adminExiste(String adminId) async {
    try {
      DocumentSnapshot docSnapshot = await adminsCollection.doc(adminId).get();
      return docSnapshot.exists;
    } catch (e) {
      throw Exception("Erreur lors de la vérification de l'existence de l'admin : $e");
    }
  }
}
