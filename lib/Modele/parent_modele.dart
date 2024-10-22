import 'package:accessability/Modele/users_modele.dart';

class Parent extends Users {
  Parent({
    required super.id,
    required super.nom,
    required super.email,
    required super.mdp,
    required super.adresse,
    required super.image,
    required super.tel,
    super.role = 'PARENT',
  });

  factory Parent.fromFirestore(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      mdp: json['mdp'],
      adresse: json['adresse'],
      image: json['image'],
      tel: json['tel'],
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
