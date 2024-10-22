// ignore_for_file: use_build_context_synchronously

import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Services/ressource_service.dart';
import 'package:accessability/Services/utilisateur_service.dart'; 
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddRessources extends StatefulWidget {
  const AddRessources({super.key});

  @override
  State<AddRessources> createState() => _AddRessourcesState();
}

class _AddRessourcesState extends State<AddRessources> {
  int _selectedIndex = 0; // Index de l'onglet sélectionné
  final RessourceService _ressourceService = RessourceService();
  final UtilisateurService _utilisateurService = UtilisateurService(); 

  // Contrôleurs pour les champs de texte spécifiques à chaque formulaire
  final TextEditingController _titreVocalController = TextEditingController();
  final TextEditingController _transcriptionController = TextEditingController();
  final TextEditingController _titreVideoController = TextEditingController();
  // ignore: unused_field
  final TextEditingController _imageVideoController = TextEditingController();
  final TextEditingController _titreDocumentController = TextEditingController();

  String? _filePath; // Chemin du fichier à uploader (audio, vidéo ou PDF)
  String? _imageFilePath; // Chemin du fichier image à uploader (pour les vocaux)

  // Widgets pour chaque formulaire
  late List<Widget> _contentWidgets;

  @override
  void initState() {
    super.initState();
    _contentWidgets = [
      _buildVocalForm(),
      _buildVideoForm(),
      _buildDocumentForm()
    ];
    
    // Récupération de l'utilisateur courant
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    Utilisateur? currentUser = await _utilisateurService.getCurrentUtilisateur();
    if (currentUser != null) {
      // L'utilisateur est chargé et vous pouvez utiliser ses informations
    }
  }

  // Formulaire pour le type Vocal
  Widget _buildVocalForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: _titreVocalController,
            decoration: const InputDecoration(labelText: 'Titre Vocal'),
          ),
          TextField(
            controller: _transcriptionController,
            decoration: const InputDecoration(labelText: 'Transcription Audio'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _selectFile(FileType.audio),
            child: const Text('Sélectionner un fichier audio'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectImage,
            child: const Text('Sélectionner une image représentative'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _addRessource('vocal'),
            child: const Text('Ajouter Ressource Vocal'),
          ),
          if (_filePath != null) 
            Text('Fichier audio sélectionné : ${_filePath!.split('/').last}'),
        ],
      ),
    );
  }

  // Formulaire pour le type Vidéo
  Widget _buildVideoForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: _titreVideoController,
            decoration: const InputDecoration(labelText: 'Titre Vidéo'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _selectFile(FileType.video),
            child: const Text('Sélectionner un fichier vidéo'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _addRessource('video'),
            child: const Text('Ajouter Ressource Vidéo'),
          ),
          if (_filePath != null) 
            Text('Fichier vidéo sélectionné : ${_filePath!.split('/').last}'),
        ],
      ),
    );
  }

  // Formulaire pour le type Document (PDF)
  Widget _buildDocumentForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: _titreDocumentController,
            decoration: const InputDecoration(labelText: 'Titre PDF'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _selectFile(FileType.custom, allowedExtensions: ['pdf']),
            child: const Text('Sélectionner un fichier PDF'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _addRessource('pdf'),
            child: const Text('Ajouter Ressource PDF'),
          ),
          if (_filePath != null) 
            Text('Fichier PDF sélectionné : ${_filePath!.split('/').last}'),
        ],
      ),
    );
  }

  // Sélection du fichier (audio, vidéo ou document)
  Future<void> _selectFile(FileType fileType, {List<String>? allowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowedExtensions: allowedExtensions,
    );

    setState(() {
      _filePath = result?.files.single.path;
    });

    if (_filePath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fichier sélectionné : ${result?.files.single.name}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun fichier sélectionné.')),
      );
    }
  }

  // Sélection d'une image représentative pour les vocaux
  Future<void> _selectImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    setState(() {
      _imageFilePath = result?.files.single.path;
    });

    if (_imageFilePath != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image sélectionnée : ${result?.files.single.name}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune image sélectionnée.')),
      );
    }
  }

  // Ajouter une ressource en fonction du type sélectionné
  Future<void> _addRessource(String type) async {
    if (_filePath != null) {
      try {
        Utilisateur? currentUser = await _utilisateurService.getCurrentUtilisateur();
        String userId = currentUser?.id ?? '';

        await _ressourceService.enregistrerRessource(
          titre: type == 'vocal' ? _titreVocalController.text
                : type == 'video' ? _titreVideoController.text
                : _titreDocumentController.text,
          type: type,
          idSpecialiste: userId,
          transcriptionTexte: type == 'vocal' ? _transcriptionController.text : null,
          imageRepresentationPath: type == 'vocal' ? _imageFilePath : null,
        );

        _resetFields(type);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ressource ajoutée avec succès')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'ajout de la ressource : $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez uploader un fichier.')),
      );
    }
  }

  // Réinitialiser les champs de saisie
  void _resetFields(String type) {
    if (type == 'vocal') {
      _titreVocalController.clear();
      _transcriptionController.clear();
      _imageFilePath = null;
    } else if (type == 'video') {
      _titreVideoController.clear();
    } else {
      _titreDocumentController.clear();
    }
    setState(() {
      _filePath = null;  // Réinitialiser le chemin du fichier
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter Ressources'),
      ),
      body: Column(
        children: [
          // Onglets pour sélectionner le type de ressource
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTabButton(0, 'Vocal'),
              _buildTabButton(1, 'Vidéo'),
              _buildTabButton(2, 'Document'),
            ],
          ),
          Expanded(
            child: _contentWidgets[_selectedIndex], // Affiche le formulaire correspondant
          ),
        ],
      ),
    );
  }

  // Widget pour les boutons d'onglet
  Widget _buildTabButton(int index, String title) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Text(title),
    );
  }
}
