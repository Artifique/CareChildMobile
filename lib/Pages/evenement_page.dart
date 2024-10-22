// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:accessability/Modele/evenement_modele.dart';
import 'package:accessability/Modele/inscription_modele.dart';
import 'package:accessability/Services/evenement_service.dart';
import 'package:accessability/Services/inscription_service.dart';
import 'package:accessability/Services/utilisateur_service.dart'; // Import du service utilisateur
import 'package:accessability/Modele/utilisateur_modele.dart'; // Import du modèle utilisateur

// ignore: use_key_in_widget_constructors
class EvenementPage extends StatefulWidget {
  @override
  _EvenementPageState createState() => _EvenementPageState();
}

class _EvenementPageState extends State<EvenementPage> {
  final EvenementService _evenementService = EvenementService();
  final InscriptionService _inscriptionService = InscriptionService();
  final UtilisateurService _utilisateurService = UtilisateurService(); // Instance du service utilisateur

  List<Evenement> _evenements = [];
  bool _isLoading = true;
  Utilisateur? _currentUtilisateur; // Utilisateur connecté

  @override
  void initState() {
    super.initState();
    _loadEvenements();
    _loadCurrentUtilisateur();
  }

  // Méthode pour charger l'utilisateur connecté
  Future<void> _loadCurrentUtilisateur() async {
    try {
      Utilisateur? utilisateur = await _utilisateurService.getCurrentUtilisateur();
      setState(() {
        _currentUtilisateur = utilisateur;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la récupération de l\'utilisateur connecté : $e'),
      ));
    }
  }

  // Méthode pour charger les événements
  Future<void> _loadEvenements() async {
    try {
      List<Evenement> evenements = await _evenementService.getEvenements();
      setState(() {
        _evenements = evenements;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors du chargement des événements : $e'),
      ));
    }
  }

  // Méthode pour s'inscrire à un événement
Future<void> _inscrireEvenement(Evenement evenement) async {
  try {
    if (_currentUtilisateur == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Utilisateur non connecté'),
      ));
      return;
    }

    // Vérifier si l'utilisateur est déjà inscrit
    List<Inscription> inscriptions = await _inscriptionService.getInscriptionsByParent(_currentUtilisateur!.id);
    bool alreadyRegistered = inscriptions.any((inscription) => inscription.idEvent == evenement.id);

    if (alreadyRegistered) {
      // Si l'utilisateur est déjà inscrit, afficher un message
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Vous êtes déjà inscrit à cet événement.'),
      ));
      return;
    }

    // Création d'une nouvelle inscription avec l'utilisateur connecté
    Inscription inscription = Inscription(
      idParent: _currentUtilisateur!.id, // Utilise l'ID de l'utilisateur connecté
      idEvent: evenement.id,
    );

    await _inscriptionService.inscrireParent(inscription);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Inscription réussie à l\'événement ${evenement.titre}'),
    ));
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Erreur lors de l\'inscription : $e'),
    ));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        leading: GestureDetector(
               onTap: () {
             Navigator.pop(context); // Retour en arrière
             },
             child: Container(
               padding: const EdgeInsets.all(10),
               width: 25,
               height: 25,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(16),
                 color: const Color( 0xff0B8FAC),
               ),
               child:const Icon(
                 Icons.chevron_left,
                color:Colors.white,
                size: 36,
              ),
            ),
          ),
        title: const Text('Événements'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 100),
        padding: const EdgeInsets.all(16),
        height: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          color: Color(0xff0B8FAC),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _evenements.isEmpty
                ? const Center(child: Text('Aucun événement disponible.'))
                : ListView.builder(
                    itemCount: _evenements.length,
                    itemBuilder: (context, index) {
                      Evenement evenement = _evenements[index];
                      return Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white, // Couleur de fond
                          borderRadius: BorderRadius.circular(12), // Ajoute un peu de courbure
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.7), // Couleur de l'ombre
                              spreadRadius: 2, // Combien l'ombre s'étend
                              blurRadius: 8, // Douceur de l'ombre
                              offset: const Offset(4, 4), // Décalage de l'ombre
                            ),
                          ],
                        ),
                        child: ListTile(
                          title: Text(evenement.titre),
                          subtitle: Column(
                            children: [
                              Text(evenement.description),
                              // Text(evenement.heure as String),
                            ],
                          ),
                        
                          trailing: ElevatedButton(
                            onPressed: () => _inscrireEvenement(evenement),
                            child: const Text('S\'inscrire'),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
