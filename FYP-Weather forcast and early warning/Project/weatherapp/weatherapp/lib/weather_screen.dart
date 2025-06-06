import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'screens/tornados.dart';
import 'screens/cyclones.dart';
import 'screens/heavy_rain_flood.dart';
import 'screens/settings.dart';
import 'screens/feedback.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  String _temperature = "Loading...";
  String _description = "Loading...";
  String _dateTime = "Fetching time...";
  String _location = "Current Location";
  bool _isMenuVisible = false;
  bool _isLoading = true;

  static const String apiKey = "e7704bc895b4a8d2dfd4a29d404285b6";
  final List<String> notifications = [
    "☀️ Clear skies today, enjoy your day!",
    "🌧️ Light rain expected this evening.",
    "🌩️ Thunderstorms likely in some areas.",
    "🌬️ Windy conditions ahead, secure loose items.",
    "🌫️ Fog in the early morning, drive safely.",
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocationWeather();
    Future.delayed(Duration(seconds: 2), showRealtimeNotification);
  }

  void _updateDateTime() {
    setState(() {
      _dateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    });
  }

  Future<void> _getCurrentLocationWeather() async {
    setState(() {
      _isLoading = true;
    });

    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        _fetchWeatherByCity("Vehari");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String city = placemarks.first.locality ?? "Vehari";

      setState(() {
        _location = city;
      });

      _fetchWeatherByCoords(position.latitude, position.longitude);
    } catch (e) {
      _fetchWeatherByCity("Vehari");
    }
  }

  Future<void> _fetchWeatherByCoords(double lat, double lon) async {
    final String url =
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _temperature = "${data['main']['temp']}\u00b0C";
          _description = data['weather'][0]['description'];
          _isLoading = false;
          _updateDateTime();
        });
      } else {
        _showError("Error fetching weather data.");
      }
    } catch (e) {
      _showError("Failed to load weather data: $e");
    }
  }

  Future<void> _fetchWeatherByCity(String city) async {
    final String url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _location = city;
          _temperature = "${data['main']['temp']}\u00b0C";
          _description = data['weather'][0]['description'];
          _isLoading = false;
          _updateDateTime();
        });
      } else {
        _showError("City not found.");
      }
    } catch (e) {
      _showError("Failed to load weather: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _navigateToDetailScreen(String title) {
    Widget page;
    switch (title) {
      case 'Tornados':
        page = TornadosScreen();
        break;
      case 'Cyclones':
        page = CyclonesScreen();
        break;
      case 'Heavy Rain and Floods':
        page = HeavyRainFloodsScreen();
        break;
      case 'Settings':
        page = SettingsScreen();
        break;
      case 'Feedback':
        page = FeedbackScreen();
        break;
      default:
        page = Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Center(child: Text("No data available.")),
        );
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  void showRealtimeNotification() {
    final random = Random();
    final message = notifications[random.nextInt(notifications.length)];

    final overlay = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(12),
          color: Colors.indigo,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Icon(Icons.notifications_active, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlay);
    Future.delayed(Duration(seconds: 4), () => overlay.remove());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        title: Text("Weather Forecast"),
        backgroundColor: Colors.blueGrey[700],
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            setState(() {
              _isMenuVisible = !_isMenuVisible;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: showRealtimeNotification,
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final result = await showSearch<String?>(
                context: context,
                delegate: CitySearchDelegate(),
              );
              if (result != null) {
                setState(() => _isLoading = true);
                _fetchWeatherByCity(result);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _getCurrentLocationWeather,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: _isLoading
                ? CircularProgressIndicator(color: Colors.white)
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_location,
                          style: TextStyle(fontSize: 24, color: Colors.white)),
                      SizedBox(height: 5),
                      Text(_dateTime,
                          style:
                              TextStyle(fontSize: 16, color: Colors.white70)),
                      SizedBox(height: 20),
                      Text(_temperature,
                          style: TextStyle(fontSize: 40, color: Colors.white)),
                      SizedBox(height: 10),
                      Text(_description,
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ],
                  ),
          ),
          if (_isMenuVisible)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  _buildMenuItem('Tornados'),
                  _buildMenuItem('Cyclones'),
                  _buildMenuItem('Heavy Rain and Floods'),
                  _buildMenuItem('Settings'),
                  _buildMenuItem('Feedback'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title) {
    return Card(
      color: Colors.blueGrey[800],
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: () => _navigateToDetailScreen(title),
      ),
    );
  }
}

class CitySearchDelegate extends SearchDelegate<String?> {
  final List<String> suggestions = [
    "Islamabad",
    "Lahore",
    "Karachi",
    "Faisalabad",
    "Rawalpindi",
    "Multan",
    "Peshawar",
    "Quetta",
    "Vehari",
    "Hyderabad",
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      title: Text("Search weather for: $query"),
      onTap: () => close(context, query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filtered = suggestions
        .where((city) => city.toLowerCase().startsWith(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(filtered[index]),
        onTap: () => close(context, filtered[index]),
      ),
    );
  }
}
