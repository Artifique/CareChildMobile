// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:accessability/Modele/ressource_modele.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class RessourceService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Uuid _uuid = const Uuid();

  // Méthode pour télécharger un fichier dans Firebase Storage et obtenir l'URL de téléchargement
  Future<String> _uploadFile(File file, String path) async {
    try {
      TaskSnapshot snapshot = await _storage.ref(path).putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl; // L'URL du fichier est retournée
    } catch (e) {
      throw Exception('Erreur lors du téléchargement du fichier : $e');
    }
  }

  // Méthode pour créer et sauvegarder une ressource
  Future<void> enregistrerRessource({
    required String titre,
    required String type, // 'audio', 'video', 'pdf'
    required String idSpecialiste,
    String? transcriptionTexte, // Pour l'audio
    String? imageRepresentationPath, // Chemin local de l'image représentative à uploader
  }) async {
    // Sélection du fichier principal à uploader en fonction du type
    FilePickerResult? result;
    String? filePath; // Pour stocker le chemin du fichier sélectionné

    if (type == 'audio') {
      result = await FilePicker.platform.pickFiles(type: FileType.audio);
    } else if (type == 'video') {
      result = await FilePicker.platform.pickFiles(type: FileType.video);
      // Vérification du format vidéo
      if (result != null && !['mp4', 'avi'].contains(result.files.single.extension)) {
        throw Exception('Le fichier vidéo doit être au format MP4 ou AVI.');
      }
    } else if (type == 'pdf') {
      result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    }

    // Vérification si un fichier a été sélectionné
    if (result != null && result.files.single.path != null) {
      filePath = result.files.single.path;
      File file = File(filePath!);
      String fileId = _uuid.v4(); // Génération d'un ID unique pour la ressource
      String fileExtension = result.files.single.extension ?? ''; // Récupération de l'extension de fichier
      String filePathInStorage = '$type/$fileId.$fileExtension'; // Chemin dans Firebase Storage

      try {
        // Upload du fichier principal et récupération de l'URL
        String downloadUrl = await _uploadFile(file, filePathInStorage);

        // Si une image représentative est fournie, elle est aussi uploadée
        String? imageUrl;
        if (imageRepresentationPath != null) {
          File imageFile = File(imageRepresentationPath);
          String imageFilePath = 'images/$fileId'; // Chemin pour l'image dans Firebase Storage
          imageUrl = await _uploadFile(imageFile, imageFilePath);
        }

        // Création de l'objet Ressource avec les URLs récupérées
        Ressource nouvelleRessource = Ressource(
          idRessource: fileId,
          titre: titre,
          type: type,
          url: downloadUrl,
          transcriptionTexte: transcriptionTexte ?? '',
          imageRepresentation: imageUrl ?? '', // URL de l'image représentative, ou vide
          idSpecialiste: idSpecialiste,
        );

        // Sauvegarde des métadonnées dans Firestore
        await _firestore.collection('ressources').doc(fileId).set(nouvelleRessource.toJson());

      } catch (e) {
        throw Exception('Erreur lors de l\'enregistrement de la ressource : $e');
      }
    } else {
      throw Exception('Aucun fichier sélectionné.');
    }
  }

  // Méthode pour récupérer toutes les ressources d'un type spécifique
  Future<List<Ressource>> recupererRessourcesParType(String type) async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('ressources').where('type', isEqualTo: type).get();
      return querySnapshot.docs.map((doc) {
        return Ressource.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des ressources : $e');
    }
  }

  // Méthode pour récupérer toutes les ressources audio
  Future<List<Ressource>> recupererRessourcesAudio() async {
    return await recupererRessourcesParType('audio');
  }

  // Méthode pour récupérer toutes les ressources vidéo
  Future<List<Ressource>> recupererRessourcesVideo() async {
    return await recupererRessourcesParType('video');
  }

  // Méthode pour récupérer toutes les ressources PDF
  Future<List<Ressource>> recupererRessourcesPdf() async {
    return await recupererRessourcesParType('pdf');
  }
}
