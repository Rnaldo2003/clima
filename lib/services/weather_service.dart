import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:clima/model/weather_model.dart';

class WeatherService {
  final String apiKey = 'a60164a2b41a71950687f4bac04001fe';

  Future<Weather> fetchWeather(String city) async {
    final url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=es',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al cargar el clima');
    }
  }
}