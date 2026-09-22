
import 'package:final_project/services/weather_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _weatherService = WeatherService();
  late Future<WeatherData> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _weatherFuture = _weatherService.getKampheangsaenWeather();
  }

  IconData _weatherIcon(int weatherCode) {
    if (weatherCode == 0) return Icons.wb_sunny;
    if (weatherCode >= 51 && weatherCode <= 82) {
      return Icons.umbrella;
    }
    if (weatherCode == 95) return Icons.thunderstorm;
    return Icons.cloud;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder<WeatherData>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return const Text('ไม่สามารถโหลดข้อมูลอากาศได้');
                  }

                  final weather = snapshot.data!;

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        _weatherIcon(weather.weatherCode),
                        color: Colors.orange,
                        size: 40,
                      ),
                      title: const Text('สภาพอากาศ'),
                      subtitle: Text(weather.conditionText),
                      trailing: Text(
                        '${weather.temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // TextButton(
              //   onPressed: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (_) => ),
              //   ),
              //   child: const Text('Reservation Page'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}