import 'package:accessability/Pages/message_contenu.dart';
import 'package:accessability/Services/utilisateur_service.dart';
import 'package:accessability/Widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:accessability/Modele/utilisateur_modele.dart';
import 'package:accessability/Services/message_service.dart';
import 'package:accessability/Modele/groupe_modele.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<Utilisateur> utilisateurs = [];
  List<Utilisateur> filteredUtilisateurs = [];
  List<GroupeDiscussion> groupes = [];
  List<Utilisateur> participants = [];
  String searchQuery = "";
  final UtilisateurService _utilisateurService = UtilisateurService();
  final MessageService _messageService = MessageService();
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
  }

  Future<void> _getCurrentUserId() async {
    final utilisateur = await _utilisateurService.getCurrentUtilisateur();
    setState(() {
      currentUserId = utilisateur?.id;
    });

    if (currentUserId != null) {
      await _fetchUtilisateurs();
      await _fetchGroupes();
    }
  }

  Future<void> _fetchUtilisateurs() async {
    final List<Utilisateur> fetchedUsers = await _utilisateurService.getAllUtilisateursExceptCurrent();
    setState(() {
      utilisateurs = fetchedUsers;
      filteredUtilisateurs = fetchedUsers;
    });
  }

  Future<void> _fetchGroupes() async {
    final List<GroupeDiscussion> fetchedGroupes = await _messageService.getAllGroupes();
    setState(() {
      groupes = fetchedGroupes;
    });
  }

  void _filterUtilisateurs(String query) {
    setState(() {
      searchQuery = query;
      filteredUtilisateurs = utilisateurs.where((utilisateur) {
        return utilisateur.nom.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> _creerGroupe() async {
    String nomGroupe = '';
    String idGroupe = _messageService.getNewGroupeId();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Créer un groupe de discussion'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  decoration: const InputDecoration(hintText: 'Nom du groupe'),
                  onChanged: (value) {
                    nomGroupe = value;
                  },
                ),
                const SizedBox(height: 20),
                ...utilisateurs.map((utilisateur) {
                  bool isSelected = participants.contains(utilisateur);
                  return CheckboxListTile(
                    title: Text(utilisateur.nom),
                    value: isSelected,
                    onChanged: (bool? selected) {
                      setState(() {
                        if (selected == true) {
                          participants.add(utilisateur);
                        } else {
                          participants.remove(utilisateur);
                        }
                      });
                    },
                  );
                // ignore: unnecessary_to_list_in_spreads
                }).toList(),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () async {
                if (nomGroupe.isNotEmpty && participants.isNotEmpty) {
                  List<String> participantIds = participants.map((e) => e.id).toList();
                  participantIds.add(currentUserId!);

                  final List<Utilisateur> adminUsers = await _utilisateurService.getUtilisateursAvecRole('ADMIN');
                  participantIds.addAll(adminUsers.map((admin) => admin.id));

                  try {
                    await _messageService.creerGroupe(
                      idGroupe,
                      nomGroupe,
                      participantIds,
                      currentUserId!,
                    );
                    setState(() {
                      participants.clear();
                    });
                    await _fetchGroupes();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  } catch (e) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur lors de la création du groupe: ${e.toString()}')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez remplir tous les champs et sélectionner des participants.')),
                  );
                }
              },
              child: const Text('Créer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.chevron_left,
            size: 40,
            color: Color(0xff0B8FAC),
          ),
        ),
        title: const Text(
          "Message",
          style: TextStyle(
            color: Color(0xff0B8FAC),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: const Color(0xff0B8FAC),
            onPressed: _creerGroupe,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchWidget(
              placehoder: 'Recherche ...',
              longueur: 50,
              largeur: 50,
              radius: 13,
              icon: const Icon(Icons.search),
              iconColor: const Color.fromARGB(255, 255, 255, 255),
              backgroundColor: Colors.white,
              onChanged: _filterUtilisateurs,
            ),
            const SizedBox(height: 20),
            const Text(
              "Les utilisateurs",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredUtilisateurs.isEmpty
                  ? const Center(child: Text("Aucun utilisateur trouvé"))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredUtilisateurs.length,
                      itemBuilder: (context, index) {
                        return _buildActiveUser(context, filteredUtilisateurs[index]);
                      },
                    ),
            ),
            const Text(
              "Discussions",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: groupes.isEmpty
                  ? const Center(child: Text("Aucune discussion trouvée"))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: groupes.length,
                      itemBuilder: (context, index) {
                        return _buildActiveGroup(context, groupes[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveUser(BuildContext context, Utilisateur utilisateur) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageContenuPage(
              name: utilisateur.nom,
              idGroupe: '',
              imageUrl: utilisateur.image ?? '',
              recepteurId: utilisateur.id,
              participantsIds: const [],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: utilisateur.image != null && utilisateur.image!.isNotEmpty
                  ? NetworkImage(utilisateur.image!)
                  : const AssetImage('images/default_profil.png') as ImageProvider,
            ),
            const SizedBox(height: 5),
            // ignore: sized_box_for_whitespace
            Container(
              width: 60,
              child: Text(
                utilisateur.nom,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveGroup(BuildContext context, GroupeDiscussion groupe) {
    return GestureDetector(
      onTap: () {
        if (groupe.participantsIds.contains(currentUserId)) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessageContenuPage(
                name: groupe.nom,
                idGroupe: groupe.idGroupe,
                imageUrl: '',
                recepteurId: '',
                participantsIds: groupe.participantsIds,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Vous devez être membre du groupe pour accéder aux messages.")),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Column(
          children: [
            const Icon(Icons.group, size: 30, color: Color(0xff0B8FAC)),
            const SizedBox(height: 5),
            // ignore: sized_box_for_whitespace
            Container(
              width: 60,
              child: Text(
                groupe.nom,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            if (!groupe.participantsIds.contains(currentUserId))
              ElevatedButton(
                onPressed: () async {
                  await _messageService.envoyerDemandeAdhesion(groupe.idGroupe, currentUserId!);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Demande d\'adhésion envoyée.')),
                  );
                },
                child: const Text('Demander à rejoindre'),
              ),
          ],
        ),
      ),
    );
  }
}