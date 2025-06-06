import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CyclonesScreen extends StatefulWidget {
  @override
  _CyclonesScreenState createState() => _CyclonesScreenState();
}

class _CyclonesScreenState extends State<CyclonesScreen> {
  List<LatLng> cyclonePath = [];

  @override
  void initState() {
    super.initState();
    loadCyclonePath();
  }

  Future<void> loadCyclonePath() async {
    try {
      final String csvData =
          await rootBundle.loadString('assets/cyclone_data.csv');
      final List<String> lines = csvData.split('\n');

      List<LatLng> path = [];
      for (var line in lines.skip(1)) {
        if (line.trim().isEmpty) continue;
        final parts = line.split(',');
        final lat = double.tryParse(parts[0]);
        final lng = double.tryParse(parts[1]);
        if (lat != null && lng != null) {
          path.add(LatLng(lat, lng));
        }
      }

      setState(() {
        cyclonePath = path;
      });
    } catch (e) {
      print("Error loading cyclone path from CSV: $e");
    }
  }

  Widget _buildCard(String title, String description) {
    return Card(
      color: Colors.grey[800],
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        subtitle: Text(description, style: TextStyle(color: Colors.white70)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();

    return Scaffold(
      appBar: AppBar(title: const Text("Cyclones")),
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildCard("Cyclone", "Expected to make landfall near coast."),
                _buildCard(
                    "Cyclone Alert", "High winds and storm surge predicted."),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: cyclonePath.isEmpty
                ? Center(child: CircularProgressIndicator())
                : FlutterMap(
                    mapController: mapController,
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.weatherapp',
                      ),
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: cyclonePath,
                            color: Colors.red,
                            strokeWidth: 4.0,
                          ),
                        ],
                      ),
                    ],
                    options: MapOptions(
                      initialCenter: cyclonePath.first,
                      initialZoom: 5.5,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
