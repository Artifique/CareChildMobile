
import 'package:accessability/Pages/planif.dart';
import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class GestionRoutinesPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _GestionRoutinesPageState createState() => _GestionRoutinesPageState();
}

class _GestionRoutinesPageState extends State<GestionRoutinesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des routines'),
      ),
      body: Column(
        children: [
          // Routine scheduling
          ElevatedButton(
            onPressed: () {
              // Add routine action
            },
            child: GestureDetector(
                onTap: () {
                    Navigator.push(
                     context,
                     MaterialPageRoute(builder: (context) => PlanificationRoutinesPage()),
                  );
                 },

              child: const 
              Text('Ajouter une routine'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Example routines
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.access_alarm, size: 40),
                    title: Text('Routine ${index + 1}: Toilette du matin'),
                    subtitle: const Text('7h00 - 7h30'),
                    trailing: const Icon(Icons.edit),
                    onTap: () {
                      // Edit routine
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
