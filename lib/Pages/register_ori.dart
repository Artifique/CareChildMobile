import 'package:accessability/Modele/parent_modele.dart';
import 'package:accessability/Services/parent_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class RegisterOri extends StatefulWidget {
  const RegisterOri({super.key});

  @override
  State<RegisterOri> createState() => _RegisterOriState();
}

class _RegisterOriState extends State<RegisterOri> {
  bool _obscureText = true;

  // Controllers pour les champs de texte
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
  final TextEditingController _telController = TextEditingController();

  // ignore: prefer_final_fields
  ParentService _parentService = ParentService();
  XFile? _image;

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _adresseController.dispose();
    _telController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    _image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<String?> _uploadImage() async {
    if (_image == null) return null;
    final ref = FirebaseStorage.instance.ref().child('profile_images/${_image!.name}');
    await ref.putFile(File(_image!.path));
    return await ref.getDownloadURL();
  }

  Future<void> _registerParent() async {
    if (_nomController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _adresseController.text.isNotEmpty &&
        _telController.text.isNotEmpty) {
      String? imageUrl = await _uploadImage();

      // Créer un nouvel objet Parent
      Parent newParent = Parent(
        id: '', // L'ID sera rempli après la création dans Firestore
        nom: _nomController.text,
        email: _emailController.text,
        mdp: _passwordController.text,
        adresse: _adresseController.text,
        image: imageUrl ?? '',
        tel: _telController.text,
      );

      try {
        // Ajouter le Parent à Firestore
        await _parentService.createParent(newParent, _passwordController.text);

        // Rediriger l'utilisateur vers une autre page après l'enregistrement
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, '/utilisateurs');
      } catch (e) {
        if (kDebugMode) {
          print('Erreur lors de l\'enregistrement : $e');
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de l\'enregistrement.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tous les champs sont obligatoires.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF23a6e2),
      body: SafeArea(
        child: Expanded(
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFFFFFFF),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 25),
                      // Champ Nom
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
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
                        padding: const EdgeInsets.symmetric(horizontal: 0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: TextField(
                          controller: _adresseController,
                          decoration: const InputDecoration(
                            labelText: 'Adresse',
                            prefixIcon: Icon(Icons.home),
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
                      // Bouton pour choisir une image
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text('Choisir une photo de profil'),
                        ),
                      ),
                      // Affichage de l'image sélectionnée
                      if (_image != null)
                        Image.file(File(_image!.path)),
                      const SizedBox(height: 25),
                      // Bouton d'inscription
                      ElevatedButton(
                        onPressed: _registerParent,
                        child: const Text('S\'inscrire'),
                      ),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
