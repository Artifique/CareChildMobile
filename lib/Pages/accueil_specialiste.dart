import 'package:accessability/Modele/rendez-vous_modele.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Pages/creneau_page.dart';
import 'package:accessability/Pages/message_page.dart';
import 'package:accessability/Pages/profile.dart';
import 'package:accessability/Pages/rendez_vous_specialiste.dart';
import 'package:accessability/Services/rendez-vous_service.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:accessability/Widgets/bouton.dart';
import 'package:accessability/Widgets/rdv_specialiste.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AccueilSpecialiste extends StatefulWidget {
  const AccueilSpecialiste({super.key});

  @override
  State<AccueilSpecialiste> createState() => _AccueilSpecialisteState();
}

class _AccueilSpecialisteState extends State<AccueilSpecialiste> {
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

  void _fetchCurrentUser() async {
    Utilisateur? user = await _utilisateurService.getCurrentUtilisateur();
    if (user != null) {
      setState(() {
        currentUser = user;
        if (kDebugMode) {
          print(currentUser?.nom);
        }
      });
    }
  }

   Future<void> _fetchRendezVous() async {
    Utilisateur? currentUser = await _utilisateurService.getCurrentUtilisateur();
    if (currentUser != null) {
      List<RendezVousM> rendezVous = await rendezVousService.getRendezVousBySpecialisteId(currentUser.id);
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
      backgroundColor:const Color( 0xff0B8FAC),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(19),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align left
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                     // Remplace le code de l'image de profil
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
             height:50 ,
              decoration: BoxDecoration(
               shape: BoxShape.circle,
               border: Border.all(
        color: const Color.fromARGB(255, 255, 255, 255),
        width: 2,
      ),
      image: DecorationImage(
        image: NetworkImage(
          currentUser != null 
            ? 'https://firebasestorage.googleapis.com/v0/b/access-ability-9faa7.appspot.com/o/utilisateurs%2F${currentUser!.id}%2Fprofile.jpg?alt=media'
            : 'https://example.com/default_profile.png'
            ), // Remplace <your-bucket-name> par le nom de ton bucket Firebase
        fit: BoxFit.cover,
      ),
    ),
  ),
),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                             onTap: () {
                                   Navigator.push(
                                     context,
                                     MaterialPageRoute(builder: (context) => CreneauPage()),
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
                              child:const Icon(
                                Icons.calendar_month,
                                color:Color( 0xff0B8FAC),
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
                              child:const Icon(
                                Icons.message_rounded,
                                color:Color( 0xff0B8FAC),
                                size: 19,
                              ),
                            ),
                          ),
                          

                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                    children: [
                      Text(
                        'Bienvenue',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5), // Add spacing between text
                    Text(
                      'Chargement',
                    // currentUser?.nom ?? 'Chargement...', // Affiche le nom de l'utilisateur ou "Chargement..." si null
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                    ],
                  ),
                  const SizedBox(height: 20), // Spacing for the search widget
                  accroche_widget(
                    Colors.white, 
                    'images/care.png', 
                    'Aideez nous a faire la difference ', 
                    130, 
                    double.infinity, 
                    Colors. black,
                    ),
                  const SizedBox(height: 10),
          
                 
                  
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
                                MaterialPageRoute(builder: (context) => const MesRendezVousSpecialiste()),
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
                                      child:RendezvousSpecialiste(
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