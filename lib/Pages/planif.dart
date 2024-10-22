import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class PlanificationRoutinesPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _PlanificationRoutinesPageState createState() => _PlanificationRoutinesPageState();
}

class _PlanificationRoutinesPageState extends State<PlanificationRoutinesPage> {
  final List<String> _routines = ['Petit déjeuner', 'Jeu', 'Toilette'];
  // ignore: prefer_final_fields
  TextEditingController _routineController = TextEditingController();

  void _addRoutine() {
    if (_routineController.text.isNotEmpty) {
      setState(() {
        _routines.add(_routineController.text);
        _routineController.clear();
      });
    }
  }

  void _deleteRoutine(int index) {
    setState(() {
      _routines.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Planification des Routines'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _routineController,
              decoration: const InputDecoration(labelText: 'Nouvelle routine'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addRoutine,
              child: const Text('Ajouter Routine'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _routines.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_routines[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteRoutine(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
