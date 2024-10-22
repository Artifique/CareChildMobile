import 'package:accessability/Pages/enfant_liste.dart';
import 'package:accessability/Pages/evenement_page.dart';
import 'package:accessability/Pages/liste_enfants.dart';
import 'package:accessability/Pages/notifications.dart';
import 'package:accessability/Pages/page.dart';

import 'package:flutter/material.dart';

import 'package:accessability/Pages/profile.dart';

class MyNavbar extends StatefulWidget {
  const MyNavbar({super.key});

  @override
  State<MyNavbar> createState() => _MyNavbarState();
}

class _MyNavbarState extends State<MyNavbar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const  NewHome(),
    EnfantListe (),
    const Notifications(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          // La barre de navigation avec une découpe courbée
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 75),
            painter: CurvedPainter(), // Dessine la découpe courbée
            child: Container(
              height: 75,
              decoration: BoxDecoration(
                color: const Color( 0xff0B8FAC),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  buildNavBarItem(Icons.home, "Accueil", 0),
                  buildNavBarItem(Icons.child_care, "Enfants", 1),
                  const SizedBox(width: 60), // Espace pour le bouton flottant
                  buildNavBarItem(Icons.notifications, "Notifications", 2),
                  buildNavBarItem(Icons.person, "Profil", 3),
               
                ],
              ),
            ),
          ),
          // Positionnement du FloatingActionButton avec padding blanc
          Positioned(
            bottom: 20, // Ajustement de la position du bouton pour le descendre
            left: MediaQuery.of(context).size.width / 2 - 35, // Centrage horizontal
            child: Container(
              padding: const EdgeInsets.all(8), // Ajout d'un padding blanc autour du bouton
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color( 0xff0B8FAC), // Couleur blanche autour du bouton
              ),
              child: FloatingActionButton(
                backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                 shape: const CircleBorder(), 
                elevation: 5,
                onPressed: () 
                { 
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  EvenementPage()),   
                    );
                },
                child: const Icon(
                  Icons.calendar_month,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        _onItemTapped(index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: _selectedIndex == index
                ? const Color.fromARGB(255, 1, 7, 12)
                : const Color.fromARGB(255, 255, 255, 255),
            size: 30,
          ),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index
                  ? const Color.fromARGB(255, 1, 7, 12)
                  : const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ],
      ),
    );
  }
}

// Définition de la forme courbée
class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.blue;

    Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.35, 0)
      ..quadraticBezierTo(size.width * 0.5, 75, size.width * 0.65, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
