import 'package:bikkie/ui/screens/login_screen/login_screen.dart';
import 'package:bikkie/ui/screens/pass_screen/pass_screen.dart';
import 'package:bikkie/ui/screens/profile_screen/profile_screen.dart';
import 'package:bikkie/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ui/screens/map_screen/map_screen.dart';
import 'utils/app_theme.dart';

void mainCommon(List<InheritedProvider> providers) {
  runApp(
    MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainApp(),
      ),
    ),
  );
}

/// Main app container that shows login or tabs based on auth state
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        // If not logged in, show login screen
        if (!authService.isLoggedIn) {
          return const LoginScreen();
        }

        // If logged in, show main app with tabs
        return const BikeApp();
      },
    );
  }
}

class BikeApp extends StatefulWidget {
  const BikeApp({super.key});

  @override
  State<BikeApp> createState() => _BikeAppState();
}

class _BikeAppState extends State<BikeApp> {
  int _currentIndex = 1;

  void tabSwitch(int newTab) {
    setState(() {
      _currentIndex = newTab;
    });
  }

  List<Widget> get _pages => [
    const PassScreen(),
    const MapScreen(),
    ProfileScreen(switchTab: tabSwitch),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _pages[_currentIndex],

        bottomNavigationBar: BottomNavigationBarTheme(
          data: AppTheme.lightTheme.bottomNavigationBarTheme,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: tabSwitch,
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  (_currentIndex == 0)
                      ? Icons.confirmation_num
                      : Icons.confirmation_num_outlined,
                ),
                label: 'Pass',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  (_currentIndex == 1) ? Icons.map : Icons.map_outlined,
                ),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  (_currentIndex == 2) ? Icons.person : Icons.person_outlined,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
