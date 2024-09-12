import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weatherapp/model/weather_model.dart';

class WeatherRepository {
  final String apiKey =
      '9655cc0b7f1f78ea68cac5236d885963'; 
  final String apiUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String city) async {
    print(city);
    final response =
        await http.get(Uri.parse('$apiUrl?q=$city&appid=$apiKey&units=metric'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      print("error");
      throw Exception('Error fetching weather data');
    }
  }
}
