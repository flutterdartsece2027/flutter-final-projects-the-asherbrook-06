// packages
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

// models
import '../models/AutoServiceCenter.dart';

Future<List<AutoServiceCenter>> fetchNearbyCentersSorted(LatLng currentLocation, {double radiusInMeters = 5000}) async {
  final snapshot = await FirebaseFirestore.instance.collection('auto_service_centers').get();
  List<AutoServiceCenter> nearby = [];

  for (var doc in snapshot.docs) {
    final data = doc.data();
    final LatLng centerPos = LatLng(data['latitude'], data['longitude']);
    double distance = Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      centerPos.latitude,
      centerPos.longitude,
    );

    if (distance <= radiusInMeters) {
      nearby.add(AutoServiceCenter(
        id: doc.id,
        name: data['name'],
        location: centerPos,
        distance: distance,
      ));
    }
  }

  nearby.sort((a, b) => (a.distance ?? 0).compareTo(b.distance ?? 0));
  return nearby;
}
