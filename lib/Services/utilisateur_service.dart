import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';



class UtilisateurService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String collectionName = 'utilisateurs';

  // Crée un admin par défaut si aucun n'existe
  Future<void> createDefaultAdmin() async {
    try {
      final QuerySnapshot adminQuery = await _firestore
          .collection(collectionName)
          .where('role', isEqualTo: 'ADMIN')
          .limit(1)
          .get();

      if (adminQuery.docs.isEmpty) {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: 'admin@gmail.com',
          password: 'Admin@123',
        );

        Utilisateur admin = Utilisateur(
          id: userCredential.user!.uid,
          nom: 'Admin',
          email: 'admin@gmail.com',
          mdp: 'Admin@123',
          adresse: 'Adresse admin',
          image: 'default_image_url',
          tel: '0000000000',
          role: 'ADMIN',
        );

        await saveUtilisateurInFirestore(admin);
        if (kDebugMode) {
          print("Admin par défaut créé avec succès.");
        }
      } else {
        if (kDebugMode) {
          print("Un admin existe déjà.");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la création de l'admin par défaut : $e");
      }
    }
  }

  // Fonction pour uploader une image dans Firebase Storage
  
// Fonction pour uploader une image dans Firebase Storage
Future<String?> uploadImage(File imageFile, String userId) async {
  if (!imageFile.existsSync()) {
    print('Le fichier image n\'existe pas.');
    return null;
  }
  try {
    Reference ref = _storage.ref().child('utilisateurs/$userId/profile.jpg');
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  } catch (e) {
    if (kDebugMode) {
      print('Erreur lors de l\'upload de l\'image : $e');
    }
    return null;
  }
}

// Sauvegarde l'utilisateur dans Firestore
Future<void> saveUtilisateurInFirestore(Utilisateur utilisateur) async {
  try {
    await _firestore.collection(collectionName).doc(utilisateur.id).set(
      utilisateur.toFirestore(),
      SetOptions(merge: true), // Évite d'écraser les données existantes
    );
    if (kDebugMode) {
      print("Utilisateur sauvegardé dans Firestore.");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Erreur lors de la sauvegarde de l'utilisateur dans Firestore : $e");
    }
  }
}

  // Créer un utilisateur Firebase et stocker son image dans Firestore
  Future<void> createUtilisateurWithImage(Utilisateur utilisateur, File imageFile) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: utilisateur.email,
        password: utilisateur.mdp,
      );

      String? imageUrl = await uploadImage(imageFile, userCredential.user!.uid);
      if (imageUrl == null) {
        throw Exception('Erreur lors de l\'upload de l\'image');
      }

      utilisateur = utilisateur.copyWith(id: userCredential.user!.uid, image: imageUrl);
      await saveUtilisateurInFirestore(utilisateur);

      if (kDebugMode) {
        print("Utilisateur avec image enregistré avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la création de l'utilisateur avec image : $e");
      }
    }
  }

  // Créer un utilisateur Firebase sans image et le stocker dans Firestore
  Future<void> createUtilisateur(Utilisateur utilisateur) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: utilisateur.email,
        password: utilisateur.mdp,
      );

      utilisateur = utilisateur.copyWith(id: userCredential.user!.uid);
      await saveUtilisateurInFirestore(utilisateur);

      if (kDebugMode) {
        print("Utilisateur enregistré avec succès.");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('L\'email est déjà utilisé.');
        }
      } else {
        if (kDebugMode) {
          print('Erreur: ${e.message}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la création de l'utilisateur : $e");
      }
    }
  }

  // Sauvegarde l'utilisateur dans Firestore
  // Future<void> saveUtilisateurInFirestore(Utilisateur utilisateur) async {
  //   try {
  //     await _firestore.collection(collectionName).doc(utilisateur.id).set(utilisateur.toFirestore());
  //     if (kDebugMode) {
  //       print("Utilisateur sauvegardé dans Firestore.");
  //     }
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print("Erreur lors de la sauvegarde de l'utilisateur dans Firestore : $e");
  //     }
  //   }
  // }

  // Récupérer un utilisateur par son ID
// Récupérer un utilisateur par son ID
Future<Utilisateur?> getUtilisateurById(String id) async {
  try {
    DocumentSnapshot doc = await _firestore.collection(collectionName).doc(id).get();
    if (doc.exists) {
      Utilisateur utilisateur = Utilisateur.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      // Récupère l'URL de l'image et met à jour l'utilisateur
      String? imageUrl = await getImageUrl(utilisateur.id);
      return utilisateur.copyWith(image: imageUrl); // Assurez-vous que le modèle Utilisateur prend en charge le champ image
    }
    return null;
  } catch (e) {
    if (kDebugMode) {
      print("Erreur lors de la récupération de l'utilisateur : $e");
    }
    return null;
  }
}


  // Mettre à jour un utilisateur
  Future<void> updateUtilisateur(Utilisateur utilisateur) async {
    try {
      await _firestore.collection(collectionName).doc(utilisateur.id).update(utilisateur.toFirestore());
      if (kDebugMode) {
        print("Utilisateur mis à jour avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la mise à jour de l'utilisateur : $e");
      }
    }
  }
  

  // Supprimer un utilisateur
  Future<void> deleteUtilisateur(String id) async {
    try {
      await _firestore.collection(collectionName).doc(id).delete();
      if (kDebugMode) {
        print("Utilisateur supprimé avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la suppression de l'utilisateur : $e");
      }
    }
  }

  // Récupérer l'utilisateur actuellement connecté
  Future<Utilisateur?> getCurrentUtilisateur() async {
    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        return await getUtilisateurById(currentUser.uid);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération de l'utilisateur connecté : $e");
      }
      return null;
    }
  }


    // Fonction pour uploader une image dans Firebase Storage (version web)
  Future<String?> webUploadImage(Uint8List imageBytes, String userId) async {
    try {
      Reference ref = _storage.ref().child('utilisateurs/$userId/profile.jpg');
      UploadTask uploadTask = ref.putData(imageBytes);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'upload de l\'image : $e');
      }
      return null;
    }
  }

  // Créer un utilisateur Firebase et stocker son image dans Firestore (version web)
  Future<void> webCreateUtilisateurWithImage(Utilisateur utilisateur, Uint8List imageBytes) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: utilisateur.email,
        password: utilisateur.mdp,
      );

      String? imageUrl = await webUploadImage(imageBytes, userCredential.user!.uid);
      if (imageUrl == null) {
        throw Exception('Erreur lors de l\'upload de l\'image');
      }

      utilisateur = utilisateur.copyWith(id: userCredential.user!.uid, image: imageUrl);
      await saveUtilisateurInFirestore(utilisateur);

      if (kDebugMode) {
        print("Utilisateur avec image enregistré avec succès.");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la création de l'utilisateur avec image : $e");
      }
    }
  }

  // // Fonction pour sélectionner une image (version web)
  // Future<Uint8List?> webSelectImage() async {
  //   final pickedFile = await ImagePickerWeb.getImageAsBytes();
  //   return pickedFile;
  // }


  // Récupérer le nombre total de parents
  Future<int> getTotalParents() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .where('role', isEqualTo: 'PARENT')
          .get();
      return snapshot.docs.length;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération du total de parents : $e");
      }
      return 0; // Retourne 0 en cas d'erreur
    }
  }

  // Récupérer le nombre total de spécialistes
  Future<int> getTotalSpecialistes() async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection(collectionName)
          .where('role',  whereIn: ['Ergothérapeute', 'Orthophoniste', 'Psychologue']) // Assurez-vous que le rôle est bien "SPECIALISTE"
          .get();
      return snapshot.docs.length;
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération du total de spécialistes : $e");
      }
      return 0; // Retourne 0 en cas d'erreur
    }
  }
 // Mettre à jour le mot de passe de l'utilisateur
Future<bool> updatePassword(String userId, String oldPassword, String newPassword) async {
  try {
    // Récupérer l'utilisateur actuellement connecté
    User? currentUser = _auth.currentUser;
    if (currentUser != null && currentUser.uid == userId) {
      // Ré-authentifier l'utilisateur avec l'ancien mot de passe
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: oldPassword,
      );

      await currentUser.reauthenticateWithCredential(credential);
      
      // Modifier le mot de passe dans Firebase Auth
      await currentUser.updatePassword(newPassword);

      // Mettre à jour le mot de passe dans Firestore
      Utilisateur? utilisateur = await getUtilisateurById(userId);
      if (utilisateur != null) {
        utilisateur = utilisateur.copyWith(mdp: newPassword);
        await updateUtilisateur(utilisateur);
        if (kDebugMode) {
          print("Mot de passe mis à jour avec succès.");
        }
        return true; // Indique que la mise à jour a réussi
      } else {
        if (kDebugMode) {
          print("Erreur : Utilisateur non trouvé dans Firestore.");
        }
        return false; // Indique que l'utilisateur n'a pas été trouvé
      }
    } else {
      if (kDebugMode) {
        print("Erreur : Aucun utilisateur connecté ou l'ID ne correspond pas.");
      }
      return false; // Indique qu'aucun utilisateur n'est connecté
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      if (kDebugMode) {
        print('Le mot de passe fourni est trop faible.');
      }
    } else if (e.code == 'requires-recent-login') {
      if (kDebugMode) {
        print('Cette opération nécessite une authentification récente.');
      }
    } else if (e.code == 'wrong-password') {
      if (kDebugMode) {
        print('L\'ancien mot de passe est incorrect.');
      }
    } else {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour du mot de passe : ${e.message}');
      }
    }
    return false; // Indique une erreur lors de la mise à jour
  } catch (e) {
    if (kDebugMode) {
      print("Erreur lors de la mise à jour du mot de passe : $e");
    }
    return false; // Indique une erreur générale
  }
}




// Méthode pour mettre à jour un utilisateur avec ou sans modification d'image, email ou mot de passe
Future<void> updateUtilisateurWithImageAndAuth(
    Utilisateur utilisateur, {
    String? newEmail,
    String? newPassword,
    File? newImageFile, // Pour les plateformes mobiles
    Uint8List? newImageBytes, // Pour les plateformes web
  }) async {
  try {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      if (kDebugMode) {
        print("Erreur : Aucun utilisateur connecté.");
      }
      return;
    }

    // Mettre à jour l'email dans Firebase Auth si une nouvelle valeur est fournie
    if (newEmail != null && newEmail != currentUser.email) {
      await currentUser.updateEmail(newEmail);
      await currentUser.reload(); // Recharge l'utilisateur après modification
      if (kDebugMode) {
        print("Email mis à jour avec succès.");
      }
    }

    // Mettre à jour le mot de passe dans Firebase Auth si une nouvelle valeur est fournie
    if (newPassword != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: utilisateur.mdp, // Le mot de passe actuel
      );
      await currentUser.reauthenticateWithCredential(credential);
      await currentUser.updatePassword(newPassword);
      if (kDebugMode) {
        print("Mot de passe mis à jour avec succès.");
      }
    }

    // Si une nouvelle image est fournie, la télécharger dans Firebase Storage
    String? newImageUrl;
    if (newImageFile != null) {
      newImageUrl = await uploadImage(newImageFile, utilisateur.id);
    } else if (newImageBytes != null) {
      newImageUrl = await webUploadImage(newImageBytes, utilisateur.id);
    }

    // Mettre à jour les autres champs dans Firestore (nom, adresse, etc.)
    utilisateur = utilisateur.copyWith(
      email: newEmail ?? utilisateur.email, 
      mdp: newPassword ?? utilisateur.mdp,
      image: newImageUrl ?? utilisateur.image,
    );

    await _firestore.collection(collectionName).doc(utilisateur.id).update(utilisateur.toFirestore());

    if (kDebugMode) {
      print("Informations de l'utilisateur mises à jour dans Firestore.");
    }

  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      if (kDebugMode) {
        print("Cette opération nécessite une authentification récente.");
      }
    } else if (e.code == 'email-already-in-use') {
      if (kDebugMode) {
        print("Cet email est déjà utilisé.");
      }
    } else if (e.code == 'weak-password') {
      if (kDebugMode) {
        print("Le mot de passe est trop faible.");
      }
    } else {
      if (kDebugMode) {
        print("Erreur Firebase : ${e.message}");
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print("Erreur lors de la mise à jour de l'utilisateur : $e");
    }
  }
}







// Récupérer l'URL de l'image de l'utilisateur
Future<String?> getImageUrl(String userId) async {
  try {
    String imageUrl = 'https://firebasestorage.googleapis.com/v0/b/access-ability-9faa7.appspot.com/o/utilisateurs%2F$userId%2Fprofile.jpg?alt=media';
    
    // Vérifie si l'image existe (peut être optimisé)
    final Reference ref = _storage.ref().child('utilisateurs/$userId/profile.jpg');
    final bool exists = await ref.getDownloadURL().then((_) => true).catchError((_) => false);
    
    return exists ? imageUrl : null;
  } catch (e) {
    if (kDebugMode) {
      print("Erreur lors de la récupération de l'URL de l'image : $e");
    }
    return null;
  }
}

// Récupérer tous les utilisateurs
Future<List<Utilisateur>> getAllUtilisateurs() async {
  try {
    final QuerySnapshot snapshot = await _firestore.collection(collectionName).get();
    return snapshot.docs.map((doc) {
      return Utilisateur.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  } catch (e) {
    if (kDebugMode) {
      print("Erreur lors de la récupération des utilisateurs : $e");
    }
    return []; // Retourne une liste vide en cas d'erreur
  }
}

// Récupérer tous les utilisateurs sauf l'utilisateur actuel
Future<List<Utilisateur>> getAllUtilisateursExceptCurrent() async {
  try {
    // Récupérer l'utilisateur actuellement connecté
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      if (kDebugMode) {
        print("Aucun utilisateur connecté.");
      }
      return [];
    }

    // Récupérer les utilisateurs sauf celui actuellement connecté
    final QuerySnapshot snapshot = await _firestore
        .collection(collectionName)
        .where('id', isNotEqualTo: currentUser.uid) // Filtrer l'utilisateur actuel
        .get();

    if (kDebugMode) {
      print("Nombre d'utilisateurs récupérés : ${snapshot.docs.length}");
    } // Vérifiez combien d'utilisateurs sont récupérés

    // Mapper les documents en objets Utilisateur
    return snapshot.docs.map((doc) {
      return Utilisateur.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  } catch (e) {
    if (kDebugMode) {
      print("Erreur lors de la récupération des utilisateurs : $e");
    }
    return [];
  }
}
Future<List<Utilisateur>> getUtilisateursNonAdminEtNonParent() async {
  try {
    final QuerySnapshot snapshot = await _firestore
        .collection(collectionName)
        .where('role', whereIn: ['Kinésithérapeute', 'Psychologue']) // Remplacez par les rôles appropriés
        .get();

    return snapshot.docs.map((doc) {
      return Utilisateur.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  } catch (e) {
    if (kDebugMode) {
      print("Erreur lors de la récupération des utilisateurs non admin et non parent : $e");
    }
    return []; // Retourne une liste vide en cas d'erreur
  }
}

Future<void> updateUtilisateurDetails(Utilisateur utilisateur, {String? newEmail, String? newPassword}) async {
  try {
    User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      if (kDebugMode) {
        print("Erreur : Aucun utilisateur connecté.");
      }
      return;
    }

    // Mettre à jour l'email et le mot de passe dans Firebase Auth si des valeurs sont fournies
    if (newEmail != null && newEmail != currentUser.email) {
      // ignore: deprecated_member_use
      await currentUser.updateEmail(newEmail);
      await currentUser.reload();  // Recharge l'utilisateur après modification
      if (kDebugMode) {
        print("Email mis à jour avec succès.");
      }
    }

    if (newPassword != null) {
      // Authentifier l'utilisateur avant de changer son mot de passe
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser.email!,
        password: utilisateur.mdp, // Le mot de passe actuel
      );

      await currentUser.reauthenticateWithCredential(credential);
      await currentUser.updatePassword(newPassword);
      if (kDebugMode) {
        print("Mot de passe mis à jour avec succès.");
      }
    }

    // Mettre à jour les autres champs dans Firestore (si ils sont fournis)
    utilisateur = utilisateur.copyWith(
      email: newEmail ?? utilisateur.email, // Si email n'est pas fourni, conserve l'ancien
      mdp: newPassword ?? utilisateur.mdp,   // Si mot de passe n'est pas fourni, conserve l'ancien
    );

    await _firestore.collection(collectionName).doc(utilisateur.id).update(utilisateur.toFirestore());
    if (kDebugMode) {
      print("Informations de l'utilisateur mises à jour dans Firestore.");
    }

  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      if (kDebugMode) {
        print("Cette opération nécessite une authentification récente.");
      }
    } else if (e.code == 'email-already-in-use') {
      if (kDebugMode) {
        print("Cet email est déjà utilisé.");
      }
    } else if (e.code == 'weak-password') {
      if (kDebugMode) {
        print("Le mot de passe est trop faible.");
      }
    } else {
      if (kDebugMode) {
        print("Erreur Firebase : ${e.message}");
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print("Erreur lors de la mise à jour de l'utilisateur : $e");
    }
  }
}





// Récupérer un spécialiste par son ID
  Future<Utilisateur?> obtenirSpecialisteParId(String idSpecialiste) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(collectionName).doc(idSpecialiste).get();
      if (doc.exists) {
        Utilisateur utilisateur = Utilisateur.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
   
       
        return utilisateur; // Retourne l'utilisateur si c'est un spécialiste
      } else {
        if (kDebugMode) {
          print('Aucun utilisateur trouvé pour cet ID');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération du spécialiste : $e');
      }
      return null;
    }
  }
Future<List<Utilisateur>> getUtilisateursAvecRole(String role) async {
  final querySnapshot = await _firestore.collection('utilisateurs').where('role', isEqualTo: role).get();
  return querySnapshot.docs.map((doc) {
    // ignore: unnecessary_cast
    return Utilisateur.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
  }).toList();
}

}
