// screens/weather/weather_screen.dart
// ... other imports
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controllers/auth_controller.dart';
import 'package:weatherapp/controllers/weather_controller.dart';
import 'package:weatherapp/screens/weather/weather_menu_item.dart';

import '../../models/weather_model.dart'; // Import the model

class WeatherScreen extends StatelessWidget {
  WeatherScreen({super.key});

  final WeatherController weatherController = Get.put(WeatherController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: const Text("Weather Forecast"),
        backgroundColor: Colors.blueGrey[700],
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            weatherController.isMenuVisible.toggle();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Get.find<AuthController>().logout();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: weatherController.getCurrentLocationWeather,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Obx(() {
              if (weatherController.isLoading.value) {
                return const CircularProgressIndicator(color: Colors.white);
              }
              final weather = weatherController.weather.value;
              if (weather == null) {
                return const Text(
                  "No weather data",
                  style: TextStyle(color: Colors.white),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weather.location,
                      style: const TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weather.dateTime,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Weather Icon
                    if (weather.icon.isNotEmpty)
                      Image.network(
                        'https://openweathermap.org/img/wn/${weather.icon}@2x.png',
                        width: 100,
                        height: 100,
                      ),

                    const SizedBox(height: 10),
                    Text(
                      weather.temperature,
                      style: const TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      weather.description.capitalizeFirst ?? '',
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Divider(color: Colors.white38),
                    const SizedBox(height: 10),

                    _buildInfoRow("Feels Like", weather.feelsLike),
                    _buildInfoRow("Min Temperature", weather.tempMin),
                    _buildInfoRow("Max Temperature", weather.tempMax),
                    _buildInfoRow("Humidity", weather.humidity),
                    _buildInfoRow("Pressure", weather.pressure),
                    _buildInfoRow("Wind Speed", weather.windSpeed),
                    _buildInfoRow("Visibility", weather.visibility),
                    _buildInfoRow("Cloudiness", weather.cloudiness),
                  ],
                ),
              );
            }),
          ),

          Obx(
            () => weatherController.isMenuVisible.value
                ? Container(
                    color: Colors.black.withOpacity(0.7),
                    child: ListView(
                      padding: const EdgeInsets.all(20),
                      children: const [
                        WeatherMenuItem(title: 'Tornados'),
                        WeatherMenuItem(title: 'Cyclones'),
                        WeatherMenuItem(title: 'Heavy Rain and Floods'),
                        WeatherMenuItem(title: 'Settings'),
                        WeatherMenuItem(title: 'Feedback'),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
