class Users {
  String id;
  String nom;
  String email;
  String mdp;
  String adresse;
  String image;
  String tel;
  String role;

  Users({
    required this.id,
    required this.nom,
    required this.email,
    required this.mdp,
    required this.adresse,
    required this.image,
    required this.tel,
    required this.role,

  });

  factory Users.fromFirestore(Map<String, dynamic> json) {
    return Users(
      id: json['id'],
      nom: json['nom'],
      email: json['email'],
      mdp: json['mdp'],
      adresse: json['adresse'],
      image: json['image'],
      tel: json['tel'],
      role: json['role'],
   
    );
  }

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
