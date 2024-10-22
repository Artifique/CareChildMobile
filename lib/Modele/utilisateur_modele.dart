class Utilisateur {
 final String id;
   String nom;
   String email;
   String mdp;
   String adresse;  
   String? image;
   String tel;
   String role;

  Utilisateur({
    required this.id,
    required this.nom,
    required this.email,
    required this.mdp,
    required this.adresse,
    required this.image,
    required this.tel,
    required this.role,
  });

  // Créer une copie de l'objet avec certains champs modifiés
  Utilisateur copyWith({
    String? id,
    String? nom,
    String? email,
    String? mdp,
    String? adresse,
    String? image,
    String? tel,
    String? role,
  }) {
    return Utilisateur(
      id: id ?? this.id,
      nom: nom ?? this.nom,
      email: email ?? this.email,
      mdp: mdp ?? this.mdp,
      adresse: adresse ?? this.adresse,
      image: image ?? this.image,
      tel: tel ?? this.tel,
      role: role ?? this.role,
    );
  }

  // Convertir un utilisateur en format Firestore
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

  // Créer un utilisateur depuis Firestore
  factory Utilisateur.fromFirestore(Map<String, dynamic> data, String id) {
    return Utilisateur(
      id: id,
      nom: data['nom'],
      email: data['email'],
      mdp: data['mdp'],
      adresse: data['adresse'],
      image: data['image'],
      tel: data['tel'],
      role: data['role'],
    );
  }
}
