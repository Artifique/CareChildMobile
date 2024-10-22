import 'package:accessability/Modele/conseil_modele.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:flutter/material.dart';
import 'package:accessability/Services/utilisateur_service.dart'; // Importez le service utilisateur

class ConseilWidget extends StatefulWidget {
  final Conseil conseil; // Recevoir l'objet Conseil
  final Color bg;
  final double long;
  final double larg;
  final Color textColor;

  const ConseilWidget({
    Key? key,
    required this.conseil,
    required this.bg,
    required this.long,
    required this.larg,
    required this.textColor,
  }) : super(key: key);

  @override
  _ConseilWidgetState createState() => _ConseilWidgetState();
}

class _ConseilWidgetState extends State<ConseilWidget> {
  Utilisateur? _specialiste; // Stocker les informations du spécialiste

  @override
  void initState() {
    super.initState();
    _fetchSpecialisteInfo(); // Récupérer les informations du spécialiste au démarrage
  }

  Future<void> _fetchSpecialisteInfo() async {
    UtilisateurService utilisateurService = UtilisateurService(); // Instancier le service utilisateur
    Utilisateur? specialiste = await utilisateurService.getUtilisateurById(widget.conseil.idSpecialiste);
    setState(() {
      _specialiste = specialiste; // Mettre à jour l'état avec les infos du spécialiste
    });
  }

  void _showConseilDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Détails du Conseil"),
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
                Text("Contenu: ${widget.conseil.contenu}"),
                Text("Date: ${widget.conseil.dateConseil}"),
                Text("Spécialiste: ${_specialiste?.nom ?? 'Chargement...'}"), // Afficher le nom du spécialiste
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0B8FAC),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  onPressed: () {
                    // Ajoutez la navigation vers EvaluationPage ou Progression ici si nécessaire.
                  },
                  child: const Text('Actions', style: TextStyle(color: Colors.white)),
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
      onTap: () => _showConseilDetails(context),
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
              // Text(
              //   'Conseil ID: ${widget.conseil.id}',
              //   style: TextStyle(
              //     fontSize: 15,
              //     fontWeight: FontWeight.bold,
              //     color: widget.textColor,
              //   ),
              // ),
              const SizedBox(height: 7),
              Text(
                "Contenu: ${widget.conseil.contenu}",
                style: TextStyle(
                  fontSize: 12,
                  color: widget.textColor,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                "Date: ${widget.conseil.dateConseil}",
                style: TextStyle(
                  fontSize: 12,
                  color: widget.textColor,
                ),
              ),
              Text(
                "Specialiste: ${_specialiste?.nom ?? 'Chargement...'}",
                style: TextStyle(
                  fontSize: 12,
                  color: widget.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
