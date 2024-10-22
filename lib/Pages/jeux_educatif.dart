import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class JeuxEducatifsPage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _JeuxEducatifsPageState createState() => _JeuxEducatifsPageState();
}

class _JeuxEducatifsPageState extends State<JeuxEducatifsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jeux éducatifs'),
      ),
      body: Column(
        children: [
          // Animation progress bar
          LinearProgressIndicator(
            value: 0.5, // Example: 50% progress
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.5,
              ),
              itemCount: 6, // Example number of games
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.gamepad, size: 50, color: Colors.blue),
                      const SizedBox(height: 10),
                      Text('Jeu ${index + 1}', style: const TextStyle(fontSize: 18)),
                    ],
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
