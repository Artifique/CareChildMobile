// ignore_for_file: use_build_context_synchronously

import 'package:accessability/Services/rendez-vous_service.dart';
import 'package:accessability/Services/enfant_service.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:accessability/Modele/enfant_modele.dart'; // Importez votre modèle d'enfant
import 'package:accessability/Modele/utilisateur_modele.dart'; // Importez votre modèle d'utilisateur

class RendezvousSpecialiste extends StatefulWidget {
  final String motif;
  final Color bg;
  final String date;
  final String heure;
  final String docteur;
  final String role;
  final String imagePath;
  final double long;
  final double larg;
  final Color textcolor;
  final String idRendezVous; // Ajoutez l'ID du rendez-vous
  final String initialStatus; // Ajoutez le statut initial

  const RendezvousSpecialiste({
    Key? key,
    required this.motif,
    required this.bg,
    required this.date,
    required this.heure,
    required this.docteur,
    required this.role,
    required this.imagePath,
    required this.long,
    required this.larg,
    required this.textcolor,
    required this.idRendezVous,
    required this.initialStatus,
  }) : super(key: key);

  @override
  _RendezvousSpecialisteState createState() => _RendezvousSpecialisteState();
}

class _RendezvousSpecialisteState extends State<RendezvousSpecialiste> {
  late String status;
  final rendezVousService = RendezVousService();
  final enfantService = EnfantService();
  final utilisateurService = UtilisateurService();

  String? newDate;
  String? newHeure;

  @override
  void initState() {
    super.initState();
    status = widget.initialStatus;
  }

  // Méthode pour afficher les infos de l'enfant et du parent dans un showDialog
  Future<void> _showEnfantAndParentInfoDialog(BuildContext context, Enfant enfant, Utilisateur parent) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informations de l\'enfant et du parent'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nom de l\'enfant: ${enfant.nom}'),
                Text('Âge: ${enfant.age}'),
                Text('Handicap: ${enfant.typeHandicap}'),
                Text('Diagnostic: ${enfant.diagnostic}'),
                Text('BesoinsEducatifs: ${enfant.besoinsEducatifs}'),
                const SizedBox(height: 10),
                Text('Nom du parent: ${parent.nom}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Méthode pour gérer le clic sur la carte (afficher infos enfant et parent)
  Future<void> _handleCardTap() async {
    try {
      // Récupérer l'ID de l'enfant à partir du rendez-vous
      final String? enfantId = await rendezVousService.getEnfantIdByRendezVousId(widget.idRendezVous);

      // Récupérer l'ID du parent à partir du rendez-vous
      final String? parentId = await rendezVousService.getParentIdByRendezVousId(widget.idRendezVous);

      if (enfantId != null && parentId != null) {
        // Si les ID sont trouvés, récupérer les informations de l'enfant et du parent
        final Enfant? enfant = await enfantService.getEnfantById(enfantId);
        final Utilisateur? parent = await utilisateurService.getUtilisateurById(parentId);

        if (enfant != null && parent != null) {
          // Afficher les informations de l'enfant et du parent dans un showDialog
          _showEnfantAndParentInfoDialog(context, enfant, parent);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enfant ou parent non trouvé')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aucun enfant ou parent associé à ce rendez-vous')),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des informations : $e');
      }
    }
  }

  Future<void> _handleTakeButtonTap() async {
    if (status == 'en attente') {
      await rendezVousService.prendreEnCharge(widget.idRendezVous);
      setState(() {
        status = 'en charge'; // Mettez à jour le statut
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rendez-vous pris en charge avec succès')),
      );
    }
  }

  Future<void> _showReportDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reporter le rendez-vous'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(), // Empêche la sélection de dates passées
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      newDate = "${pickedDate.toLocal()}".split(' ')[0]; // Format YYYY-MM-DD
                    });
                  }
                },
                child: const Text('Choisir une nouvelle date'),
              ),
              if (newDate != null) Text("Date choisie: $newDate"),
              TextButton(
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      newHeure = "${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}"; // Format HH:MM
                    });
                  }
                },
                child: const Text('Choisir une nouvelle heure'),
              ),
              if (newHeure != null) Text("Heure choisie: $newHeure"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                if (newDate != null && newHeure != null) {
                  // Mettre à jour le rendez-vous avec la nouvelle date et heure
                  Map<String, dynamic> nouvellesInformations = {
                    'date': newDate, // Nouvelle date
                    'heure': newHeure, // Nouvelle heure
                    'motif': widget.motif, // Nouveau motif
                    'status': 'en attente'
                  };

                  await rendezVousService.mettreAJourRendezVous(widget.idRendezVous, nouvellesInformations);
                  
                  setState(() {
                    status = 'en attente'; // Mettez à jour le statut
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rendez-vous reporté avec succès')),
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez sélectionner une date et une heure')),
                  );
                }
              },
              child: const Text('Confirmer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleFinishButtonTap() async {
    if (status == 'en charge') {
      await rendezVousService.Terminer(widget.idRendezVous);
      setState(() {
        status = 'terminé'; // Mettez à jour le statut
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rendez-vous terminé avec succès')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleCardTap, // Utilisez cette méthode pour gérer le clic sur la carte
      child: Container(
        width: widget.larg,
        height: widget.long,
        decoration: BoxDecoration(
          color: widget.bg,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.motif,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.textcolor,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.date,
                        style: TextStyle(
                          color: widget.textcolor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Color.fromARGB(255, 0, 0, 0),
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.heure,
                        style: TextStyle(
                          color: widget.textcolor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: widget.imagePath.isNotEmpty
                        ? NetworkImage(widget.imagePath)
                        : const AssetImage('images/default_profil.png') as ImageProvider,
                  ),
                  const SizedBox(width: 10),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.docteur,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: widget.textcolor,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            widget.role,
                            style: TextStyle(
                              fontSize: 12,
                              color: widget.textcolor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: status == 'en attente' ? _handleTakeButtonTap : _showReportDialog,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xff0B8FAC),
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            status == 'en attente' ? 'Prendre' : 'Reporter',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _handleFinishButtonTap,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xff0B8FAC),
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Text(
                            'Terminer',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
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
