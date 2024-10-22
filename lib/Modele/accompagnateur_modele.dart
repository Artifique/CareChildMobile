import 'package:accessability/Modele/users_modele.dart';

class Accompagnateur extends Users {
  final String adminId; // Clé étrangère (ID du document Admin)

  // ignore: use_super_parameters
  Accompagnateur({
    required super.id,
    required super.nom,
    required super.email,
    required super.mdp,
    required super.adresse,
    required super.image,
    required super.tel,
    String role = 'ACCOMPAGNATEUR', // Initialisation par défaut à ACCOMPAGNATEUR
    required this.adminId,
  }) : super(role: role); // Passe le rôle au constructeur parent

  factory Accompagnateur.fromFirestore(Map<String, dynamic> json) {
    return Accompagnateur(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      mdp: json['mdp'],
      adresse: json['adresse'],
      image: json['image'],
      tel: json['tel'],
      adminId: json['adminId'],
      // Le rôle est fixé à ACCOMPAGNATEUR par défaut
    );
  }

  @override
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'nom': nom,
      'email': email,
      'mdp': mdp,
      'adresse': adresse,
      'image': image,
      'tel': tel,
      'role': role,
      'adminId': adminId,
    };
  }
}
