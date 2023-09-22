class WeatherData {
  final String cityName;
  final double temperature;
  final String condition;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.condition,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['description'],
    );
  }
}
