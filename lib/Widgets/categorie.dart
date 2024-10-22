// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomCategorie extends StatefulWidget {
  final double long;
  final double larg;
  final Image image;

  final double border1;
  final double border2;
  final String title;
  final String description;
  // ignore: use_super_parameters
  const CustomCategorie({
    Key? key,
    required this.long,
    required this.larg,
    required this.image,
    required this.border1,
    required this.border2,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  State <CustomCategorie> createState() => __CustomCategoriStateState();
}

class __CustomCategoriStateState extends State<CustomCategorie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          height: widget.long,
          width: widget.larg,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(widget.border1),
            
            ),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromARGB(255, 143, 141, 141),
                  offset: Offset(0, 5),
                  blurRadius: 5,
              ),
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
                Container(
                    width: 50,
                    height: 50,
                  decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
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
               Column(
               children: [
                 Text(widget.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                 
                 const SizedBox(height: 4),
                 Text(widget.description, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
               ],
             ),
            
          ]
        ),
        ),
    );
  }
}