// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustomPetitBouton extends StatefulWidget {
  final double longueur;
  final double largeur;
  final String textedit;
  final Color backcolor;
  final Color textcolor;
  final double borderRadius;
  final Icon icon;
   final VoidCallback? onPressed;

  // ignore: use_super_parameters
  const CustomPetitBouton({
    key,
    required this.longueur,
    required this.largeur,
    required this.textedit,
    required this.backcolor,
    required this.textcolor,
    required this.borderRadius,
    required this.icon,
        this.onPressed,
  }) : super(key: key);

  @override
  State<CustomPetitBouton> createState() => _CustomPetitBoutonState();
}

class _CustomPetitBoutonState extends State<CustomPetitBouton> {
  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      
      style: ElevatedButton.styleFrom(
         
        backgroundColor:widget.backcolor, // Utiliser la couleur de fond passée
        disabledBackgroundColor:widget.backcolor, // Utiliser la couleur de fond passée
        foregroundColor: widget.textcolor, // Utiliser la couleur de texte passée
        minimumSize: Size(widget.largeur, widget.longueur), // Définir la largeur et la hauteur souhaitées
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius), // Bords arrondis
        ),
      ),
      onPressed: widget.onPressed,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Text(
              widget.textedit, // Texte passé en paramètre
              style: TextStyle(
                color: widget.textcolor, // Appliquer la couleur du texte
                fontSize: 13,
              ),
            ),
          ),
          Positioned(
            right: -1,
            bottom: -1,
            child: Container(
              width: 2,
              height: 2,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Icon(
                  widget.icon as IconData?, // Icône dynamique passée en paramètre
                  color: widget.backcolor, // Couleur de l'icône
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}