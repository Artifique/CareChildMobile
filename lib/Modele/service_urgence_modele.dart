class ServiceUrgence {
  String id;
  String nom;
  String numero;

  ServiceUrgence({required this.id, required this.nom, required this.numero});

  factory ServiceUrgence.fromFirestore(Map<String, dynamic> data, String id) {
    return ServiceUrgence(
      id: id,
      nom: data['nom'] ?? '',
      numero: data['numero'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
      'numero': numero,
    };
  }
}
