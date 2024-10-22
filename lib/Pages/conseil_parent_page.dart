// ignore_for_file: use_build_context_synchronously

import 'package:accessability/Modele/conseil_modele.dart';
import 'package:accessability/Modele/enfant_modele.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Services/conseil_service.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:accessability/Widgets/conseil_wiget.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class ConseilParent extends StatefulWidget {
   final Enfant enfant;
  final Utilisateur? parent;
  const ConseilParent({Key? key, required this.enfant, this.parent}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ConseilParentState createState() => _ConseilParentState();
}

class _ConseilParentState extends State<ConseilParent> {
  final UtilisateurService _utilisateurService = UtilisateurService();
  final ConseilService _conseilService = ConseilService();

  List<Conseil> _conseils = []; // Liste pour stocker les conseils
  bool _isLoading = true;
  Utilisateur? _currentUtilisateur;

  @override
  void initState() {
    super.initState();
    _loadCurrentUtilisateur();
  }

  Future<void> _loadCurrentUtilisateur() async {
    try {
      Utilisateur? utilisateur = await _utilisateurService.getCurrentUtilisateur();
      if (utilisateur != null) {
        _currentUtilisateur = utilisateur;
        await _fetchConseilsByParentId(); // Récupérer les conseils après avoir chargé l'utilisateur
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la récupération de l\'utilisateur connecté : $e'),
      ));
    }
  }

  Future<void> _fetchConseilsByParentId() async {
    try {
      List<Conseil> conseils = await _conseilService.getConseilsByEnfant(widget.enfant.id);
      setState(() {
        _conseils = conseils;
        _isLoading = false; // Arrêter le chargement une fois que les données sont récupérées
      });
        } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la récupération des conseils : $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(left: 12.0, top: 5, bottom: 5), // Ajout d'un margin à gauche
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(5), // Réduction de la taille
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xff0B8FAC),
              ),
              child: const Icon(
                Icons.chevron_left,
                color: Colors.white,
                size: 35, // Réduction de la taille de l'icône
              ),
            ),
          ),
        ),
        title: const Text('Conseils'),
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
            : _conseils.isEmpty
                ? const Center(child: Text('Aucun conseil disponible.'))
                : ListView.builder(
                    itemCount: _conseils.length,
                    itemBuilder: (context, index) {
                      Conseil conseil = _conseils[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0), // Ajout d'espace entre les cartes
                        child: ConseilWidget(
                          conseil: conseil,
                          bg: Colors.white,
                          long: 150,
                          larg: double.infinity,
                          textColor: Colors.black,
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}