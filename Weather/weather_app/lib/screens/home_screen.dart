import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/weather_api.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  Map<String, dynamic>? _weather;
  String? _backgroundUrl;
  bool _loading = false;

  Future<void> _getWeather(String city) async {
    setState(() => _loading = true);
    try {
      final data = await WeatherApi().fetchWeather(city);
      final condition = data['weather'][0]['main'].toString().toLowerCase();
      final isDaytime = _isDaytime(data);

      final keyword = _getWeatherMood(condition, isDaytime);
      final imageUrl = await _fetchCityImage(city, keyword);

      setState(() {
        _weather = data;
        _backgroundUrl = imageUrl;
      });
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  /// Determine if it's daytime at the city location
  bool _isDaytime(Map<String, dynamic> weatherData) {
    final currentTime =
        DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000; // seconds
    final sunrise = weatherData['sys']?['sunrise'] ?? 0;
    final sunset = weatherData['sys']?['sunset'] ?? 0;

    return currentTime >= sunrise && currentTime < sunset;
  }

  /// Return descriptive keyword for Pexels query (city + mood + time of day)
  String _getWeatherMood(String condition, bool isDaytime) {
    if (condition.contains('rain')) return isDaytime ? 'rainy city daytime' : 'rainy city night';
    if (condition.contains('cloud')) return isDaytime ? 'cloudy skyline daytime' : 'cloudy skyline night';
    if (condition.contains('snow')) return isDaytime ? 'snowy city day' : 'snowy city night';
    if (condition.contains('clear')) return isDaytime ? 'sunny city day' : 'night city lights';
    if (condition.contains('storm') || condition.contains('thunder')) {
      return isDaytime ? 'stormy city clouds' : 'lightning storm city night';
    }
    return isDaytime ? 'daytime cityscape' : 'city skyline at night';
  }

  /// Fetch image from Pexels based on city + mood
  Future<String?> _fetchCityImage(String city, String mood) async {
    final apiKey = dotenv.env['PEXELS_API_KEY'];
    final url = Uri.parse(
        'https://api.pexels.com/v1/search?query=$city+$mood&orientation=landscape&per_page=1');

    final response = await http.get(url, headers: {'Authorization': apiKey ?? ''});

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['photos'] != null && jsonData['photos'].isNotEmpty) {
        return jsonData['photos'][0]['src']['large2x'];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final city = _weather?['name'] ?? 'Enter a city';
    final temp = _weather?['main']?['temp']?.toStringAsFixed(1) ?? '--';
    final desc = _weather?['weather']?[0]?['description'] ?? '';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: _backgroundUrl != null
                ? CachedNetworkImage(
                    key: ValueKey(_backgroundUrl),
                    imageUrl: _backgroundUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        Container(color: Colors.grey.shade300),
                    errorWidget: (context, url, error) =>
                        Container(color: Colors.grey.shade400),
                  )
                : Container(color: Colors.grey.shade300),
          ),
          Container(color: Colors.black.withOpacity(0.45)),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) => _getWeather(value),
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.85),
                      hintText: 'Search city...',
                      hintStyle: const TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  if (_loading)
                    const CircularProgressIndicator(color: Colors.white)
                  else if (_weather != null) ...[
                    Text(
                      city,
                      style: const TextStyle(
                        fontSize: 38,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$temp°C',
                      style: const TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Text(
                      desc.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
