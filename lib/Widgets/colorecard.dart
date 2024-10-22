import 'package:flutter/material.dart';

class ColoredCard extends StatelessWidget {
  final Color coul1; // Couleur de la première partie
  final Color coul2; // Couleur de la deuxième partie
  final double hauteur1; // Hauteur de la première partie
  final double hauteur2; // Hauteur de la deuxième partie
  final double borderRadius; // Rayon des bords

  const ColoredCard({
    super.key,
    required this.coul1,
    required this.coul2,
    required this.hauteur1,
    required this.hauteur2,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius), // Applique le BorderRadius
        child: Column(
          children: [
            // Première partie avec coul1
            Container(
              color: coul1,
              height: hauteur1,
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.circle,color: Colors.blue),
                        Text('Maison'),
                        Text('7h45')
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(Icons.location_on,color: Colors.red),
                        Text('Point G'),
                        Text('9h30')
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Deuxième partie avec coul2
            Container(
              color: coul2,
              height: hauteur2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Container(
                            width: 50,
                            height: 50,
                         decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color.fromARGB(255, 26, 23, 23), // Bordure noire autour du cercle
                            width: 2,
                          ),
                          image: const DecorationImage(
                            image: AssetImage('images/profil.png'), // Remplace par l'image de ton avatar
                            fit: BoxFit.cover,
                          ),
                        ),
                     ),
                    const Text('Ali Cissé'),
                    const Text('7h00')
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
