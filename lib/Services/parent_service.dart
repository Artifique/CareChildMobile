import 'package:accessability/Modele/parent_modele.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ParentService {
  final CollectionReference parentCollection = FirebaseFirestore.instance.collection('utilisateurs');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Créer un nouveau parent
  Future<void> createParent(Parent parent, String password) async {
    try {
      // Créer l'utilisateur dans Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: parent.email,
        password: password,
      );

      // Récupérer l'ID de l'utilisateur
      parent.id = userCredential.user!.uid;

      // Enregistrer le parent dans Firestore
      await parentCollection.doc(parent.id).set(parent.toFirestore());
    } catch (e) {
      throw Exception('Erreur lors de la création du parent : $e');
    }
  }

  // Mettre à jour un parent existant
  Future<void> updateParent(Parent parent) async {
    try {
      await parentCollection.doc(parent.id).update(parent.toFirestore());
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour du parent : $e');
    }
  }

  // Supprimer un parent
  Future<void> deleteParent(String id) async {
    try {
      await parentCollection.doc(id).delete();
    } catch (e) {
      throw Exception('Erreur lors de la suppression du parent : $e');
    }
  }

  // Récupérer tous les parents
  Future<List<Parent>> getAllParents() async {
    try {
      QuerySnapshot querySnapshot = await parentCollection.get();
      return querySnapshot.docs
          .map((doc) => Parent.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des parents : $e');
    }
  }

  // Récupérer un parent par ID
  Future<Parent> getParentById(String id) async {
    try {
      DocumentSnapshot doc = await parentCollection.doc(id).get();
      return Parent.fromFirestore(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Erreur lors de la récupération du parent : $e');
    }
  }
}
