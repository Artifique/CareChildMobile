import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class CompetencesSocialesPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _CompetencesSocialesPageState createState() => _CompetencesSocialesPageState();
}

class _CompetencesSocialesPageState extends State<CompetencesSocialesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compétences Sociales'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline, size: 40),
                  title: const Text('Jeu de rôle: Interaction avec un ami'),
                  subtitle: const Text('Apprendre à dire bonjour, se présenter'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Start game or scenario
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_search, size: 40),
                  title: const Text('Jeu de rôle: Résolution de conflits'),
                  subtitle: const Text('Apprendre à résoudre des problèmes'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    // Start game or scenario
                  },
                ),
              ],
            ),
          ),
          // Avatar customization
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/avatar.png'),
                ),
                const SizedBox(width: 20),
                Column(
                  children: [
                    const Text('Personnaliser avatar', style: TextStyle(fontSize: 18)),
                    ElevatedButton(
                      onPressed: () {
                        // Customization action
                      },
                      child: const Text('Personnaliser'),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
