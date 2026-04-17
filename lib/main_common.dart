import 'package:bikkie/ui/screens/pass_screen/pass_screen.dart';
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
        home: BikeApp(),
      ),
    ),
  );
}

class BikeApp extends StatefulWidget {
  const BikeApp({super.key});

  @override
  State<BikeApp> createState() => _BikeAppState();
}

class _BikeAppState extends State<BikeApp> {
  int _currentIndex = 1;

  final List<Widget> _pages = [PassScreen(), MapScreen(), Placeholder()];

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
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  (_currentIndex == 0)
                      ? Icons.confirmation_num
                      : Icons.confirmation_num_outlined,
                ),
                label: 'Pass'
              ),
              BottomNavigationBarItem(
                icon: Icon((_currentIndex == 1) ? Icons.map : Icons.map_outlined),
                label: 'Map'
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  (_currentIndex == 2) ? Icons.person : Icons.person_outlined,
                ),
                label: 'Profile'
              ),
            ],
          ),
        ),
      ),
    );
  }
}
