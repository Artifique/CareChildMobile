import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LatLng _initialposition = const LatLng(37.7749, -122.4194);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: const Text('Google Map '),
        centerTitle: true,
       ),
       body: GoogleMap(initialCameraPosition: CameraPosition(target: _initialposition,zoom: 10.0),),
    );
  }
}