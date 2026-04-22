import 'package:bikkie/ui/screens/login_screen/login_screen.dart';
import 'package:bikkie/ui/screens/pass_screen/pass_screen.dart';
import 'package:bikkie/ui/screens/profile_screen/profile_screen.dart';
import 'package:bikkie/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/rentingRepository/renting_repository.dart';
import 'data/repositories/stationRepository/station_repository.dart';
import 'data/repositories/userRepository/user_repository.dart';
import 'ui/screens/map_screen/map_screen.dart';
import 'ui/screens/map_screen/view_model/map_view_model.dart';
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

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, _) {
        if (!authService.isLoggedIn) {
          return const LoginScreen();
        }
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

  // MapViewModel is created ONCE here and survives tab switches + navigation.
  // This means when popUntil(isFirst) fires, the existing ViewModel is reused
  // and hasPendingPickup is already true — the banner appears instantly.
  late final MapViewModel _mapViewModel;

  @override
  void initState() {
    super.initState();
    _mapViewModel = MapViewModel(
      context.read<StationRepository>(),
      context.read<UserRepository>(),
      context.read<RentingRepository>(),
    );
  }

  @override
  void dispose() {
    _mapViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapViewModel>.value(
      value: _mapViewModel,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: IndexedStack(
            // IndexedStack keeps all pages alive — no rebuild on tab switch.
            index: _currentIndex,
            children: const [PassScreen(), MapScreen(), ProfileScreen()],
          ),
          bottomNavigationBar: BottomNavigationBarTheme(
            data: AppTheme.lightTheme.bottomNavigationBarTheme,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: [
                BottomNavigationBarItem(
                  icon: Icon(
                    _currentIndex == 0
                        ? Icons.confirmation_num
                        : Icons.confirmation_num_outlined,
                  ),
                  label: 'Pass',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    _currentIndex == 1 ? Icons.map : Icons.map_outlined,
                  ),
                  label: 'Map',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    _currentIndex == 2 ? Icons.person : Icons.person_outlined,
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
