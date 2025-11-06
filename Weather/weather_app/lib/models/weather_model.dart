class WeatherModel {
  final String city;
  final String country;
  final double temp;
  final int humidity;
  final String description;

  WeatherModel({
    required this.city,
    required this.country,
    required this.temp,
    required this.humidity,
    required this.description,
  });

  factory WeatherModel.fromJson(Map cityData, Map forecastData) {
    return WeatherModel(
      city: cityData['name'],
      country: cityData['sys']['country'],
      temp: forecastData['current']['temp'].toDouble(),
      humidity: forecastData['current']['humidity'],
      description: forecastData['current']['weather'][0]['description'],
    );
  }
}
