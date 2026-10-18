import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

class NadyApp extends StatelessWidget {
  const NadyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NaDy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF5B9BD5)),
        scaffoldBackgroundColor: const Color(0xFFF5F9FC),
      ),
      home: const DashboardScreen(),
    );
  }
}