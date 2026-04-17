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
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const MapScreen(),
      ),
    ),
  );
}
