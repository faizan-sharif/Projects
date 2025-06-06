// models/weather_model.dart
class WeatherModel {
  final String location;
  final String dateTime;
  final String temperature;
  final String description;
  final String feelsLike;
  final String tempMin;
  final String tempMax;
  final String humidity;
  final String pressure;
  final String windSpeed;
  final String visibility;
  final String cloudiness;
  final String icon;

  WeatherModel({
    required this.location,
    required this.dateTime,
    required this.temperature,
    required this.description,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.visibility,
    required this.cloudiness,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      location: json['name'] ?? '',
      dateTime: DateTime.fromMillisecondsSinceEpoch(
        json['dt'] * 1000,
        isUtc: true,
      ).toLocal().toString(),
      temperature: "${json['main']['temp']}°C",
      description: json['weather'][0]['description'] ?? '',
      feelsLike: "${json['main']['feels_like']}°C",
      tempMin: "${json['main']['temp_min']}°C",
      tempMax: "${json['main']['temp_max']}°C",
      humidity: "${json['main']['humidity']}%",
      pressure: "${json['main']['pressure']} hPa",
      windSpeed: "${json['wind']['speed']} m/s",
      visibility: "${json['visibility']} m",
      cloudiness: "${json['clouds']['all']}%",
      icon: json['weather'][0]['icon'] ?? '',
    );
  }
}
