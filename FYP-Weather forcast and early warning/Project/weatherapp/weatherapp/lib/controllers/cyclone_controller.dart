// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import 'package:shared_preferences/shared_preferences.dart';

// class CycloneController extends GetxController {
//   Future<List<LatLng>> fetchCyclonePath() async {
//     debugPrint('Fetching cyclone path');
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final baseUrl = prefs.getString('baseUrl') ?? '';
//       debugPrint('Base URL: $baseUrl');

//       if (baseUrl.isEmpty) throw Exception('Base URL not set');

//       final response = await http.get(Uri.parse('$baseUrl/cyclone-path'));
//       if (response.statusCode == 200) {
//         List<dynamic> data = jsonDecode(response.body);
//         return data
//             .map((item) => LatLng(item['latitude'], item['longitude']))
//             .toList()
//             .sublist(0, 100);
//       } else {
//         Get.snackbar('Error', 'Failed to load cyclone path');
//         debugPrint('Request failed with status: ${response.statusCode}');
//         throw Exception('Failed to load cyclone path');
//       }
//     } catch (e) {
//       debugPrint('Error: $e');
//       Get.snackbar('Error', 'Failed to load cyclone path');
//       throw Exception('Failed to load cyclone path');
//     }
//   }
// }
// cyclone_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/models/cyclone_model.dart';
import 'dart:convert';

class CycloneController extends GetxController {
  Future<List<CyclonePoint>> fetchCyclonePath() async {
    debugPrint('Fetching cyclone path');
    try {
      final prefs = await SharedPreferences.getInstance();
      final baseUrl = prefs.getString('baseUrl') ?? '';
      debugPrint('Base URL: $baseUrl');

      if (baseUrl.isEmpty) throw Exception('Base URL not set');

      final response = await http.get(Uri.parse('$baseUrl/cyclone-path'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((item) => CyclonePoint.fromJson(item))
            .toList()
            .sublist(0, 25); // Optional: Limit to 100
      } else {
        Get.snackbar('Error', 'Failed to load cyclone path');
        debugPrint('Request failed with status: ${response.statusCode}');
        throw Exception('Failed to load cyclone path');
      }
    } catch (e) {
      debugPrint('Error: $e');
      Get.snackbar('Error', 'Failed to load cyclone path');
      throw Exception('Failed to load cyclone path');
    }
  }
}
