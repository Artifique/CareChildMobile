// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CustumLieu extends StatefulWidget {
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
  const CustumLieu({
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
  State<CustumLieu> createState() => _CustumLieuState();
}

class _CustumLieuState extends State<CustumLieu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
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
              width: widget.imageSize, // Largeur définie pour l'image
              height: widget.height,
              decoration: BoxDecoration(
                color: widget.imageBackgroundColor,
                borderRadius: BorderRadius.circular(widget.borderRadius)
              ),
               // Fond bleu pour l'image
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                child: widget.image,
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
                  widget.text,
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: widget.textSize, // Taille du texte personnalisée
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