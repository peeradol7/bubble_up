import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;

  final LatLng _initialLocation = const LatLng(13.7563, 100.5018); // Bangkok
  final LatLng _newLocation =
      const LatLng(13.7312, 100.5228); // Another location

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Google Map Example")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _initialLocation,
          zoom: 12.0,
        ),
        onMapCreated: (controller) {
          _mapController = controller;
        },
        markers: {
          Marker(
            markerId: const MarkerId("initial"),
            position: _initialLocation,
            infoWindow: const InfoWindow(title: "Bangkok"),
          ),
          Marker(
            markerId: const MarkerId("new_location"),
            position: _newLocation,
            infoWindow: const InfoWindow(title: "New Location"),
          ),
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _moveCameraToNewLocation,
        child: const Icon(Icons.location_searching),
      ),
    );
  }

  void _moveCameraToNewLocation() {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(_newLocation),
      );
    }
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
