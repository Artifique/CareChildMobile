import 'package:accessability/Widgets/colorecard.dart';
import 'package:flutter/material.dart';

class Historiques extends StatefulWidget {
  const Historiques({super.key});

  @override
  State<Historiques> createState() => _HistoriquesState();
}

class _HistoriquesState extends State<Historiques> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, 
      
      appBar: AppBar(
        title: const Text(
          'Historiques',
          style: TextStyle(
          color: Colors.white),
          ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(0,100,0,0),
          child: SafeArea(
            
            child: 
              Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(topLeft:Radius.circular(35), topRight: Radius.circular(35)),
                  color: const Color.fromARGB(255, 255, 255, 255),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 41, 40, 40).withOpacity(0.5),
                      offset: const Offset(0, 5),
                      blurRadius: 5,
                    ),
                  ]
                ),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height/1,
                   
                  child: Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                       
                      children: [
        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text('Historiques'),
                            // MonButton(Colors.black, Colors.white, 'Ce mois', Icons.expand_more, (){})
                            ElevatedButton(onPressed: (){}, 
                            style: ElevatedButton.styleFrom(
                               
                                foregroundColor: Colors.white, backgroundColor: Colors.black,
                                padding: const EdgeInsets.all(10),
                                textStyle: const TextStyle(fontSize: 14),
                                 maximumSize: const Size(100, 80),
                                 shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(17), // Bords arrondis
                                  ),
                            ),
                            // ignore: avoid_unnecessary_containers
                            child: Container( 
        
                    
                              child: const Text('Ce mois'),
                              
                            )
                            )
                            // CustomPetitBouton(longueur: 30, largeur: 60, textedit:'Ce mois', backcolor: Colors.black, textcolor: Colors.white, borderRadius:13, icon: Icon(Icons.add))
                          ],
                        ),
        
                        const SizedBox(height: 10),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          // height: 3OO,
                          decoration: const BoxDecoration(
                            // color: Colors.indigo/
                          ),
                          child: const ColoredCard(coul1: Color.fromARGB(255, 224, 222, 222), coul2: Color.fromARGB(255, 250, 245, 245), hauteur1: 100, hauteur2: 80, borderRadius: 12)
                        ),
                        const SizedBox(height: 20),
                         // ignore: avoid_unnecessary_containers
                         Container(child: const ColoredCard(coul1: Color.fromARGB(255, 224, 222, 222), coul2: Color.fromARGB(255, 250, 245, 245), hauteur1: 100, hauteur2: 80, borderRadius: 12)),
                          const SizedBox(height: 20),
                         // ignore: avoid_unnecessary_containers
                         Container(child: const ColoredCard(coul1: Color.fromARGB(255, 224, 222, 222), coul2: Color.fromARGB(255, 250, 245, 245), hauteur1: 100, hauteur2: 80, borderRadius: 12))
                     
        
                      ],
                    ),
                  ),
                ),
              ),
              
          
          ),
        ),
      ),
      
    );
  }
}