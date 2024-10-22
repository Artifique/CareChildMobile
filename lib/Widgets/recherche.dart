import 'package:flutter/material.dart';

class CustomSearchField extends StatefulWidget {
  final Color backgroundColor; // Couleur de fond de l'icône
  final Color textColor; // Couleur du texte dans le champ de recherche
  final Color iconColor; // Couleur de l'icône de recherche
  final double iconSize; // Taille de l'icône de recherche
  final String hintText; // Texte indicatif à afficher dans le champ
  final Color iconfond;

  const CustomSearchField({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.iconfond,
    this.iconSize = 24.0, // Taille par défaut de l'icône
    this.hintText = 'Rechercher...', // Texte indicatif par défaut
  });

  @override
  State<CustomSearchField> createState() => _CustomSearchFieldState();  
}

class _CustomSearchFieldState extends State<CustomSearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      
      decoration: InputDecoration(
        fillColor: widget.backgroundColor,
        filled: true,
        suffixIcon: Container(
          margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          decoration: BoxDecoration(
            color: widget.backgroundColor, 

            // Utilise la couleur de fond passée
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(10),
          child: Container(
             decoration: BoxDecoration(
                color:widget.iconfond,
                borderRadius: BorderRadius.circular(9),
              ),
              padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.search,
              color: widget.iconColor, // Utilise la couleur de l'icône passée
              size: widget.iconSize, // Utilise la taille de l'icône passée
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: widget.hintText, // Utilise le texte indicatif passé
        hintStyle: TextStyle(color: widget.textColor), // Couleur du texte indicatif
      ),
    );
  }
}
