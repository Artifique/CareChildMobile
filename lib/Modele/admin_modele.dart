import 'package:accessability/Modele/users_modele.dart';

class Admin extends Users {
  // ignore: use_super_parameters
  Admin({
    required super.id,
    required super.nom,
    required super.email,
    required super.mdp,
    required super.adresse,
    required super.image,
    required super.tel,
    String role = 'ADMIN', // Initialisation par défaut à ADMIN
  }) : super(role: role); // Passe le rôle au constructeur parent

  factory Admin.fromFirestore(Map<String, dynamic> json) {
    return Admin(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      mdp: json['mdp'],
      adresse: json['adresse'],
      image: json['image'],
      tel: json['tel'],
      // Le rôle est fixé à ADMIN par défaut
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
    };
  }
}
