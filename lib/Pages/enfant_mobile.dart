import 'package:accessability/Modele/enfant_modele.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Services/enfant_service.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:accessability/Widgets/bouton.dart';
import 'package:flutter/material.dart';

class EnfantMobile extends StatefulWidget {
  const EnfantMobile({super.key});

  @override
  State<EnfantMobile> createState() => _EnfantMobileState();
}

class _EnfantMobileState extends State<EnfantMobile> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _diagnosticController = TextEditingController();
  final TextEditingController _besoinsEducatifsController = TextEditingController();
  final TextEditingController _observationController = TextEditingController();

  String? _selectedHandicap; // Variable pour le type de handicap
  String? _currentUserId; // Pour stocker l'ID du parent actuel
  final UtilisateurService _utilisateurService = UtilisateurService(); // Instance de UtilisateurService
  final EnfantService _enfantService = EnfantService(); // Instance de EnfantService

  @override
  void initState() {
    super.initState();
    _fetchCurrentUserId(); // Récupérer l'ID de l'utilisateur actuel
  }

  Future<void> _fetchCurrentUserId() async {
    Utilisateur? currentUser = await _utilisateurService.getCurrentUtilisateur();

    if (currentUser != null) {
      _currentUserId = currentUser.id;
    } else {
      _currentUserId = null;
    }

    setState(() {});
  }

  @override
  void dispose() {
    _nomController.dispose();
    _ageController.dispose();
    _diagnosticController.dispose();
    _besoinsEducatifsController.dispose();
    _observationController.dispose();
    super.dispose();
  }

  Future<void> _registerChild() async {
    if (_nomController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _selectedHandicap != null &&
        _diagnosticController.text.isNotEmpty &&
        _besoinsEducatifsController.text.isNotEmpty &&
        _observationController.text.isNotEmpty) {
      
      final enfant = Enfant(
        id: '',
        nom: _nomController.text,
        age: _ageController.text,
        typeHandicap: _selectedHandicap!,
        parentId: _currentUserId!,
        diagnostic: _diagnosticController.text,
        besoinsEducatifs: _besoinsEducatifsController.text.split(','),
        observationComportementale: _observationController.text,
      );

      await _enfantService.creerEnfant(enfant);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enfant enregistré avec succès!')),
      );

      _nomController.clear();
      _ageController.clear();
      _diagnosticController.clear();
      _besoinsEducatifsController.clear();
      _observationController.clear();
      setState(() {
        _selectedHandicap = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView( // Ajout d'un SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 25),
                // Champ Nom
                TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(
                    labelText: 'Nom Complet',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // Champ Age
                TextField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Âge',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // Dropdown pour le type de handicap
                DropdownButtonFormField<String>(
                  value: _selectedHandicap,
                  hint: const Text('Sélectionnez le type de handicap'),
                  items: const [
                    DropdownMenuItem(value: 'sourd', child: Text('Sourd')),
                    DropdownMenuItem(value: 'muet', child: Text('Muet')),
                    DropdownMenuItem(value: 'sourd muet', child: Text('Sourd Muet')),
                    DropdownMenuItem(value: 'autiste', child: Text('Autiste')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedHandicap = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    prefixIcon: Icon(Icons.accessibility),
                  ),
                ),
                const SizedBox(height: 25),
                // Champ Diagnostic
                TextField(
                  controller: _diagnosticController,
                  decoration: const InputDecoration(
                    labelText: 'Diagnostic',
                    prefixIcon: Icon(Icons.medical_services),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // Champ Besoins Éducatifs
                TextField(
                  controller: _besoinsEducatifsController,
                  decoration: const InputDecoration(
                    labelText: 'Besoins Éducatifs (séparés par des virgules)',
                    prefixIcon: Icon(Icons.school),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                // Champ Observation Comportementale
                TextField(
                  controller: _observationController,
                  decoration: const InputDecoration(
                    labelText: 'Observation Comportementale',
                    prefixIcon: Icon(Icons.comment),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                          CustomButton(
                            text: 'Ajouter',
                            backgroundColor:const Color(0xff0957DE), 
                            textColor: Colors.white,
                            icon: Icons.arrow_forward,
                            onPressed: () {
                               _registerChild();
                            },
                          ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}