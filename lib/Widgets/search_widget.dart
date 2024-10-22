import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String placehoder;
  final double longueur;
  final double largeur;
  final double radius;
  final Icon icon;
  final Color iconColor;
  final Color backgroundColor;
  final ValueChanged<String>? onChanged; // Ajoutez ce paramètre

  // ignore: use_super_parameters
  const SearchWidget({
    Key? key,
    required this.placehoder,
    required this.longueur,
    required this.largeur,
    required this.radius,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.onChanged, // Ajoutez ce paramètre ici
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text); // Appelle la fonction lors de la modification du texte
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller, // Ajoutez le contrôleur ici
      decoration: InputDecoration(
        fillColor: widget.backgroundColor,
        filled: true,
        suffixIcon: Container(
          width: widget.largeur,
          height: widget.longueur,
          margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.radius),
          ),
          padding: const EdgeInsets.all(6),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xff0B8FAC),
              borderRadius: BorderRadius.circular(9),
            ),
            padding: const EdgeInsets.all(10),
            child: Icon(
              Icons.search,
              color: widget.iconColor,
              size: 18,
            ),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: widget.placehoder,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Nettoyez le contrôleur à la fin
    super.dispose();
  }
}
