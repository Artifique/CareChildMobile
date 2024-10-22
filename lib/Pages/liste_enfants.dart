// ignore_for_file: use_build_context_synchronously

import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Widgets/enfant_parent_widget.dart';
import 'package:flutter/material.dart';
import 'package:accessability/Modele/enfant_modele.dart';
import 'package:accessability/Services/utilisateur_service.dart'; // Service utilisateur
import 'package:accessability/Services/enfant_service.dart'; // Importer le service enfant

// ignore: use_key_in_widget_constructors
class ListeEnfant extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ListeEnfantState createState() => _ListeEnfantState();
}

class _ListeEnfantState extends State<ListeEnfant> {
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
        await _loadEnfantsByParentId(_currentUtilisateur!.id);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de la récupération de l\'utilisateur connecté : $e'),
      ));
    }
  }

  Future<void> _loadEnfantsByParentId(String parentId) async {
    try {
      List<Enfant> enfants = await _enfantService.getEnfantsByParentId(parentId);
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

  // Méthode pour rafraîchir la liste des enfants
  Future<void> _refreshEnfants() async {
    if (_currentUtilisateur != null) {
      await _loadEnfantsByParentId(_currentUtilisateur!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: const Text('Liste des Enfants'),
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
                : RefreshIndicator(
                    onRefresh: _refreshEnfants, // Ajout de RefreshIndicator pour rafraîchir la liste
                    child: ListView.builder(
                      itemCount: _enfants.length,
                      itemBuilder: (context, index) {
                        Enfant enfant = _enfants[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0), // Espace entre les cartes
                          child: EnfantParentWidget(
                            enfant: enfant,
                            bg: Colors.white,
                            long: 150,
                            larg: double.infinity,
                            textColor: Colors.black,
                            currentUserId: _currentUtilisateur!.id,
                             onUpdate: _refreshEnfants,
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}