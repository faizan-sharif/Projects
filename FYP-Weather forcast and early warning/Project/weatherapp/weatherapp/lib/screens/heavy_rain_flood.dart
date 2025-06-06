import 'package:flutter/material.dart';

class HeavyRainFloodsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Heavy Rain & Floods")),
      backgroundColor: Colors.grey[900],
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildCard(
              "Flood Alert", "Rivers near danger levels in multiple areas."),
          _buildCard("Heavy Rain Forecast", "Expected rainfall exceeds 100mm."),
        ],
      ),
    );
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
}
