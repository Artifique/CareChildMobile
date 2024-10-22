import 'package:flutter/material.dart';

class MeteoApi extends StatefulWidget {
  const MeteoApi({super.key});

  @override
  State<MeteoApi> createState() => _MeteoApiState();
}

class _MeteoApiState extends State<MeteoApi> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 45, 149, 209),
    );
  }
}