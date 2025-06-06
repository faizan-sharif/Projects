// controllers/weather_controller.dart
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:weatherapp/models/weather_model.dart';

class WeatherController extends GetxController {
  var isLoading = true.obs;
  var isMenuVisible = false.obs;
  var weather = Rxn<WeatherModel>();
  RxString location = "".obs;

  Future<void> getCurrentLocationWeather() async {
    try {
      isLoading(true);

      // API call code here...
      final data = await fetchWeatherFromApi();

      weather.value = WeatherModel.fromJson(data);
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading(false);
    }
  }

  static const String apiKey = "e7704bc895b4a8d2dfd4a29d404285b6";

  final List<String> notifications = [
    "☀️ Clear skies today, enjoy your day!",
    "🌧️ Light rain expected this evening.",
    "🌩️ Thunderstorms likely in some areas.",
    "🌬️ Windy conditions ahead, secure loose items.",
    "🌫️ Fog in the early morning, drive safely.",
  ];

  @override
  void onInit() {
    super.onInit();
    getCurrentLocationWeather();
  }

  // void updateDateTime() {
  //   dateTime.value = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  // }

  fetchWeatherFromApi() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        fetchWeatherByCity('Vehari');
        return;
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      location.value = placemarks.first.locality ?? "Vehari";
      return fetchWeatherByCoords(position.latitude, position.longitude);
    } catch (e) {
      return fetchWeatherByCity(location.value);
    }
  }

  Future<void> fetchWeatherByCoords(double lat, double lon) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch weather data");
      return;
    }
  }

  fetchWeatherByCity(String city) async {
    final url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch weather data");
      return;
    }
  }
}
