import 'package:accessability/Modele/creneau_modele.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Services/disponibilite_service.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:accessability/Widgets/bouton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: use_key_in_widget_constructors
class CreneauPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _CreneauPageState createState() => _CreneauPageState();
}

class _CreneauPageState extends State<CreneauPage> {
  DateTime _selectedDay = DateTime.now();
  String? _heureDebutSelectionnee;
  String? _heureFinSelectionnee;
  int _nombreConsultationsMax = 5; // Valeur par défaut

  final DisponibiliteService _disponibiliteService = DisponibiliteService();
  final UtilisateurService _utilisateurService = UtilisateurService();
  List<Disponibilite> _disponibilites = []; // Liste des disponibilités

  // Fonction pour générer une liste d'heures
  List<String> _genererHeures() {
    List<String> heures = [];
    for (int i = 0; i < 24; i++) {
      heures.add(DateFormat('HH:mm').format(DateTime(0, 0, 0, i)));
    }
    return heures;
  }

  // Vérifie si une heure est disponible
  bool _estHeureDisponible(String heure) {
    if (_disponibilites.isEmpty) return true; // Si aucune disponibilité, retourner disponible

    // Vérifier si l'heure sélectionnée est déjà utilisée
    return _disponibilites.every((dispo) {
      DateTime start = DateTime.parse('${dispo.joursDisponibilite.first} ${dispo.heureDebut}');
      DateTime end = DateTime.parse('${dispo.joursDisponibilite.first} ${dispo.heureFin}');
      DateTime heureSelected = DateFormat('HH:mm').parse(heure);

      return !(heureSelected.isAfter(start) && heureSelected.isBefore(end));
    });
  }

  @override
  void initState() {
    super.initState();
    _chargerDisponibilites();
  }

  // Charger les disponibilités
  Future<void> _chargerDisponibilites() async {
    Utilisateur? currentUtilisateur = await _utilisateurService.getCurrentUtilisateur();
    String specialisteId = currentUtilisateur?.id ?? '';
    
    // Récupérer les disponibilités du spécialiste pour la date sélectionnée
    String dateSelectionnee = DateFormat('yyyy-MM-dd').format(_selectedDay);
    _disponibilites = await _disponibiliteService.recupererDisponibilitesParJour(specialisteId, dateSelectionnee);
    setState(() {});
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white ,
      leading: Container(
        margin: const EdgeInsets.only(left: 12.0, top: 5, bottom: 5), // Ajout d'un margin à gauche
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.all(5), // Réduction de la taille
            width: 20, // Réduction de la taille
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
      title: const Text('Créneau'),
    ),
    backgroundColor: Colors.white,  // Définition du fond blanc
    body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Calendrier
          TableCalendar(
            firstDay: DateTime.now(), // Empêche la sélection de dates passées
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _chargerDisponibilites(); // Charger les disponibilités lors de la sélection d'un jour
              });
            },
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 20, color: Color(0xff0B8FAC)),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.teal.shade200,
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xff0B8FAC),
                shape: BoxShape.circle,
              ),
              weekendTextStyle: const TextStyle(color: Colors.red),
            ),
          ),
          const SizedBox(height: 20),
          // Heures disponibles
          const Text(
            'Heures Disponibles',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _genererHeures().map((heure) {
                return Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        // Si aucune heure de début n'est sélectionnée, sélectionnez l'heure de début
                        if (_heureDebutSelectionnee == null) {
                          _heureDebutSelectionnee = heure;
                        } 
                        // Si l'heure de début est sélectionnée, sélectionnez l'heure de fin si elle est supérieure à l'heure de début
                        else if (DateFormat('HH:mm').parse(heure).isAfter(DateFormat('HH:mm').parse(_heureDebutSelectionnee!))) {
                          _heureFinSelectionnee = heure;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('L\'heure de fin doit être après l\'heure de début.')),
                          );
                        }
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _estHeureDisponible(heure)
                            ? (_heureDebutSelectionnee == heure || _heureFinSelectionnee == heure ? const Color(0xff0B8FAC) : Colors.white)
                            : Colors.white, // Couleur si indisponible
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xff0B8FAC)),
                      ),
                      child: Text(
                        heure,
                        style: TextStyle(
                          color: _heureDebutSelectionnee == heure || _heureFinSelectionnee == heure ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          // Sélecteur du nombre de consultations
          const Text(
            'Nombre maximum de consultations par jour',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          DropdownButton<int>(
            value: _nombreConsultationsMax,
            onChanged: (int? newValue) {
              setState(() {
                _nombreConsultationsMax = newValue!;
              });
            },
            items: List.generate(15, (index) => index + 1).map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(value.toString()),
              );
            }).toList(),
          ),
          const Spacer(),
          // Bouton pour confirmer le créneau
          Center(
            child: CustomButton(
              text: 'Definir le créneau',
              backgroundColor: const Color(0xff0957DE),
              textColor: Colors.white,
              icon: Icons.arrow_forward,
              onPressed: () async {
                if (_heureDebutSelectionnee != null && _heureFinSelectionnee != null) {
                  Utilisateur? currentUtilisateur = await _utilisateurService.getCurrentUtilisateur();
                  String specialisteId = currentUtilisateur?.id ?? '';

                  // Conversion de la date sélectionnée en format 'yyyy-MM-dd'
                  String dateSelectionnee = DateFormat('yyyy-MM-dd').format(_selectedDay);

                  // Création de l'objet Disponibilite avec les nouveaux champs
                  Disponibilite disponibilite = Disponibilite(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    specialisteId: specialisteId,
                    joursDisponibilite: [dateSelectionnee],
                    heureDebut: _heureDebutSelectionnee!,
                    heureFin: _heureFinSelectionnee!,
                    disponibilite: true, // Disponibilité par défaut
                    commentaire: '', // Commentaire par défaut
                    nombreConsultationsMax: _nombreConsultationsMax,
                  );

                  // Créer la disponibilité dans le service
                  await _disponibiliteService.creerDisponibilite(disponibilite);

                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Créneau défini avec succès!')),
                  );

                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez sélectionner une heure de début et de fin.')),
                  );
                }
              },
            ),
          ),
        ],
      ),
    ),
  );
}

}
