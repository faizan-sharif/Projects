import 'package:flutter/material.dart';

class TornadosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tornados")),
      backgroundColor: Colors.grey[900],
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildCard(
              "Tornado Warning", "Severe tornado detected in southern region."),
          _buildCard(
              "Watch Issued", "Conditions favorable for tornado formation."),
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
