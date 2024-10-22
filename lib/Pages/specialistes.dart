import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Pages/rendez-vous.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:accessability/Widgets/search_widget.dart';
import 'package:accessability/Widgets/bouton.dart';
import 'package:flutter/material.dart';

class Specialistes extends StatefulWidget {
  const Specialistes({super.key});

  @override
  State<Specialistes> createState() => _SpecialistesState();
}

class _SpecialistesState extends State<Specialistes> {
  List<Utilisateur> _specialistes = []; // Liste pour stocker les spécialistes
  String searchQuery = ''; // Variable pour la requête de recherche
  List<Utilisateur> filteredSpecialistes = []; // Liste pour les spécialistes filtrés

  @override
  void initState() {
    super.initState();
    _fetchSpecialistes(); // Appel à la méthode pour récupérer les spécialistes
  }

  Future<void> _fetchSpecialistes() async {
    final utilisateursService = UtilisateurService(); // Assurez-vous d'initialiser votre service
    List<Utilisateur> specialistes = await utilisateursService.getUtilisateursNonAdminEtNonParent();
    setState(() {
      _specialistes = specialistes; // Mettez à jour l'état avec les spécialistes récupérés
      filteredSpecialistes = specialistes; // Initialisez les résultats filtrés avec tous les spécialistes
    });
  }

  void filtereSpecialistes(String query) {
    setState(() {
      searchQuery = query;
      filteredSpecialistes = _specialistes.where((utilisateur) {
        return utilisateur.nom.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(top: 30),
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
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
                    color: Color(0xff0B8FAC),
                  ),
                ),
                const SizedBox(width: 75),
                const Text(
                  textAlign: TextAlign.center,
                  'Spécialistes',
                  style: TextStyle(
                    fontSize: 26,
                    color: Color(0xff0B8FAC),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    // Affichage des spécialistes filtrés
                    ...filteredSpecialistes.map((specialiste) => Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                               Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RendezVous(specialiste: specialiste),),
                           );
                          },
                          child: sp_widget(
                            specialiste.nom, // Utilisez les propriétés de votre modèle Utilisateur
                            specialiste.role, // Assurez-vous que 'role' est disponible dans votre modèle
                            Colors.white,
                            specialiste.image ?? "", // Remplacez par l'URL de l'image si disponible
                            150,
                            double.infinity,
                            const Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 20), // Espace entre les widgets
                      ],
                    // ignore: unnecessary_to_list_in_spreads
                    )).toList(),
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
