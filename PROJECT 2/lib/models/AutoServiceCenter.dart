// packages
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AutoServiceCenter {
  final String id;
  final String name;
  final LatLng location;
  final double? distance;

  AutoServiceCenter({
    required this.id,
    required this.name,
    required this.location,
    this.distance,
  });
}
