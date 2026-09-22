import 'package:flutter/material.dart';

import 'home_content.dart';
import '../app_theme.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [const HomeContent()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        foregroundColor: AppTheme.textDark,
        title: const Text(
          'DORM BOOKING',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: _pages[_selectedIndex],
    );
  }
}
