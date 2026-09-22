import '../pages/home_page.dart';
import '../pages/my_reservation_page.dart';

import 'package:flutter/material.dart';
import '../pages/setting_profile_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainShell extends StatefulWidget{
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>{
  int selectedIndex = 0;

  final pages = const [
    HomePage(),
    MyReservationPage(),
    SettingProfilePage()
  ];

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: pages
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: GNav(
            selectedIndex: selectedIndex,
            onTabChange: (index){
              setState(() {
                selectedIndex = index;
              });
            },
            gap: 8,
            color: const Color(0xFF637067),
            activeColor: const Color(0xFF426B5A),
            tabBackgroundColor: const Color(0xFFE4F0E7),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 13,
            ),
            tabs: const [
              GButton(
                icon: Icons.home, text: "Home"
              ),
              GButton(
                icon: Icons.bookmark, text: "Booking",
              ),
              GButton(
                icon: Icons.settings, text: "Settings", 
              ),
            ],
          )
        )
      ),
    );
  }
}