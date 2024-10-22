import 'package:accessability/Modele/rendez-vous_modele.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Pages/enfant_mobile.dart';
import 'package:accessability/Pages/mes_rendez_vous.dart';
import 'package:accessability/Pages/message_page.dart';
import 'package:accessability/Pages/profile.dart';
import 'package:accessability/Pages/rendez-vous.dart';
import 'package:accessability/Pages/specialistes.dart';
import 'package:accessability/Services/rendez-vous_service.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:accessability/Session/session_manager.dart';
import 'package:accessability/Widgets/demande_widget.dart';
import 'package:accessability/Widgets/rdv_widget.dart';
import 'package:accessability/Widgets/search_widget.dart';
import 'package:flutter/material.dart';


class NewHome extends StatefulWidget {
  const NewHome({super.key});

  @override
  State<NewHome> createState() => _NewHomeState();
}

class _NewHomeState extends State<NewHome> {
  final UtilisateurService _utilisateurService = UtilisateurService();
  final RendezVousService rendezVousService = RendezVousService();
  late String docteur;
  late String role;
  late String imagePath;
  List<RendezVousM> rendezVousList = [];
  List<RendezVousM> filteredRendezVousList = [];
  bool isLoading = true;
  List<Utilisateur> filteredSpecialistes = [];
  Utilisateur? currentUser;
  DateTime selectedDate = DateTime.now();
  List<Utilisateur> specialistes = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
    _fetchSpecialistes();
    _fetchRendezVous();
  }

  Future<void> _fetchRendezVous() async {
    Utilisateur? currentUser = await _utilisateurService.getCurrentUtilisateur();
    if (currentUser != null) {
      List<RendezVousM> rendezVous = await rendezVousService.getRendezVousByParentId(currentUser.id);
      for (var rendezVousItem in rendezVous) {
        Utilisateur? specialiste = await _utilisateurService.obtenirSpecialisteParId(rendezVousItem.idSpecialiste);
        if (specialiste != null) {
          docteur = specialiste.nom;
          role = specialiste.role;
          imagePath = specialiste.image!; // Assurez-vous que l'image est bien récupérée
        }
      }
      setState(() {
        rendezVousList = rendezVous;
        filteredRendezVousList = rendezVous; // Initialement, tous les rendez-vous sont affichés
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _fetchCurrentUser() async {
    Utilisateur? user = await _utilisateurService.getCurrentUtilisateur();
    if (user != null) {
      setState(() {
        currentUser = user;
        SessionManager().setCurrentUser(user);
      });
    }
  }

  void _fetchSpecialistes() async {
    List<Utilisateur> fetchedSpecialistes = await _utilisateurService.getUtilisateursNonAdminEtNonParent();
    setState(() {
      specialistes = fetchedSpecialistes;
    });
  }

  void filtereSpecialistes(String query) {
    setState(() {
      searchQuery = query;
      filteredSpecialistes = specialistes.where((utilisateur) {
        return utilisateur.nom.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  String getFormattedDate(DateTime date) {
    // ignore: unnecessary_string_interpolations
    return "${date.day.toString().padLeft(2, '0')}";
  }

  void _filterRendezVousByDate(DateTime date) {
    setState(() {
      filteredRendezVousList = rendezVousList.where((rendezVous) {
        // Convertir la date du rendez-vous de String à DateTime
        DateTime rendezVousDate = DateTime.parse(rendezVous.date); // Assurez-vous que 'rendezVous.date' est de type String
        // Comparez uniquement la date, en ignorant l'heure
        return rendezVousDate.year == date.year &&
               rendezVousDate.month == date.month &&
               rendezVousDate.day == date.day;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B8FAC),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Column(
          children: [
            // Header et Profile
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Profile()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: NetworkImage(currentUser != null
                                  ? 'https://firebasestorage.googleapis.com/v0/b/access-ability-9faa7.appspot.com/o/utilisateurs%2F${currentUser!.id}%2Fprofile.jpg?alt=media'
                                  : 'https://example.com/default_profile.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      // Autres icônes
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DemandesAdhesionCurrentUserPage()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.family_restroom,
                                color: Color(0xff0B8FAC),
                                size: 19,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MessagePage()),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                              ),
                              child: const Icon(
                                Icons.message_rounded,
                                color: Color(0xff0B8FAC),
                                size: 19,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bienvenue',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        currentUser?.nom ?? 'Chargement...',
                        style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Section de recherche
                  SearchWidget(
                    placehoder: 'Recherche ...',
                    longueur: 50,
                    largeur: 50,
                    radius: 13,
                    icon: const Icon(Icons.search),
                    iconColor: const Color.fromARGB(255, 255, 255, 255),
                    backgroundColor: Colors.white,
                    onChanged: filtereSpecialistes,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Les Spécialistes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const Specialistes()),
                          );
                        },
                        child: const Text(
                          'voir plus',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color.fromARGB(255, 253, 253, 253),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Liste des spécialistes filtrés
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(filteredSpecialistes.length, (index) {
                        final specialiste = filteredSpecialistes[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RendezVous(specialiste: specialiste),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                specialiste.nom,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Section de calendrier
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 30,
                        itemBuilder: (context, index) {
                          DateTime currentDate = DateTime.now().add(Duration(days: index));
                          bool isSelected = selectedDate.day == currentDate.day;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedDate = currentDate;
                                _filterRendezVousByDate(currentDate); // Filtrer les rendez-vous par date sélectionnée
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.black : Colors.grey[200],
                                borderRadius: BorderRadius.circular(35),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    getFormattedDate(currentDate),
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'][currentDate.weekday - 1],
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Section des rendez-vous
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Vos rendez-vous',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MesRendezVous()),
                              );
                            },
                            child: const Text(
                              'Voir plus',
                              style: TextStyle(fontSize: 13, color: Color(0xff0B8FAC)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : filteredRendezVousList.isEmpty
                              ? const Center(child: Text("Vous n'avez pas de rendez-vous pour ce jour"))
                              : ListView.builder(
                                  itemCount: filteredRendezVousList.length,
                                  itemBuilder: (context, index) {
                                    final rendezVous = filteredRendezVousList[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child:RendezvousWidget(
                                      motif: rendezVous.motif,
                                      bg: const Color.fromARGB(255, 255, 255, 255),
                                      date: rendezVous.date,
                                      heure: rendezVous.heure,
                                      docteur: docteur,
                                      role: role,
                                      imagePath: imagePath,
                                      long: 150,
                                      larg: 270,
                                      textcolor: const Color.fromARGB(255, 0, 0, 0),
                                      idRendezVous: rendezVous.idRendezVousM,
                                      initialStatus: rendezVous.status, // Passer le statut initial
                                    ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}