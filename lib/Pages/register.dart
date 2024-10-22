import 'package:accessability/Services/utilisateur_service.dart';
import 'package:accessability/Widgets/bouton.dart';
import 'package:flutter/material.dart';
import 'dart:io'; // Pour la gestion des fichiers
import 'package:image_picker/image_picker.dart'; // Pour sélectionner une image
import 'package:accessability/Modele/utilisateur_modele.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _obscureText = true;
  File? _imageFile; // Fichier image sélectionné
  final ImagePicker _picker = ImagePicker();

  // Controllers pour les champs de texte
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  
  // Service utilisateur
  final UtilisateurService _utilisateurService = UtilisateurService();

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _adresseController.dispose();
    _telController.dispose();
    super.dispose();
  }

  // Fonction pour enregistrer l'utilisateur avec ou sans image
  Future<void> _registerUser() async {
    if (_nomController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _adresseController.text.isNotEmpty &&
        _telController.text.isNotEmpty) {
      
      // Création du nouvel utilisateur
      Utilisateur newUser = Utilisateur(
        id: '',
        nom: _nomController.text,
        email: _emailController.text,
        mdp: _passwordController.text,
        adresse: _adresseController.text,
        image: '',  // L'image sera ajoutée si elle est téléchargée
        tel: _telController.text,
        role: 'PARENT',
      );

      try {
        // Vérification si une image a été sélectionnée
        if (_imageFile != null) {
          // Créer un utilisateur avec l'image
          await _utilisateurService.createUtilisateurWithImage(newUser, _imageFile!);
        } else {
          // Créer un utilisateur sans image
          await _utilisateurService.createUtilisateur(newUser);
        }

        // Navigation vers la page des utilisateurs (ou autre)
        // ignore: use_build_context_synchronously
        // Navigator.pushNamed(context, '/lo');

      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'enregistrement : $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tous les champs sont obligatoires.')),
      );
    }
  }

  // Fonction pour sélectionner une image depuis la galerie
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B8FAC),
      body: SafeArea(
        child: SingleChildScrollView( // Ajout de SingleChildScrollView
          child: Column(
            children: [
              const SizedBox(height: 25), // Espace supérieur
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFFFFFFF),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 25),
                    // Image et bouton pour sélectionner une image
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null,
                        child: _imageFile == null
                            ? const Icon(Icons.camera_alt, size: 50)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Champ Nom
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _nomController,
                        decoration: const InputDecoration(
                          labelText: 'Nom',
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Champ Email
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.mail),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Champ Mot de passe
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          labelText: 'Mot de passe',
                          suffixIcon: IconButton(
                            icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Champ Adresse
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _adresseController,
                        decoration: const InputDecoration(
                          labelText: 'Adresse',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Champ Téléphone
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: _telController,
                        decoration: const InputDecoration(
                          labelText: 'Téléphone',
                          prefixIcon: Icon(Icons.phone),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Bouton d'enregistrement
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomButton(
                            text: 'Creer',
                            backgroundColor: const Color(0xff0957DE),
                            textColor: Colors.white,
                            icon: Icons.arrow_forward,
                            onPressed: () {
                             _registerUser();
                            },
                          ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}