import 'package:flutter/material.dart';
import '../services/weather_api.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _cityController = TextEditingController();
  String _weatherInfo = "Enter a city";
  bool _loading = false;

  Future<void> _fetchWeather() async {
    if (_cityController.text.isEmpty) return;

    setState(() => _loading = true);

    try {
      final data = await WeatherAPI.fetchWeather(_cityController.text);
      setState(() {
        _weatherInfo =
            "${data.city}, ${data.country}\nTemp: ${data.temp}°C\nHumidity: ${data.humidity}%\n${data.description}";
      });
    } catch (e) {
      setState(() => _weatherInfo = "Error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'Enter city name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: _loading
                  ? const CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2)
                  : const Text('Get Weather'),
            ),
            const SizedBox(height: 32),
            Text(
              _weatherInfo,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
