import 'package:accessability/Pages/login.dart';
import 'package:accessability/Pages/my_navbar.dart';
import 'package:accessability/Pages/presentation.dart';
import 'package:accessability/Pages/register.dart'; // Import de la page Register
import 'package:accessability/Services/utilisateur_service.dart'; // Import du service utilisateur
import 'package:accessability/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart'; // Import App Check
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  final UtilisateurService utilisateurService = UtilisateurService();
  
  // Créer l'admin par défaut si nécessaire
  await utilisateurService.createDefaultAdmin();

  // Initialiser App Check
  await FirebaseAppCheck.instance.activate(
    // webProvider: FirebaseAppCheckWebProvider.reCaptchaV3, // Pour le web si nécessaire
    androidProvider: AndroidProvider.playIntegrity, // Play Integrity pour Android
    // Si tu choisis SafetyNet au lieu de Play Integrity, utilise ceci :
    // androidProvider: AndroidProvider.safetyNet,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const Presentation(),
      routes: {
        '/register': (context) => const Register(),
        '/utilisateurs': (context) => const MyNavbar(),
        '/login': (context) => const Login(),
      },
    );
  }
}
