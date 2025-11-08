import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';
import '../utils/constraints.dart';

class WeatherAPI {
  static Future<WeatherModel> fetchWeather(String city) async {
    // 1️⃣ Get city coordinates
    final cityUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey';
    final cityRes = await http.get(Uri.parse(cityUrl));
    if (cityRes.statusCode != 200) throw Exception("City not found");

    final cityData = jsonDecode(cityRes.body);
    final lat = cityData['coord']['lat'];
    final lon = cityData['coord']['lon'];

    // 2️⃣ Get One Call API weather details
    final oneCallUrl =
        'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&units=metric&appid=$apiKey';
    final forecastRes = await http.get(Uri.parse(oneCallUrl));
    if (forecastRes.statusCode != 200) throw Exception("Weather data not found");

    final forecastData = jsonDecode(forecastRes.body);

    return WeatherModel.fromJson(cityData, forecastData);
  }
}
