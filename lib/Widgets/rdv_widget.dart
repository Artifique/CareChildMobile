import 'package:accessability/Modele/enfant_modele.dart'; // Importez votre modèle d'enfant
import 'package:accessability/Services/enfant_service.dart'; // Importez le service pour enfant
import 'package:accessability/Services/rendez-vous_service.dart';
import 'package:flutter/material.dart';

class RendezvousWidget extends StatefulWidget {
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

  const RendezvousWidget({
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
    required this.idRendezVous, // Initialisez l'ID
    required this.initialStatus, // Initialisez le statut
  }) : super(key: key);

  @override
  _RendezvousWidgetState createState() => _RendezvousWidgetState();
}

class _RendezvousWidgetState extends State<RendezvousWidget> {
  late String status;

  @override
  void initState() {
    super.initState();
    status = widget.initialStatus; // Initialiser le statut depuis le widget
  }

  // Méthode pour afficher les infos de l'enfant dans un showDialog
  Future<void> _showEnfantInfoDialog(BuildContext context, Enfant enfant) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Informations de l\'enfant'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nom: ${enfant.nom}'),
                Text('Âge: ${enfant.age}'),
                 Text('Handicap: ${enfant.typeHandicap}'),
                Text('Diagnostic: ${enfant.diagnostic}'),          
                Text('BesoinsEducatifs: ${enfant.besoinsEducatifs}'),
                
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

  // Méthode pour gérer le clic sur la carte (afficher infos enfant)
  Future<void> _handleCardTap() async {
    final rendezVousService = RendezVousService();
    final enfantService = EnfantService();

    // Récupérer l'ID de l'enfant à partir du rendez-vous
    final String? enfantId = await rendezVousService.getEnfantIdByRendezVousId(widget.idRendezVous);

    if (enfantId != null) {
      // Si l'ID de l'enfant est trouvé, récupérer les informations de l'enfant
      final Enfant? enfant = await enfantService.getEnfantById(enfantId);
      
      if (enfant != null) {
        // Afficher les informations de l'enfant dans un showDialog
        _showEnfantInfoDialog(context, enfant);
      } else {
        // Afficher un message si l'enfant n'est pas trouvé
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enfant non trouvé')),
        );
      }
    } else {
      // Afficher un message si l'ID de l'enfant n'est pas trouvé
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucun enfant associé à ce rendez-vous')),
      );
    }
  }

  // Méthode pour gérer l'annulation et la mise en attente du rendez-vous
 // Méthode pour gérer l'annulation et la mise en attente du rendez-vous
Future<void> _handleButtonTap() async {
  final rendezVousService = RendezVousService();

  // Afficher un showDialog de confirmation avant l'annulation
  bool? confirmation = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Êtes-vous sûr de vouloir annuler ce rendez-vous ?'),
        actions: <Widget>[
          TextButton(
            child: const Text('Non'),
            onPressed: () {
              Navigator.of(context).pop(false); // Retourne "false" si l'utilisateur refuse
            },
          ),
          TextButton(
            child: const Text('Oui'),
            onPressed: () {
              Navigator.of(context).pop(true); // Retourne "true" si l'utilisateur confirme
            },
          ),
        ],
      );
    },
  );

  // Si l'utilisateur confirme l'annulation
  if (confirmation == true) {
    if (status == 'annulé') {
      // Si le statut est 'annulé', appelez la méthode mettreEnAttente
      await rendezVousService.mettreEnAttente(widget.idRendezVous);
      setState(() {
        status = 'en attente'; // Mettez à jour le statut
      });
      // Montrez un message après la mise en attente
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rendez-vous mis en attente avec succès')),
      );
    } else {
      // Sinon, annulez le rendez-vous
      await rendezVousService.annulerRendezVous(widget.idRendezVous);
      setState(() {
        status = 'annulé'; // Mettez à jour le statut
      });
      // Montrez un message après l'annulation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rendez-vous annulé avec succès')),
      );
    }
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
              // Titre de l'événement
              Text(
                widget.motif,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: widget.textcolor,
                ),
              ),
              const SizedBox(height: 10),
              // Heure de l'événement
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
              // Informations du docteur
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
                      const SizedBox(width: 60),
                      GestureDetector(
                        onTap: _handleButtonTap, // Utilisez la méthode pour gérer le tap du bouton
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xff0B8FAC),
                            borderRadius: const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Text(
                            status == 'annulé' ? 'Prendre' : 'Annuler',
                            style: const TextStyle(
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
