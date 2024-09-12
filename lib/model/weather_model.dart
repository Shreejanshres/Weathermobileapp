class Weather {
  String city;
  double temperature;
  int pressure;
  int humidity;
  int precipitation;
  String description;
  double windSpeed;
  int sunrise;
  int sunset;

  Weather({
    required this.city,
    required this.temperature,
    required this.pressure,
    required this.humidity,
    required this.precipitation,
    required this.description,
    required this.windSpeed,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      temperature: json['main']['temp'],
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
      precipitation: json['clouds']['all'],
      description: json['weather'][0]['description'],
      windSpeed: json['wind']['speed'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
    );
  }
}
