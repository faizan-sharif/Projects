// screens/weather/widgets/weather_menu_item.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeatherMenuItem extends StatelessWidget {
  final String title;

  const WeatherMenuItem({super.key, required this.title});

  void _navigateToDetailScreen(String title) {
    // Dummy navigation
    Get.snackbar('Navigation', 'You tapped on $title');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey[800],
      child: ListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () => _navigateToDetailScreen(title),
      ),
    );
  }
}
