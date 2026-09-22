import 'package:flutter/material.dart';
import '../app_theme.dart';
import '../services/weather_service.dart';
import '../pages/item/item_screen.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final _weatherService = WeatherService();
  late Future<WeatherData> _weatherFuture;

  static const List<String> _rules = [
    'งดส่งเสียงดังรบกวนผู้อื่น ในช่วงเวลา 22:00 - 06:00 น.',
    'ห้ามสูบบุหรี่และดื่มเครื่องดื่มแอลกอฮอล์ภายในอาคาร',
    'ห้ามนำสัตว์เลี้ยงทุกชนิดเข้าพักภายในหอพัก',
    'กรุณาคืน/จองอุปกรณ์ส่วนกลางตามเวลาที่กำหนด',
    'ช่วยกันดูแลรักษาความสะอาดพื้นที่ส่วนกลาง',
    'ห้ามนำบุคคลภายนอกค้างคืนโดยไม่แจ้งผู้ดูแลหอพัก',
    'ปิดไฟ ปิดแอร์ ทุกครั้งเมื่อไม่ได้ใช้งานพื้นที่ส่วนกลาง',
  ];

  static const List<Map<String, String>> _contacts = [
    {'title': 'ผู้ดูแลหอพัก', 'subtitle': '081-234-5678'},
    {'title': 'เจ้าหน้าที่รักษาความปลอดภัย (รปภ.)', 'subtitle': '081-234-5679'},
    {'title': 'แม่บ้าน / ทำความสะอาด', 'subtitle': '081-234-5680'},
    {'title': 'เบอร์ฉุกเฉิน (ตำรวจ)', 'subtitle': '191'},
    {'title': 'เบอร์ฉุกเฉิน (การแพทย์ฉุกเฉิน)', 'subtitle': '1669'},
  ];

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

    if (weatherCode == 95) {
      return Icons.thunderstorm;
    }

    return Icons.cloud;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ยินดีต้อนรับสู่หอพัก',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            'กรุณาอ่านกฎระเบียบและเก็บเบอร์ติดต่อไว้',
            style: TextStyle(fontSize: 15, color: AppTheme.green),
          ),

          const SizedBox(height: 25),

          FutureBuilder<WeatherData>(
            future: _weatherFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Text('ไม่สามารถโหลดข้อมูลอากาศได้');
              }

              if (!snapshot.hasData) {
                return const Text('ไม่มีข้อมูลสภาพอากาศ');
              }

              final weather = snapshot.data!;

              return Card(
                color: AppTheme.surface,
                child: ListTile(
                  leading: Icon(
                    _weatherIcon(weather.weatherCode),
                    color: AppTheme.terracotta,
                    size: 40,
                  ),
                  title: const Text('สภาพอากาศ'),
                  subtitle: Text(weather.conditionText),
                  trailing: Text(
                    '${weather.temperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          Center(
            child: SizedBox(
              width: 250,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.green,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ItemScreen()),
                  );
                },
                child: const Text(
                  'จองสิ่งอำนวยความสะดวก',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),
                ),
              ),
            ),
          ),

          const SizedBox(height: 60),

          Row(
            children: [
              Icon(Icons.rule, color: AppTheme.green),
              SizedBox(width: 8),
              Text(
                'กฎระเบียบหอพัก',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Card(
            color: AppTheme.surface,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(_rules.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}.',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.green,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _rules[index],
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.4,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),

          const SizedBox(height: 25),

          Row(
            children: const [
              Icon(Icons.phone, color: AppTheme.green),
              SizedBox(width: 8),
              Text(
                'เบอร์ติดต่อ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Card(
            color: AppTheme.surface,
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: List.generate(_contacts.length, (index) {
                final contact = _contacts[index];

                return Column(
                  children: [
                    ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: AppTheme.sage,
                        child: Icon(Icons.phone_in_talk, color: AppTheme.green),
                      ),
                      title: Text(
                        contact['title']!,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(contact['subtitle']!),
                    ),
                    if (index != _contacts.length - 1)
                      const Divider(height: 1, color: AppTheme.sage),
                  ],
                );
              }),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
