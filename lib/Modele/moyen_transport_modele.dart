class MoyenDeTransport {
  String id;
  String type;
  double prixParKm;

  MoyenDeTransport({
    required this.id,
    required this.type,
    required this.prixParKm,
  });

  factory MoyenDeTransport.fromFirestore(Map<String, dynamic> data, String id) {
    return MoyenDeTransport(
      id: id,
      type: data['type'] ?? '',
      prixParKm: data['prixParKm']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'type': type,
      'prixParKm': prixParKm,
    };
  }
}