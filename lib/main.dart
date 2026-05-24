import 'package:flutter/material.dart';
// 1. IMPORT file splash screen kamu
import 'screens/splash/splash_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lapak Bantul',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Tips: Pakai colorScheme biar lebih modern (Material 3)
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF003566)),
        useMaterial3: true,
      ),
      // 2. GANTI HomePage() menjadi SplashScreen()
      home: const SplashScreen(), 
    );
  }
}