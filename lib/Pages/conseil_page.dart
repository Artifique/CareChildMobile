// ignore_for_file: library_private_types_in_public_api

import 'package:accessability/Modele/enfant_modele.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:accessability/Widgets/bouton.dart';
import 'package:accessability/Services/conseil_service.dart';
import 'package:accessability/Modele/conseil_modele.dart';

// ignore: use_key_in_widget_constructors
class AjouterConseilPage extends StatefulWidget {
  final Enfant enfant;
  final Utilisateur? parent;

  // ignore: use_super_parameters
  const AjouterConseilPage({Key? key, required this.enfant, this.parent}) : super(key: key);

  @override
  _AjouterConseilPageState createState() => _AjouterConseilPageState();
}

class _AjouterConseilPageState extends State<AjouterConseilPage> {
  final ConseilService _conseilService = ConseilService();
  Utilisateur? currentUser;
  final UtilisateurService _utilisateurService = UtilisateurService();
  final TextEditingController _contenuController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _fetchCurrentUser() async {
    Utilisateur? user = await _utilisateurService.getCurrentUtilisateur();
    if (user != null) {
      setState(() {
        currentUser = user;
        if (kDebugMode) {
          print(currentUser?.nom);
        }
      });
    }
  }

  void _submitConseil() async {
    if (_formKey.currentState?.validate() ?? false) {
      final conseil = Conseil(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        idParent: widget.parent?.id ?? 'unknown', // Utiliser l'ID du parent
        idSpecialiste: currentUser?.id ?? 'unknown', // ID spécialiste dynamique
        contenu: _contenuController.text,
        dateConseil: DateTime.now(), idEnfant: widget.enfant.id,
      );

      try {
        await _conseilService.addConseil(conseil);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Conseil envoyé avec succès à ${widget.parent?.nom} !')),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30, left: 18),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xff0B8FAC),
                      ),
                      child: const Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Conseil',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 70),
                decoration: const BoxDecoration(
                  color: Color(0xff0B8FAC),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Contenu du Conseil',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _contenuController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              labelText: 'Votre conseil',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.all(16),
                            ),
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer le contenu du conseil.';
                              }
                              return null;
                            },
                          ),
                          
                          const SizedBox(height: 20),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: CustomButton(
                                text: 'Ajouter le Conseil',
                                backgroundColor: const Color.fromARGB(255, 3, 107, 177),
                                textColor: Colors.white,
                                icon: Icons.arrow_forward,
                                onPressed: () {
                                  _submitConseil();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}