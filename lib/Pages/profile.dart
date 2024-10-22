// ignore_for_file: use_build_context_synchronously

import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Pages/add_ressources.dart';
import 'package:accessability/Pages/login.dart';
import 'package:accessability/Pages/modifier_profile.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:accessability/Widgets/bouton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Utilisateur? currentUser; // Variable pour stocker les infos de l'utilisateur

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    Utilisateur? utilisateur = await UtilisateurService().getCurrentUtilisateur();
    setState(() {
      currentUser = utilisateur;
    });
  }

  Future<void> _logout() async {
    // Afficher un dialog de confirmation avant de se déconnecter
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Ferme le dialog
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Ferme le dialog
                try {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                } catch (e) {
                  if (kDebugMode) {
                    print('Erreur lors de la déconnexion : $e');
                  }
                }
              },
              child: const Text('Déconnexion'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  // Conteneur bleu
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Color(0xff0B8FAC),
                      borderRadius: BorderRadius.all(Radius.circular(17)),
                    ),
                    child: const Center(
                      child: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Cercle avec l'avatar
                  Positioned(
                    top: 130,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 4,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(
                            currentUser != null
                                ? 'https://firebasestorage.googleapis.com/v0/b/access-ability-9faa7.appspot.com/o/utilisateurs%2F${currentUser!.id}%2Fprofile.jpg?alt=media'
                                : 'https://example.com/default_profile.png',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 70),

              // Affiche les informations de l'utilisateur si disponibles
              if (currentUser != null) ...[
                Text(
                  currentUser!.nom,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Email : ${currentUser!.email}',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  height: 250,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 211, 206, 206),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Informations de profil',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Ville : ${currentUser!.adresse}',
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      
                      const SizedBox(height: 10),
                      Column(
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.49,
                            height: 60,
                            child: MonButton(
                              const Color(0xff0957DE), 
                              Colors.white,
                              'Modifier',
                              Icons.arrow_forward,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const ModifierProfile()),
                                );
                              },
                            ),
                          ),
                           const SizedBox(height: 5),
                      // Ajouter le bouton "Ajouter Ressource" si le rôle n'est pas 'PARENT'
                      if (currentUser!.role != 'PARENT') ...[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.53,
                          height: 60,
                          child: MonButton(
                           const Color(0xff0957DE), 
                            Colors.white,
                            'Ressource',
                            Icons.add,
                            () {
                             Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddRessources()),
                                );
                            },
                          ),
                        ),
                      ],
                        ],
                      ),
                     
                    ],
                  ),
                ),
              ] else
                const Center(child: CircularProgressIndicator()), // Affiche un indicateur de chargement
              
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 65,
                    child: MonButton(
                  const Color(0xff0957DE), 
                      const Color.fromARGB(255, 255, 255, 255),
                      '',
                      Icons.logout,
                      () { _logout(); },
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 65,
                    child: MonButton(
                      Colors.red,
                      Colors.white,
                      'SOS',
                      Icons.dangerous,
                      () {
                        // Action lorsque le bouton est pressé
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}