import 'package:accessability/Widgets/custum_lieu.dart';
import 'package:accessability/Widgets/demande_widget.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color( 0xff0B8FAC), 
      
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
          color: Colors.white),
          ),
        centerTitle: true,
        backgroundColor: const Color( 0xff0B8FAC),
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
                            const Text('Notifications'),
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
                            child: const Text('Ce mois')
                            )
                            // CustomPetitBouton(longueur: 30, largeur: 60, textedit:'Ce mois', backcolor: Colors.black, textcolor: Colors.white, borderRadius:13, icon: Icon(Icons.add))
                          ],
                        ),
        
                        const SizedBox(height: 10),
                        // Container(
                        //   width: MediaQuery.of(context).size.width,
                        //   // height: 3OO,
                        //   decoration: const BoxDecoration(
                        //     // color: Colors.indigo/
                        //   ),
                        //   child: CustumLieu(
                        //      height: 100,
                        //      width: double.infinity,
                        //      borderRadius: 9,
                        //      image: Image.asset('images/rappels.png'),
                        //      text: 'Faites des jeux avec l enfant ',
                        //      backgroundColor: Colors.white,
                        //      textColor: Colors.black38,
                        //      imageBackgroundColor:const Color( 0xff0B8FAC),
                        //      imageSize: 70,
                        //      textSize: 12,
                        //    ),
                        // ),
                        const SizedBox(height: 20),
                         // ignore: avoid_unnecessary_containers
                        


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