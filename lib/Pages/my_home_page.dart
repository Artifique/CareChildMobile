import 'package:accessability/Widgets/costum_card.dart';
import 'package:accessability/Widgets/custum_lieu.dart';
import 'package:flutter/material.dart';
import 'package:accessability/Widgets/recherche.dart';
// import 'package:accessability/Widgets/custom_bouton.dart'; // Ajoutez votre CustomBouton ici

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 199, 193, 193),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Redirection ou action à l'appui de l'image de profil
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color.fromARGB(255, 26, 23, 23),
                                  width: 2,
                                ),
                                image: const DecorationImage(
                                  image: AssetImage('images/profil.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cissé Ali',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                              Text('Handicape Visuel'),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: const Icon(Icons.notifications, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 88, 87, 87),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: Offset(0.0, 5.0),
                        )
                      ],
                    ),
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(8, 25, 8, 8),
                      child: CustomSearchField(
                        backgroundColor: Color.fromARGB(255, 255, 255, 255),
                        iconColor: Color.fromARGB(255, 255, 255, 255),
                        textColor: Colors.black,
                        hintText: 'Recherche',
                        iconSize: 12,
                        iconfond: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    'Moyens de Transport',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const SizedBox(
                    height: 80, // Hauteur ajustée pour correspondre aux cartes plus petites
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          CustomCard(
                            height: 60,
                            width: 140,
                            borderRadius: 9,
                            text: 'Moto',
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            imageBackgroundColor: Colors.blue,
                            imageSize: 40,
                            textSize: 10,
                            image: Image(image: AssetImage('images/moto.png')),
                          ),
                          SizedBox(width: 10),
                          CustomCard(
                            height: 60,
                            width: 140,
                            borderRadius: 9,
                            text: 'Taxi',
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            imageBackgroundColor: Colors.blue,
                            imageSize: 40,
                            textSize: 10,
                            image: Image(image: AssetImage('images/taxi.png')),
                          ),
                          SizedBox(width: 10),
                          CustomCard(
                            height: 60,
                            width: 140,
                            borderRadius: 9,
                            text: 'Sotrama',
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            imageBackgroundColor: Colors.blue,
                            imageSize: 40,
                            textSize: 10,
                            image: Image(image: AssetImage('images/bus.png')),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Quelques services sociaux',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 1),
                ],
              ),
            ),
            // Cette partie est la section avec scroll vertical
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      CustumLieu(
                        height: 100,
                        width: double.infinity,
                        borderRadius: 9,
                        image: Image.asset('images/moto.png'),
                        text: 'text',
                        backgroundColor: Colors.white,
                        textColor: Colors.black38,
                        imageBackgroundColor: Colors.blue,
                        imageSize: 70,
                        textSize: 12,
                      ),
                      const SizedBox(height: 20),
                      CustumLieu(
                        height: 100,
                        width: double.infinity,
                        borderRadius: 9,
                        image: Image.asset('images/moto.png'),
                        text: 'text',
                        backgroundColor: Colors.white,
                        textColor: Colors.black38,
                        imageBackgroundColor: Colors.blue,
                        imageSize: 70,
                        textSize: 12,
                      ),
                      const SizedBox(height: 20),
                      CustumLieu(
                        height: 100,
                        width: double.infinity,
                        borderRadius: 9,
                        image: Image.asset('images/moto.png'),
                        text: 'text',
                        backgroundColor: Colors.white,
                        textColor: Colors.black38,
                        imageBackgroundColor: Colors.blue,
                        imageSize: 70,
                        textSize: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
