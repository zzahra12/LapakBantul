import 'package:flutter/material.dart';
// Import semua halaman yang mau dituju
import 'home_page.dart';
import 'pbb_page.dart';
import 'api_demo_page.dart';
import 'layanan_keliling.dart';

class MainNavigation extends StatelessWidget {
  final int currentIndex;

  const MainNavigation({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: const Color(0xFF003566),
      unselectedItemColor: Colors.grey,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      onTap: (index) {
        if (index == currentIndex) return;

        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PBBPage()),
          );
        }
        // 🔥 Navigasi lainnya
        else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LayananKelilingPage(currentIndex: 2)),
          );
        } else if (index == 4) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LayananKelilingPage(currentIndex: 4)),
          );
        }
        // 🔥 SEKARANG SUDAH MASUK DI SINI (DI BAWAH INDEX == 1)
        else if (index == 5) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ApiDemoPage()),
          );
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'PBB'),
        BottomNavigationBarItem(icon: Icon(Icons.directions_car_outlined), label: 'Kendaraan'),
        BottomNavigationBarItem(icon: Icon(Icons.storefront_outlined), label: 'Usaha'),
        BottomNavigationBarItem(icon: Icon(Icons.directions_bus_outlined), label: 'Keliling'),
        BottomNavigationBarItem(icon: Icon(Icons.cloud_outlined), label: 'API Demo'),
      ],
    );
  }
}