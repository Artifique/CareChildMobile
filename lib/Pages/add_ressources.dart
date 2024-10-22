// ignore_for_file: use_build_context_synchronously

import 'package:accessability/Services/ressource_service.dart';
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

  // Contrôleurs pour les champs de texte spécifiques à chaque formulaire
  final TextEditingController _titreVocalController = TextEditingController();
  final TextEditingController _transcriptionController = TextEditingController();
  final TextEditingController _idSpecialisteController = TextEditingController();

  final TextEditingController _titreVideoController = TextEditingController();
  final TextEditingController _imageVideoController = TextEditingController();

  final TextEditingController _titreDocumentController = TextEditingController();

  String? _filePath; // Chemin du fichier à uploader (audio, vidéo ou PDF)
  String? _imageFilePath; // Chemin du fichier image à uploader (pour les vocaux)

  // Widgets pour chaque formulaire
  List<Widget> _contentWidgets = [];

  @override
  void initState() {
    super.initState();
    _contentWidgets = [
      _buildVocalForm(),   // Formulaire pour type vocal
      _buildVideoForm(),   // Formulaire pour type vidéo
      _buildDocumentForm() // Formulaire pour type document
    ];
  }

  // Formulaire pour le type Vocal (incluant tous les champs et l'upload d'image)
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
          TextField(
            controller: _idSpecialisteController,
            decoration: const InputDecoration(labelText: 'ID du Spécialiste'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              _selectFile(FileType.audio);  // Upload du fichier audio
            },
            child: const Text('Uploader un fichier audio'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              _selectImage();  // Upload de l'image représentative
            },
            child: const Text('Uploader une image représentative'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _addRessource('vocal'),  // Ajouter ressource vocal
            child: const Text('Ajouter Ressource Vocal'),
          ),
        ],
      ),
    );
  }

  // Formulaire pour le type Vidéo (pas de transcription)
  Widget _buildVideoForm() {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextField(
            controller: _titreVideoController,
            decoration: const InputDecoration(labelText: 'Titre Vidéo'),
          ),
          TextField(
            controller: _imageVideoController,
            decoration: const InputDecoration(labelText: 'Image de prévisualisation'),
          ),
          TextField(
            controller: _idSpecialisteController,
            decoration: const InputDecoration(labelText: 'ID du Spécialiste'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              _selectFile(FileType.video);  // Upload du fichier vidéo
            },
            child: const Text('Uploader un fichier vidéo'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _addRessource('video'),  // Ajouter ressource vidéo
            child: const Text('Ajouter Ressource Vidéo'),
          ),
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
          TextField(
            controller: _idSpecialisteController,
            decoration: const InputDecoration(labelText: 'ID du Spécialiste'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              _selectFile(FileType.custom, allowedExtensions: ['pdf']);  // Upload fichier PDF
            },
            child: const Text('Uploader un fichier PDF'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _addRessource('pdf'),  // Ajouter ressource PDF
            child: const Text('Ajouter Ressource PDF'),
          ),
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
        // Création et ajout de la ressource selon le type
        await _ressourceService.enregistrerRessource(
          titre: type == 'vocal' ? _titreVocalController.text
                : type == 'video' ? _titreVideoController.text
                : _titreDocumentController.text,
          type: type,
          idSpecialiste: _idSpecialisteController.text,
          transcriptionTexte: type == 'vocal' ? _transcriptionController.text : null,
          imageRepresentationPath: type == 'vocal' ? _imageFilePath : null,  // Chemin de l'image pour vocal
        );

        // Réinitialiser les champs après l'ajout
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

  // Réinitialiser les champs spécifiques après ajout
  void _resetFields(String type) {
    if (type == 'vocal') {
      _titreVocalController.clear();
      _transcriptionController.clear();
      _imageFilePath = null;
    } else if (type == 'video') {
      _titreVideoController.clear();
      _imageVideoController.clear();
    } else if (type == 'pdf') {
      _titreDocumentController.clear();
    }
    _filePath = null;
  }

  void _onButtonTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B8FAC),
      appBar: AppBar(
        title: const Text(
          'Ajouter Ressources',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff0B8FAC),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                color: const Color.fromARGB(255, 255, 255, 255),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 41, 40, 40).withOpacity(0.5),
                    offset: const Offset(0, 5),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1,
                child: Padding(
                  padding: const EdgeInsets.all(28.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildButton('Vocal', 0),
                          _buildButton('Vidéo', 1),
                          _buildButton('Document', 2),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Expanded(child: _contentWidgets[_selectedIndex]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String title, int index) {
    bool isSelected = _selectedIndex == index;
    return ElevatedButton(
      onPressed: () => _onButtonTapped(index),
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? const Color(0xff0B8FAC) : Colors.white,
        backgroundColor: isSelected ? Colors.white : const Color(0xff0B8FAC),
        side: BorderSide(color: const Color(0xff0B8FAC), width: isSelected ? 2 : 0),
        padding: const EdgeInsets.all(10),
        textStyle: const TextStyle(fontSize: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
      ),
      child: Text(title),
    );
  }
}
