import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    int id = 0,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'weather_channel_id',
      'Weather Alerts',
      channelDescription: 'Notifications for rain, storm, and cloudy weather.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);
    await _notifications.show(id, title, body, details);
  }

  // Notify for specific weather conditions
  void checkForAlerts(Map<String, dynamic> weatherJson) {
    final weatherMain =
        weatherJson['weather'][0]['main'].toString().toLowerCase();
    final description = weatherJson['weather'][0]['description'].toString();

    if (weatherMain.contains('rain') || description.contains('rain')) {
      NotificationService.showNotification(
        title: '🌧️ Rain Alert',
        body:
            'It looks like it\'s going to rain in ${weatherJson['name']}. Don\'t forget your umbrella!',
      );
    } else if (weatherMain.contains('storm') ||
        description.contains('storm') ||
        weatherJson['wind']['speed'] > 10) {
      NotificationService.showNotification(
        title: '⛈️ Storm Alert',
        body: 'Stormy weather expected in ${weatherJson['name']}. Stay safe!',
      );
    } else if (weatherMain.contains('cloud') || description.contains('cloud')) {
      NotificationService.showNotification(
        title: '☁️ Cloudy Weather',
        body:
            'It\'s cloudy in ${weatherJson['name']}. You might not need sunglasses!',
      );
    }
  }
}
