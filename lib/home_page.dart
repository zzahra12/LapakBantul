import 'package:flutter/material.dart';
import 'appbar.dart';
import 'pbb_page.dart';
import 'main_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      bottomNavigationBar: const MainNavigation(currentIndex: 0),
      body: Column(
        children: [

           Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            "Beranda",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/profile.png'), // ganti sesuai gambar kamu
          ),
        ],
      ),
    ),

          // 🔵 HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF0D3B66),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "LaPak Bantul",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Pusat layanan pajak terpadu",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage('assets/logo.png'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔳 GRID MENU
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                MenuItem(
                  title: "PBB",
                  icon: Icons.home,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PBBPage(),
                      ),
                    );
                  },
                ),
                const MenuItem(
                  title: "BPHTB",
                  icon: Icons.receipt,
                ),
                const MenuItem(
                  title: "Rekap",
                  icon: Icons.receipt,
                ),
                MenuItem(
                  title: "Layanan Keliling",
                  icon: Icons.directions_bus,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AppBarPage(),
                      ),
                    );
                  },
                ),
                const MenuItem(
                  title: "Informasi",
                  icon: Icons.info,
                ),
                const MenuItem(
                  title: "Lainnya",
                  icon: Icons.more_horiz,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 🔘 MENU ITEM (FIX SEMUA TOMBOL AKTIF)
class MenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onPressed;

  const MenuItem({
    super.key,
    required this.title,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ?? () {}, // 🔥 FIX UTAMA DI SINI
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}