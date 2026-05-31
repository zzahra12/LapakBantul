import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/splash/splash_screen.dart'; // 🚀 MEMANGGIL SPLASH SCREEN GURUMU

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LaPak Bantul',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: const Color(0xFF003566),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003566),
          primary: const Color(0xFF003566),
        ),
        useMaterial3: true,
      ),
      // 🚀 DI SINI UTAMANYA: Aplikasi wajib dibuka lewat SplashScreen dulu!
      home: const SplashScreen(), 
    );
  }
}