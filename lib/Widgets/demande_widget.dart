import 'package:flutter/material.dart';
import 'package:accessability/Services/message_service.dart';
import 'package:accessability/Services/utilisateur_service.dart'; // Assure-toi que le service utilisateur est bien importé
import 'package:accessability/Modele/utilisateur_modele.dart'; // Assure-toi d'importer le modèle utilisateur si nécessaire

class DemandesAdhesionCurrentUserPage extends StatefulWidget {
  const DemandesAdhesionCurrentUserPage({Key? key}) : super(key: key);

  @override
  _DemandesAdhesionCurrentUserPageState createState() => _DemandesAdhesionCurrentUserPageState();
}

class _DemandesAdhesionCurrentUserPageState extends State<DemandesAdhesionCurrentUserPage> {
  late Stream<List<Map<String, dynamic>>> _demandesStream;
  Utilisateur? _currentUtilisateur;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserAndFetchDemandes();
  }

  // Méthode pour charger l'utilisateur actuel et initialiser le stream des demandes
  Future<void> _loadCurrentUserAndFetchDemandes() async {
    Utilisateur? utilisateur = await UtilisateurService().getCurrentUtilisateur(); // Récupération de l'utilisateur
    if (utilisateur != null) {
      setState(() {
        _currentUtilisateur = utilisateur;
        _demandesStream = MessageService().recevoirDemandesAdhesionPourGroupesCreateur(utilisateur.id); // Charger les demandes du groupe
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      // Gérer le cas où l'utilisateur n'est pas connecté ou non récupérable
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Utilisateur non connecté')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Demandes d\'adhésion pour mes groupes')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentUtilisateur == null
              ? const Center(child: Text('Impossible de récupérer l\'utilisateur.'))
              : StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _demandesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Aucune demande d\'adhésion.'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var demande = snapshot.data![index];
                        return ListTile(
                          title: Text(demande['demandeurId']),
                          subtitle: Text('Groupe: ${demande['idGroupe']}'), // Afficher le groupe d'origine
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () async {
                                  await MessageService().accepterDemande(
                                    demande['id'],
                                    demande['idGroupe'],
                                    demande['demandeurId'],
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () async {
                                  await MessageService().refuserDemande(demande['id']);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
