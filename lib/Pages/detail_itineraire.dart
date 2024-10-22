import 'package:accessability/Widgets/bouton.dart';
import 'package:flutter/material.dart';

class DetailItineraire extends StatefulWidget {
  const DetailItineraire({super.key});

  @override
  State<DetailItineraire> createState() => _DetailItineraireState();
}

class _DetailItineraireState extends State<DetailItineraire> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 400,
               decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/map.jpeg'), // Votre chemin d'image
                  fit: BoxFit.cover, // Ajuste l'image à la taille du conteneur
                ),
              ),
              child: const Column(
                
                children: [
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Card(
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.directions, color: Color.fromARGB(255, 0, 0, 0), size: 50),
                              Text('Itineraire')
                            ],
                          ),
                           Divider(
                            color: Colors.black, // Couleur du trait
                            thickness: 1, // Épaisseur du trait
                            indent: 10, // Marge gauche
                            endIndent: 10, // Marge droite
                          ),
                          Row(
                            children: [
                              Icon(Icons.local_activity, color: Color.fromARGB(255, 189, 40, 40), size: 50),
                              Text('Destination')
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                color: const Color.fromARGB(255, 186, 190, 190),
                borderRadius: BorderRadius.circular(19),
                   
                ),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Temps d arrivee
                        Column(
                          children: [
                            Text(
                              'Arrivee dans 3 minutes',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold
                              ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Prix= 1000', 
                                 style: TextStyle(fontSize: 12, 
                                 fontWeight: FontWeight.bold)),
                
                          ],
                        ),
                
                          // Voiture
                          Icon(Icons.car_crash_sharp, color: Color.fromARGB(255, 0, 0, 0), size: 50),
                        ],
                         ),
                         const SizedBox(height:25),
                            // les personnes
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width:65,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(12),
                          ),
                            
                          padding: const EdgeInsets.all(10),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.motorcycle,
                                color: Colors.black,
                                ),
                                Text(
                                  'Moto', 
                                  style: TextStyle(fontSize: 10,
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.black),
                                  )
                            ],
                          ),
                          // child: const Icon(Icons.person, color: Colors.white, size: 28),
                        ),
                        Container(
                           width:65,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.bus_alert,
                                color: Colors.black,
                                ),
                                Text(
                                  'Sotrama', 
                                  style: TextStyle(fontSize: 9,
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.black),
                                  )
                            ],
                          ),
                        ),
                        Container(
                           width:65,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(10),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.taxi_alert_rounded,
                                color: Colors.black,
                                ),
                                Text(
                                  'Taxi', 
                                  style: TextStyle(fontSize: 10,
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.black),
                                  )
                            ],
                          ),
                        ),
                        Container(
                           width:65,
                          height: 70,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(12),
                          ),
                         padding: const EdgeInsets.all(10),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.nordic_walking_outlined,
                                color: Colors.black,
                                ),
                                Text(
                                  'Pieton', 
                                  style: TextStyle(fontSize: 9,
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.black),
                                  )
                            ],
                          ),
                        ),
                  ],
                ),
                const SizedBox(height: 35),
                // Bouton plus
                 const Padding(
                   padding: EdgeInsets.all(8.0),
                   child: CustomButton(text: 'Montrer Plus', backgroundColor: Colors.black38, textColor: Color.fromARGB(255, 224, 224, 224)),
                 )
                          
                  
                          ],
                        ),
              ),
            ),
          ]
        )
      
      ),
    );
  }
}