import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Services/utilisateur_service.dart'; // Assurez-vous d'importer votre service
import 'package:accessability/Widgets/bouton.dart';

class ModifierProfile extends StatefulWidget {
  const ModifierProfile({Key? key}) : super(key: key);

  @override
  _ModifierProfileState createState() => _ModifierProfileState();
}

class _ModifierProfileState extends State<ModifierProfile> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Instance de votre service utilisateur
  final UtilisateurService utilisateurService = UtilisateurService();

  // Déclarez une variable pour stocker l'utilisateur courant
  Utilisateur? currentUser;

  // Variable pour contrôler la visibilité du mot de passe
  bool _passwordVisible = false;

  // Variable pour stocker l'image sélectionnée
  File? newImageFile;

  // Méthode pour récupérer et afficher les données de l'utilisateur connecté
  Future<void> _loadCurrentUser() async {
    currentUser = await utilisateurService.getCurrentUtilisateur();
    if (currentUser != null) {
      setState(() {
        _nameController.text = currentUser!.nom;
        _emailController.text = currentUser!.email;
        _addressController.text = currentUser!.adresse;
        _phoneController.text = currentUser!.tel;
        _passwordController.text = currentUser!.mdp;
      });
    }
  }

  // Méthode pour sélectionner une nouvelle image de profil
  Future<void> _selectImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        newImageFile = File(pickedFile.path);
      });
    }
  }

  // Méthode pour mettre à jour les informations de l'utilisateur, y compris l'image
  Future<void> _updateUserDetails() async {
    try {
      if (_formKey.currentState!.validate()) {
        // Récupérer les nouvelles informations
        String? newPassword = _passwordController.text.isNotEmpty
            ? _passwordController.text
            : null;

        await utilisateurService.updateUtilisateurWithImageAndAuth(
          currentUser!,
          newEmail: _emailController.text,
          newPassword: newPassword,
          newImageFile: newImageFile, // Envoie le nouveau fichier d'image s'il est sélectionné
        );

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Informations modifiées avec succès !'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la modification des informations : $e'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCurrentUser(); // Charger les données de l'utilisateur connecté dès l'initialisation
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile header
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: const Color(0xff0B8FAC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'Profil',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 100, // Ajuste cette valeur pour contrôler le chevauchement
                    child: GestureDetector(
                      onTap: _selectImage, // Sélectionner une nouvelle image au clic
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white, // Bordure blanche autour du cercle
                            width: 4,
                          ),
                          image: DecorationImage(
                            image: newImageFile != null 
                                ? FileImage(newImageFile!)
                                : NetworkImage(
                                    currentUser != null 
                                    ? 'https://firebasestorage.googleapis.com/v0/b/access-ability-9faa7.appspot.com/o/utilisateurs%2F${currentUser!.id}%2Fprofile.jpg?alt=media'
                                    : 'https://example.com/default_profile.png',
                                  ) as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Name field
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        hintText: "Prénom et Nom",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre nom";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Email field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        hintText: "Adresse mail",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Password field (modifiable)
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_passwordVisible, // Toggle visibility
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: "Nouveau mot de passe",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre nouveau mot de passe";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Address field
                    TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.home),
                        hintText: "Adresse",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre adresse";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Phone field
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.phone),
                        hintText: "Téléphone",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez entrer votre téléphone";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    // Modify button
                    SizedBox(
                      // width: double.infinity,
                      // height: 60,
                      child:CustomButton(
                  text: 'Mettre à jour',
                  backgroundColor: const Color(0xff0957DE), 
                  textColor: Colors.white,
                  icon: Icons.arrow_forward,
                  onPressed: () {
                     _updateUserDetails();
                  },
                ),
                    ),
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
