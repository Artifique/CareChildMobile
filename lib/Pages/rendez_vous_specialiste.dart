import 'package:accessability/Modele/rendez-vous_modele.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Services/rendez-vous_service.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:accessability/Widgets/rdv_specialiste.dart';
import 'package:flutter/material.dart';

class MesRendezVousSpecialiste extends StatefulWidget {
  const MesRendezVousSpecialiste({super.key});

  @override
  State<MesRendezVousSpecialiste> createState() => _MesRendezVousSpecialisteState();
}

class _MesRendezVousSpecialisteState extends State<MesRendezVousSpecialiste> {
  final RendezVousService rendezVousService = RendezVousService();
  final UtilisateurService utilisateurService = UtilisateurService();
  late String docteur;
  late String role;
  late String imagePath;
  List<RendezVousM> rendezVousList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRendezVous();
  }

  Future<void> _fetchRendezVous() async {
    Utilisateur? currentUser = await utilisateurService.getCurrentUtilisateur();
    if (currentUser != null) {
      List<RendezVousM> rendezVous = await rendezVousService.getRendezVousBySpecialisteId(currentUser.id);
      
      // Récupération des informations du spécialiste pour chaque rendez-vous
      for (var rendezVousItem in rendezVous) {
        Utilisateur? specialiste = await utilisateurService.obtenirSpecialisteParId(rendezVousItem.idSpecialiste);
        if (specialiste != null) {
          docteur = specialiste.nom;
          role = specialiste.role;
          imagePath = specialiste.image ?? ''; // Assurez-vous que l'image est bien récupérée
        }
      }

      setState(() {
        rendezVousList = rendezVous;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0B8FAC),
      body: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.chevron_left,
                    size: 40,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(width: 75),
                const Expanded(
                  child: Text(
                    'Mes rendez-vous',
                    style: TextStyle(
                      fontSize: 22,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 60),
                padding: const EdgeInsets.symmetric(vertical: 30),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: rendezVousList.length,
                        itemBuilder: (context, index) {
                          final rendezVous = rendezVousList[index];
                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: RendezvousSpecialiste(
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
                              initialStatus: rendezVous.status,
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}