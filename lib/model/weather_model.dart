class Weather {
  final double temperature;
  final String description;
  final double windSpeed;

  Weather({
    required this.temperature,
    required this.description,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }
}