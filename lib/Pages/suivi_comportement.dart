import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class SuiviComportementPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _SuiviComportementPageState createState() => _SuiviComportementPageState();
}

class _SuiviComportementPageState extends State<SuiviComportementPage> {
  List<String> emotions = ['Heureux', 'Triste', 'Énervé', 'Calme'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi des comportements'),
      ),
      body: Column(
        children: [
          // Graph displaying behavior progress
          Padding(
            padding: const EdgeInsets.all(8.0),
            // ignore: sized_box_for_whitespace
            child: Container(
              height: 200,
              child: const Placeholder(), // Replace with graph widget
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: emotions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.mood, size: 40),
                  title: Text('Émotion: ${emotions[index]}'),
                  trailing: const Icon(Icons.check),
                  onTap: () {
                    // Log emotion or action
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
