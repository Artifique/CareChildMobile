import 'package:flutter/material.dart';

class CustomCartes extends StatefulWidget{
   final double largeur;
   final double hauteur;
   final Color coul1;
   final Color coul2;

    const CustomCartes({
    super.key,
    required this.coul1,
    required this.coul2,
    required this.largeur,
    required this.hauteur,
   
  });


  @override
    State<CustomCartes> createState() => _CustomCartesState();

}

class _CustomCartesState extends State<CustomCartes>{
  @override
  Widget build(BuildContext context) {
    return Container(
      
      height: widget.hauteur,
      width: widget.largeur,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: widget.coul1
      ),
      child: Column(
        //Premiere Partie
        children: [
          const Column(
            children: [
              Row(
                children: [
                  Icon(Icons.credit_card_outlined,color: Colors.blue),
                  SizedBox(width: 8),
                  Text('Carte de crédit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(width: 15),
                  Text('7h00'),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.credit_card_outlined,color: Colors.red),
                  SizedBox(width: 8),
                  Text('Carte de crédit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(width: 15),
                  Text('7h00'),
                ],
              )
            ],
          ),
          Container(
            color: widget.coul2,
            child: const Row( 
              children: [
                Icon(Icons.credit_card_outlined,color: Colors.green),
                SizedBox(width: 3),
                Text('Carte de crédit', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(width: 15),
                Text('7h00'),
              ],
            ),
          )

        ],
          
      ),
      );

  }
  
}
