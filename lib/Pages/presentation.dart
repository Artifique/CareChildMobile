import 'package:accessability/Pages/splash.dart';
import 'package:flutter/material.dart';

class Presentation extends StatefulWidget {
  const Presentation({super.key});

  @override
  State<Presentation> createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {

  @override
  void initState() {
    super.initState();
    
    // Délai de 2 secondes avant de naviguer vers la page suivante
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const Splash()), // Remplace NextPage par ta page suivante
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image(image: AssetImage('images/care.png')),
      ),
    );
  }
}

