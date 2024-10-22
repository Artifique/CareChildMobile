import 'package:accessability/Pages/login.dart';
import 'package:accessability/Widgets/bouton.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Image en arrière-plan
          Positioned.fill(
            child: Image.asset(
              "images/splash.jpg",
              fit: BoxFit.cover,
            ),
          ),
          // Dégradé sur l'image
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3), // Couleur en haut (légèrement transparente)
                    const Color.fromARGB(255, 53, 67, 187).withOpacity(0.7), // Couleur en bas (plus opaque)
                  ],
                ),
              ),
            ),
          ),
          // Contenu superposé
          Positioned.fill(
            top: 555,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Texte
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Là où le soin rencontre la communauté : Rejoignez-nous pour faire la différence !",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 21,
                     
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
               Padding(
                 padding: const EdgeInsets.all(45.0),
                 child: GestureDetector(
                   onTap: () {
                     // Naviguer vers la page de connexion
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const Login()));
                   },
                  child: const CustomButton(
                    text: 'Continuer', 
                    // ignore: unnecessary_const
                    backgroundColor:  Color(0xff0957DE), 
                    textColor: Color.fromARGB(255, 224, 224, 224
                    )
                    )
                    ),
               ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
