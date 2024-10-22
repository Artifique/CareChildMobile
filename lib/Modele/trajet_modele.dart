import 'package:cloud_firestore/cloud_firestore.dart';

class Trajet {
  String depart;
  String arrivee;
  double distance;
  double prix;
  GeoPoint coordonneesDepart;
  GeoPoint coordonneesArrivee;

  Trajet({
    required this.depart,
    required this.arrivee,
    required this.distance,
    required this.prix,
    required this.coordonneesDepart,
    required this.coordonneesArrivee,
  });
}