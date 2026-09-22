import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherData {
  final double temperature;
  final int weatherCode;

  WeatherData({
    required this.temperature, 
    required this.weatherCode
    });

  String get conditionText {
    switch (weatherCode) {
      case 0:
        return "ท้องฟ้าแจ่มใส";
      case 1:
      case 2:
      case 3:
        return 'มีเมฆ';
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
      case 80:
      case 81:
      case 82:
        return 'ฝนตก';
      case 95:
        return 'พายุฝนฟ้าคะนอง';
      default:
        return 'ไม่ทราบสภาพอากาศ';
    }
  }
}

class WeatherService {
  Future<WeatherData> getKampheangsaenWeather() async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=14.0268'
      '&longitude=99.9947'
      '&current=temperature_2m,weather_code'
      '&timezone=Asia%2FBangkok'
    );

    final response = await http.get(url);

    if(response.statusCode != 200){
      throw Exception("ไม่สามารถโหลดข้อมูลสภาพอากาศได้");
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final current = data['current'] as Map<String, dynamic>;

    return WeatherData(
      temperature: (current['temperature_2m'] as num).toDouble(),
      weatherCode: current['weather_code'] as int,
    );
  }
}
