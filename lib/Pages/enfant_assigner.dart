// ignore_for_file: use_build_context_synchronously

import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:flutter/material.dart';
import 'package:accessability/Modele/enfant_modele.dart';
import 'package:accessability/Modele/assignation_modele.dart'; // Modèle pour les assignations
import 'package:accessability/Services/assignation_service.dart'; // Service pour récupérer les assignations
import 'package:accessability/Services/utilisateur_service.dart'; // Service utilisateur
import 'package:accessability/Services/enfant_service.dart'; // Importer le service enfant
import 'package:accessability/Widgets/enfant_widget.dart'; // Importer le widget EnfantWidget

// ignore: use_key_in_widget_constructors
class EnfantAssigner extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _EnfantAssignerState createState() => _EnfantAssignerState();
}

class _EnfantAssignerState extends State<EnfantAssigner> {
  final AssignationService _assignationService = AssignationService();
  final UtilisateurService _utilisateurService = UtilisateurService();
  final EnfantService _enfantService = EnfantService();

  List<Enfant> _enfants = [];
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
        await _loadEnfantsBySpecialiste(_currentUtilisateur!.id);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la récupération de l\'utilisateur connecté : $e'),
      ));
    }
  }

  Future<void> _loadEnfantsBySpecialiste(String idSpecialiste) async {
    try {
      List<Assignation> assignations = await _assignationService.getAssignationsBySpecialiste(idSpecialiste);
      List<Enfant> enfants = [];

      for (var assignation in assignations) {
        Enfant? enfant = await _fetchEnfantById(assignation.idEnfant);
        if (enfant != null) {
          enfants.add(enfant);
        }
      }

      setState(() {
        _enfants = enfants;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la récupération des enfants : $e'),
      ));
    }
  }

  Future<Enfant?> _fetchEnfantById(String idEnfant) async {
    return await _enfantService.getEnfantById(idEnfant);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(left: 12.0, top: 5,bottom: 5), // Ajout d'un margin à gauche
       
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(5), // Réduction de la taille
              width: 20, // Réduction de la taille
              // height: 10, // Réduction de la taille
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
        title: const Text('Enfants Assignés'),
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
            : _enfants.isEmpty
                ? const Center(child: Text('Aucun enfant assigné.'))
                : ListView.builder(
                    itemCount: _enfants.length,
                    itemBuilder: (context, index) {
                      Enfant enfant = _enfants[index];
                      return EnfantWidget(
                        enfant: enfant,
                        bg: Colors.white,
                        long: 150,
                        larg: double.infinity,
                        textColor: Colors.black,
                        currentUserId: _currentUtilisateur!.id,
                      );
                    },
                  ),
      ),
    );
  }
}