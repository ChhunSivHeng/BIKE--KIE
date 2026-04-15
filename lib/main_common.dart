import 'package:flutter/material.dart';

class BikkieApp extends StatelessWidget {
  const BikkieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bikkie Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text(''),
        ),
      ),
    );
  }
}
