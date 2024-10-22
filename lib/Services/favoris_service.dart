// import 'package:accessability/Modele/favoris_modele.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';


// class FavorisService {
//   final CollectionReference favorisCollection = FirebaseFirestore.instance.collection('favoris');

//   // Créer un nouvel élément favori
//   Future<void> createFavoris(Favoris favoris) async {
//     try {
//       await favorisCollection.doc(favoris.id).set(favoris.toFirestore());
//     } catch (e) {
//       throw Exception('Erreur lors de la création du favori : $e');
//     }
//   }

//   // Mettre à jour un élément favori existant
//   Future<void> updateFavoris(Favoris favoris) async {
//     try {
//       await favorisCollection.doc(favoris.id).update(favoris.toFirestore());
//     } catch (e) {
//       throw Exception('Erreur lors de la mise à jour du favori : $e');
//     }
//   }

//   // Supprimer un élément favori
//   Future<void> deleteFavoris(String id) async {
//     try {
//       await favorisCollection.doc(id).delete();
//     } catch (e) {
//       throw Exception('Erreur lors de la suppression du favori : $e');
//     }
//   }

//   // Récupérer tous les favoris
//   Future<List<Favoris>> getAllFavoris() async {
//     try {
//       QuerySnapshot querySnapshot = await favorisCollection.get();
//       return querySnapshot.docs.map((doc) => Favoris.fromFirestore(doc.data() as Map<String, dynamic>)).toList();
//     } catch (e) {
//       throw Exception('Erreur lors de la récupération des favoris : $e');
//     }
//   }

//   // Récupérer un favori par ID
//   Future<Favoris> getFavorisById(String id) async {
//     try {
//       DocumentSnapshot doc = await favorisCollection.doc(id).get();
//       return Favoris.fromFirestore(doc.data() as Map<String, dynamic>);
//     } catch (e) {
//       throw Exception('Erreur lors de la récupération du favori : $e');
//     }
//   }
// }
