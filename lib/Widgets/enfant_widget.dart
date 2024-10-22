import 'package:accessability/Modele/enfant_modele.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Pages/evaluation_page.dart';
import 'package:accessability/Pages/progression.dart';

import 'package:accessability/Services/utilisateur_service.dart';
import 'package:flutter/material.dart';

class EnfantWidget extends StatelessWidget {
  final Enfant enfant; // Recevoir l'objet Enfant
  final Color bg;
  final double long;
  final double larg;
  final Color textColor;
  final UtilisateurService _utilisateurService = UtilisateurService(); // Instanciation du service utilisateur
  final String currentUserId; // ID du spécialiste

  // ignore: use_super_parameters
  EnfantWidget({
    Key? key,
    required this.enfant,
    required this.bg,
    required this.long,
    required this.larg,
    required this.textColor,
    required this.currentUserId,
  }) : super(key: key);

void _showEnfantDetails(BuildContext context) async {
  // Récupération de l'utilisateur (parent) par ID
  Utilisateur? parent = await _utilisateurService.getUtilisateurById(enfant.parentId);

  showDialog(
    // ignore: use_build_context_synchronously
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(enfant.nom),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer le dialogue
              },
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Âge: ${enfant.age}"),
              Text("Type de handicap: ${enfant.typeHandicap}"),
              Text("Diagnostic: ${enfant.diagnostic}"),
              Text("Besoins éducatifs: ${enfant.besoinsEducatifs.join(", ")}"),
              Text("Observations: ${enfant.observationComportementale}"),
              const SizedBox(height: 10),
              if (parent != null) ...[
                Text("Nom du parent: ${parent.nom}"),
                Text("Email du parent: ${parent.email}"),
              ],
              const SizedBox(height: 10),
              // Bouton pour évaluer l'enfant
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0B8FAC), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7), 
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EvaluationPage(
                        enfantId: enfant.id,
                        specialisteId: currentUserId,
                      ),
                    ),
                  );
                },
                child: const Text('Évaluer cet enfant', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 10),
              // Bouton pour voir le progrès
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0B8FAC), 
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Progression(
                        enfant: enfant, // Passer l'enfant à la page Progression
                        parent: parent, // Passer le parent à la page Progression
                      ),
                    ),
                  );
                },
                child: const Text('Voir le progrès', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEnfantDetails(context),
      child: Container(
        width: larg,
        height: long,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 88, 87, 87),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0.0, 5.0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    enfant.nom,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "Âge: ${enfant.age}",
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "Type de handicap: ${enfant.typeHandicap}",
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "Diagnostic: ${enfant.diagnostic}",
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor,
                    ),
                  ),
                ],
              ),
              const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage('images/garcon.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}