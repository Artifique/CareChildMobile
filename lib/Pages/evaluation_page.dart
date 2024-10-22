// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'package:accessability/Widgets/bouton.dart';
import 'package:flutter/material.dart';
import 'package:accessability/Services/evaluation_service.dart';
import 'package:accessability/Modele/evaluation_modele.dart';

class EvaluationPage extends StatefulWidget {
  final String enfantId; // ID de l'enfant à évaluer
  final String specialisteId; // ID du spécialiste

  const EvaluationPage({Key? key, required this.enfantId, required this.specialisteId}) : super(key: key);

  @override
  _EvaluationPageState createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  final EvaluationService _evaluationService = EvaluationService();
  final TextEditingController _commentairesController = TextEditingController();
  final TextEditingController _recommandationsController = TextEditingController(); // Nouveau contrôleur

  void _submitEvaluation() {
    final evaluation = Evaluation(
      id: DateTime.now().millisecondsSinceEpoch.toString(), // Générer un ID unique
      enfantId: widget.enfantId,
      specialisteId: widget.specialisteId,
      dateEvaluation: DateTime.now(), // Toujours la date du jour
      commentaires: _commentairesController.text,
      recommandations: [_recommandationsController.text], // Ajouter les recommandations
    );

    _evaluationService.addEvaluation(evaluation).then((_) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Évaluation ajoutée avec succès !')),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Fermer la page après soumission
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.only(left: 12.0, top: 5,bottom: 5), // Ajout d'un margin à gauche
          color: Colors.white,
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
        title: const Text('Evaluations'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Color.fromARGB(25, 0, 0, 0),
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _commentairesController,
              decoration: const InputDecoration(
                labelText: 'Commentaires',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  
                  borderSide: BorderSide(color: Color(0xff0B8FAC), width: 2.0),
                ),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            Text(
              'Date d\'évaluation : ${DateTime.now().toLocal().toString().split(' ')[0]}', // Afficher la date du jour
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _recommandationsController, // Champ pour les recommandations
              decoration: const InputDecoration(
                labelText: 'Recommandations',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff0B8FAC), width: 2.0),
                ),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            Center(
              child: CustomButton(
                    text: 'Evaluer',
                    backgroundColor:const Color(0xff0B8FAC),
                    textColor: Colors.white,
                    icon: Icons.arrow_forward,
                    onPressed: () {
                      _submitEvaluation();
                     },
                   ),
            ),
          ],
        ),
      ),
    );
  }
}