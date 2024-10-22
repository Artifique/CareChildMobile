import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final Image image;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final Color imageBackgroundColor;
  final double imageSize;
  final double textSize;

  const CustomCard({
    super.key,
    required this.height,
    required this.width,
    required this.borderRadius,
    required this.image,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.imageBackgroundColor,
    required this.imageSize,
    required this.textSize,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: const [
           BoxShadow(
              color: Color.fromARGB(255, 88, 87, 87),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0.0, 5.0),
            )
        ],
      ),
      child: Row(
        children: [
          // Image à gauche avec un fond bleu
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: imageSize, // Largeur définie pour l'image
              height: height,
              decoration: BoxDecoration(
                color: imageBackgroundColor,
                borderRadius: BorderRadius.circular(borderRadius)
              ),
               // Fond bleu pour l'image
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(borderRadius),
                child: image,
              ),
            ),
          ),
          // Espace entre l'image et le texte
          const SizedBox(width: 10),
          // Texte à droite
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: textSize, // Taille du texte personnalisée
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
