import 'package:accessability/Modele/creneau_modele.dart';
import 'package:accessability/Modele/enfant_modele.dart';
import 'package:accessability/Modele/rendez-vous_modele.dart';
import 'package:accessability/Services/assignation_service.dart';
import 'package:accessability/Services/enfant_service.dart';
import 'package:accessability/Services/rendez-vous_service.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Services/disponibilite_service.dart';

class RendezVous extends StatefulWidget {
  final Utilisateur specialiste;

  const RendezVous({super.key, required this.specialiste});

  @override
  // ignore: library_private_types_in_public_api
  _RendezVousState createState() => _RendezVousState();
}

class _RendezVousState extends State<RendezVous> {
  late Future<List<Disponibilite>> disponibilites;
  final RendezVousService rendezVousService = RendezVousService();
  final UtilisateurService utilisateurService = UtilisateurService();
  final AssignationService assignationService = AssignationService();
  late Map<DateTime, List<Disponibilite>> disponibilitesParDate = {};
  DateTime selectedDate = DateTime.now();
  int selectedTimeIndex = -1; // Aucun créneau sélectionné par défaut
  final TextEditingController motifController = TextEditingController(); // Champ pour le motif
  late Future<List<Enfant>> enfants; // Future pour récupérer les enfants
String? selectedEnfantId; // ID de l'enfant sélectionné


@override
void initState() {
  super.initState();
  disponibilites = DisponibiliteService().recupererDisponibilitesParSpecialiste(widget.specialiste.id);

  // Récupérer l'utilisateur actuel et ses enfants
  utilisateurService.getCurrentUtilisateur().then((currentUser) {
    if (currentUser != null) {
      setState(() {
        enfants = EnfantService().getEnfantsByParentId(currentUser.id); // Utiliser l'ID du parent actuel
      });
    }
  });
}




  // Vérifie si un jour a des disponibilités
  bool _estJourDisponible(DateTime date) {
    DateTime jourCle = DateTime(date.year, date.month, date.day);
    return disponibilitesParDate.containsKey(jourCle) && disponibilitesParDate[jourCle]!.isNotEmpty;
  }

  // Vérifie si un créneau horaire est disponible
  bool _estCreneauDisponible(DateTime date, int heure) {
    DateTime jourCle = DateTime(date.year, date.month, date.day);
  
    if (disponibilitesParDate.containsKey(jourCle)) {
      List<Disponibilite> disponibilites = disponibilitesParDate[jourCle]!;

      for (var disponibilite in disponibilites) {
        DateTime heureDebut = DateTime.parse('${jourCle.toIso8601String().split('T').first} ${disponibilite.heureDebut}');
        DateTime heureFin = DateTime.parse('${jourCle.toIso8601String().split('T').first} ${disponibilite.heureFin}');

        // Vérifie si l'heure sélectionnée est dans l'intervalle
        if (heureDebut.hour <= heure && heure < heureFin.hour) {
          return true; // Créneau disponible
        }
      }
    }

    return false; // Pas de créneau disponible
  }

Future<void> _prendreRendezVous() async {
  if (selectedTimeIndex >= 0 && selectedEnfantId != null) {
    String idRendezVous = DateTime.now().millisecondsSinceEpoch.toString();
    DateTime selectedHour = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTimeIndex,
    );

    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
    String formattedHour = DateFormat('HH:mm').format(selectedHour);

    Utilisateur? currentUser = await utilisateurService.getCurrentUtilisateur();
    String idParent = currentUser?.id ?? 'parent_id_123';

    RendezVousM rendezVous = RendezVousM(
      date: formattedDate,
      heure: formattedHour,
      status: 'en attente',
      idSpecialiste: widget.specialiste.id,
      idParent: idParent,
      motif: motifController.text.isNotEmpty ? motifController.text : 'Consultation',
      idRendezVousM: idRendezVous,
      idEnfant: selectedEnfantId!,
    );

    try {
      // Appeler la méthode pour prendre le rendez-vous
      await rendezVousService.prendreRendezVous(rendezVous);

      // Appeler la méthode faireAssignation du service Assignation
      await assignationService.faireAssignation(selectedEnfantId!, widget.specialiste.id);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Rendez-vous pris et assignation créée avec succès !")),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : $e")),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Veuillez sélectionner un créneau horaire et un enfant.")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B8FAC),
      body: Stack(
        children: [
          // Header avec bouton retour
          Container(
            margin: const EdgeInsets.only(top: 60),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.chevron_left,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Prendre un rendez-vous",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Contenu principal
          Positioned(
            top: 180,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 180,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(height: 50),

                      // Informations sur le spécialiste
                      Text(
                        widget.specialiste.nom,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.specialiste.role,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sélection de la date
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Choisissez une date",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // TableCalendar pour sélectionner les jours disponibles
                      FutureBuilder<List<Disponibilite>>(
                        future: disponibilites,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                              disponibilitesParDate.clear();
                              for (var dispo in snapshot.data!) {
                                for (var jour in dispo.joursDisponibilite) {
                                  DateTime date = DateTime.parse(jour);
                                  if (!disponibilitesParDate.containsKey(date)) {
                                    disponibilitesParDate[date] = [];
                                  }
                                  disponibilitesParDate[date]!.add(dispo);
                                }
                              }

                              return TableCalendar(
                                firstDay: DateTime.now(),
                                lastDay: DateTime.now().add(const Duration(days: 30)),
                                focusedDay: selectedDate,
                                selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    selectedDate = selectedDay;
                                    selectedTimeIndex = -1; // Réinitialiser la sélection de créneau
                                  });
                                },
                                calendarStyle: const CalendarStyle(
                                  todayDecoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  selectedDecoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                calendarBuilders: CalendarBuilders(
                                  // Marquer les jours disponibles en rouge
                                  defaultBuilder: (context, date, focusedDay) {
                                    if (_estJourDisponible(date)) {
                                      return Container(
                                        decoration: const BoxDecoration(
                                          color: Colors.red, // Colorer les jours disponibles en rouge
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            date.day.toString(),
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      );
                                    }
                                    return null; // Laisser les autres jours avec la couleur par défaut
                                  },
                                ),
                              );
                            } else {
                              return const Center(child: Text("Aucune disponibilité trouvée."));
                            }
                          } else {
                            return const Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                      const SizedBox(height: 30),

                      // Affichage de la date et de l'heure sélectionnées
                      if (selectedTimeIndex >= 0) ...[
                        const SizedBox(height: 20),
                        Text(
                          "Date choisie : ${selectedDate.toLocal()}".split(' ')[0], // Format de la date
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          // ignore: unnecessary_brace_in_string_interps
                          "Heure choisie : ${selectedTimeIndex}:00",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],

                      // Sélection de l'heure et motif
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Choisissez une heure",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Créneaux horaires disponibles
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(24, (index) {
                            // Vérifier si le créneau est disponible
                            bool isAvailable = _estCreneauDisponible(selectedDate, index);
                            String heureDebut = "";
                            String heureFin = "";

                            if (isAvailable && disponibilitesParDate[selectedDate] != null) {
                              var disponibilite = disponibilitesParDate[selectedDate]!
                                  .firstWhere(
                                    (dispo) => int.parse(dispo.heureDebut.split(':')[0]) == index,
                                    orElse: () => Disponibilite(
                                      heureDebut: "00:00",
                                      heureFin: "00:00",
                                      id: '',
                                      joursDisponibilite: [],
                                      commentaire: '',
                                      specialisteId: '',
                                      disponibilite: false,
                                      nombreConsultationsMax: 5,
                                    ),
                                  );

                              if (disponibilite.heureDebut != "00:00") {
                                heureDebut = disponibilite.heureDebut;
                                DateTime startTime = DateTime.parse("1970-01-01 $heureDebut");
                                DateTime endTime = startTime.add(const Duration(hours: 1)); // Ajout d'une heure
                                heureFin = "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}";
                              }
                            }

                            return GestureDetector(
                              onTap: isAvailable
                                  ? () {
                                      setState(() {
                                        selectedTimeIndex = index; // Sélectionner le créneau
                                      });
                                    }
                                  : null,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // Affichage de l'heure de début
                                      Text(
                                        heureDebut,
                                        style: TextStyle(
                                          color: isAvailable ? Colors.red : Colors.transparent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      // Rectangle du créneau horaire
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 5),
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: selectedTimeIndex == index
                                              ? Colors.green
                                              : isAvailable
                                                  ? Colors.red
                                                  : Colors.grey,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          "$index:00",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),

                                      // Affichage de l'heure de fin
                                      Text(
                                        heureFin,
                                        style: TextStyle(
                                          color: isAvailable ? Colors.red : Colors.transparent,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            );
                          }),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Champ pour le motif du rendez-vous
                      TextField(
                        controller: motifController,
                        decoration: const InputDecoration(
                          labelText: 'Motif du rendez-vous',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Sélection de l'enfant
const Align(
  alignment: Alignment.centerLeft,
  child: Text(
    "Choisissez un enfant",
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  ),
),
const SizedBox(height: 10),
FutureBuilder<List<Enfant>>(
  future: enfants,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
        return DropdownButton<String>(
          value: selectedEnfantId,
          hint: const Text("Sélectionnez un enfant"),
          items: snapshot.data!.map((enfant) {
            return DropdownMenuItem<String>(
              value: enfant.id,
              child: Text(enfant.nom),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedEnfantId = value; // Mettre à jour l'ID de l'enfant sélectionné
            });
          },
        );
      } else {
        return const Center(child: Text("Aucun enfant trouvé."));
      }
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  },
),
                      const SizedBox(height: 20),
                      
                      // Bouton pour prendre rendez-vous
                      GestureDetector(
                        onTap: _prendreRendezVous,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Center(
                            child: Text(
                              "Prendre rendez-vous",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}