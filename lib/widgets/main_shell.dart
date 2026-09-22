import 'package:final_project/pages/homepage.dart';

//import '../pages/home_page.dart';
import '../pages/my_reservation_page.dart';

import 'package:flutter/material.dart';
import '../pages/setting_profile_page.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../app_theme.dart';

class MainShell extends StatefulWidget{
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell>{
  int selectedIndex = 0;

  final pages = const [
    Homepage(),
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
          color: AppTheme.surface,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: GNav(
            selectedIndex: selectedIndex,
            onTabChange: (index){
              setState(() {
                selectedIndex = index;
              });
            },
            gap: 8,
            color: AppTheme.textDark,
            activeColor: AppTheme.green,
            tabBackgroundColor: AppTheme.sage,
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
