// models/cyclone_point.dart
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CyclonePoint {
  final double latitude;
  final double longitude;
  final String name;

  CyclonePoint({
    required this.latitude,
    required this.longitude,
    required this.name,
  });

  factory CyclonePoint.fromJson(Map<String, dynamic> json) {
    return CyclonePoint(
      latitude: json['latitude'],
      longitude: json['longitude'],
      name: json['name'] ?? '',
    );
  }

  LatLng toLatLng() => LatLng(latitude, longitude);
}
